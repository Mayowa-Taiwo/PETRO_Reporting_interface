from uuid import uuid4

from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import text
from pydantic import BaseModel

from app.auth import require_roles
from app.database import get_db

router = APIRouter()

# 60/40 DQ computation (matches scripts/dq/compute_dq_scores.sql)
_DQ_SQL = """
WITH
contract AS (
  SELECT c.table_name, c.column_name
  FROM ppdm_lite.l_ppdm_column c
  WHERE c.table_name = :target_table
),
policy AS (
  SELECT table_name, column_name,
         COALESCE(ep.is_essential,
           (column_name IN ('pden_id','pden_type','pden_source','data_source','ppdm_guid','volume_date','volume_method','activity_type','spatial_description_id','spatial_obs_no'))
           OR column_name LIKE '%_id' OR column_name = 'data_source' OR column_name = 'ppdm_guid'
         ) AS is_essential
  FROM contract co
  LEFT JOIN meta.essential_policy ep ON ep.table_name = co.table_name AND ep.column_name = co.column_name
),
mapped AS (
  SELECT m.target_table, m.target_column, COALESCE(p.is_essential, true) AS is_essential
  FROM meta.mapping_registry m
  JOIN policy p ON p.table_name = m.target_table AND p.column_name = m.target_column
  WHERE m.is_enabled AND m.target_table = :target_table
),
with_valid AS (
  SELECT m.target_column, m.is_essential,
    EXISTS (
      SELECT 1 FROM ppdm_lite.l_ppdm_origin o
      WHERE o.run_id = :run_id AND o.target_table_name = :target_table AND o.target_column_name = m.target_column
    ) AS valid
  FROM mapped m
),
coverage AS (
  SELECT
    :run_id::uuid AS run_id,
    :target_table::text AS target_table,
    COALESCE(SUM(CASE WHEN is_essential THEN 1 ELSE 0 END), 0)::int AS essential_total,
    COALESCE(SUM(CASE WHEN is_essential AND valid THEN 1 ELSE 0 END), 0)::int AS essential_valid,
    COALESCE(SUM(CASE WHEN NOT is_essential THEN 1 ELSE 0 END), 0)::int AS optional_total,
    COALESCE(SUM(CASE WHEN NOT is_essential AND valid THEN 1 ELSE 0 END), 0)::int AS optional_valid
  FROM with_valid
)
SELECT
  run_id, target_table,
  essential_total, essential_valid, optional_total, optional_valid,
  CASE WHEN essential_total = 0 THEN 0 ELSE ROUND((essential_valid::numeric / essential_total) * 100, 2) END AS essential_coverage_pct,
  CASE WHEN optional_total = 0 THEN 0 ELSE ROUND((optional_valid::numeric / NULLIF(optional_total,0)) * 100, 2) END AS optional_coverage_pct,
  CASE
    WHEN essential_total > 0 AND (essential_valid::numeric / essential_total) < 0.90 THEN 59
    ELSE ROUND(
      COALESCE(60 * (essential_valid::numeric / NULLIF(essential_total,0)), 0) +
      COALESCE(40 * (optional_valid::numeric / NULLIF(optional_total,0)), 0), 2)
  END AS dq_score_final,
  (essential_total = 0 OR (essential_valid::numeric / essential_total) >= 0.90)
    AND (COALESCE(60 * (essential_valid::numeric / NULLIF(essential_total,0)), 0) + COALESCE(40 * (optional_valid::numeric / NULLIF(optional_total,0)), 0)) >= 80 AS certified_ind
FROM coverage
"""


class RunJobRequest(BaseModel):
    source_id: str
    mode: str = "full_refresh"


@router.post("/run")
async def run_job(
    body: RunJobRequest,
    db: AsyncSession = Depends(get_db),
    _user: dict = Depends(require_roles(["admin"])),
):
    """Start an ingest+transform+publish job. MVP: creates a run and runs minimal pipeline."""
    run_id = uuid4()
    await db.execute(text("""
        INSERT INTO meta.ingest_run (run_id, source_id, started_at, status, mode, notes)
        VALUES (:run_id, :source_id, now(), 'running', :mode, 'EDIP MVP run')
    """), {"run_id": run_id, "source_id": body.source_id, "mode": body.mode})
    await db.commit()

    # MVP: copy from silver staging to ppdm_lite if any staging data exists; write lineage; compute DQ
    try:
        # Publish from silver to ppdm_lite (example: pden_staging -> l_pden)
        await db.execute(text("""
            INSERT INTO ppdm_lite.l_pden (pden_id, pden_type, pden_source, pden_name, data_source, remark)
            SELECT pden_id, pden_type, pden_source, pden_name, data_source, 'From silver'
            FROM silver.pden_staging WHERE run_id = :run_id
            ON CONFLICT (pden_id, pden_type, pden_source) DO UPDATE SET pden_name = EXCLUDED.pden_name, data_source = EXCLUDED.data_source
        """), {"run_id": run_id})
        # Lineage for l_pden columns
        for col in ["pden_id", "pden_type", "pden_source", "pden_name", "data_source"]:
            await db.execute(text("""
                INSERT INTO ppdm_lite.l_ppdm_origin (source_table_name, source_column_name, target_table_name, target_column_name, run_id)
                VALUES ('pden_staging', :col, 'l_pden', :col, :run_id)
            """), {"col": col, "run_id": run_id})
        # Real DQ computation (60/40 + essential cap) for each published table
        for target_table in ["l_pden"]:
            dq_result = await db.execute(text(_DQ_SQL), {"run_id": run_id, "target_table": target_table})
            dq_row = dq_result.fetchone()
            if dq_row:
                (_, _, ess_tot, ess_val, opt_tot, opt_val, ess_pct, opt_pct, dq_score, cert) = dq_row
                await db.execute(text("""
                    INSERT INTO meta.dq_table_score (run_id, target_table, essential_total, essential_valid, optional_total, optional_valid, essential_coverage_pct, optional_coverage_pct, dq_score, certified_ind)
                    VALUES (:run_id, :target_table, :ess_tot, :ess_val, :opt_tot, :opt_val, :ess_pct, :opt_pct, :dq_score, :cert)
                    ON CONFLICT (run_id, target_table) DO UPDATE SET
                      essential_total = EXCLUDED.essential_total, essential_valid = EXCLUDED.essential_valid,
                      optional_total = EXCLUDED.optional_total, optional_valid = EXCLUDED.optional_valid,
                      essential_coverage_pct = EXCLUDED.essential_coverage_pct, optional_coverage_pct = EXCLUDED.optional_coverage_pct,
                      dq_score = EXCLUDED.dq_score, certified_ind = EXCLUDED.certified_ind, computed_at = now()
                """), {
                    "run_id": run_id, "target_table": target_table,
                    "ess_tot": ess_tot or 0, "ess_val": ess_val or 0, "opt_tot": opt_tot or 0, "opt_val": opt_val or 0,
                    "ess_pct": float(ess_pct or 0), "opt_pct": float(opt_pct or 0), "dq_score": float(dq_score or 0), "cert": cert if cert is not None else False,
                })
        await db.execute(text("""
            UPDATE meta.ingest_run SET finished_at = now(), status = 'succeeded' WHERE run_id = :run_id
        """), {"run_id": run_id})
    except Exception as e:
        await db.execute(text("""
            UPDATE meta.ingest_run SET finished_at = now(), status = 'failed', notes = :notes WHERE run_id = :run_id
        """), {"run_id": run_id, "notes": str(e)})
        await db.execute(text("""
            INSERT INTO ppdm_lite.l_ppdm_exception (exception_table_name, error_message, run_id) VALUES ('l_pden', :msg, :run_id)
        """), {"msg": str(e), "run_id": run_id})
    await db.commit()

    return {"run_id": str(run_id), "status": "started", "message": "Job run created. Check GET /v1/jobs/runs/{run_id} for result."}


@router.get("/runs")
async def list_runs(limit: int = 50, db: AsyncSession = Depends(get_db)):
    r = await db.execute(text("""
        SELECT run_id, source_id, started_at, finished_at, status, mode, notes
        FROM meta.ingest_run ORDER BY started_at DESC LIMIT :lim
    """), {"lim": limit})
    rows = r.fetchall()
    return [
        {
            "run_id": str(row[0]), "source_id": str(row[1]),
            "started_at": row[2].isoformat() if row[2] else None,
            "finished_at": row[3].isoformat() if row[3] else None,
            "status": row[4], "mode": row[5], "notes": row[6],
        }
        for row in rows
    ]


@router.get("/runs/{run_id}")
async def get_run(run_id: str, db: AsyncSession = Depends(get_db)):
    r = await db.execute(text("""
        SELECT run_id, source_id, started_at, finished_at, status, mode, notes
        FROM meta.ingest_run WHERE run_id = :run_id
    """), {"run_id": run_id})
    row = r.fetchone()
    if not row:
        return {"detail": "Run not found"}
    return {
        "run_id": str(row[0]), "source_id": str(row[1]),
        "started_at": row[2].isoformat() if row[2] else None,
        "finished_at": row[3].isoformat() if row[3] else None,
        "status": row[4], "mode": row[5], "notes": row[6],
    }
