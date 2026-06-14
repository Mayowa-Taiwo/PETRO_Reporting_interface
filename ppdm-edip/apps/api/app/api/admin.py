from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import text

from app.database import get_db

router = APIRouter()


@router.get("/contract/tables")
async def contract_tables(db: AsyncSession = Depends(get_db)):
    r = await db.execute(text("""
        SELECT table_name, table_comment FROM ppdm_lite.l_ppdm_table ORDER BY table_name
    """))
    rows = r.fetchall()
    return [{"table_name": row[0], "table_comment": row[1]} for row in rows]


@router.get("/contract/tables/{table_name}/columns")
async def contract_columns(table_name: str, db: AsyncSession = Depends(get_db)):
    r = await db.execute(text("""
        SELECT column_name, column_sequence, column_comment
        FROM ppdm_lite.l_ppdm_column WHERE table_name = :t ORDER BY column_sequence
    """), {"t": table_name})
    rows = r.fetchall()
    return [{"column_name": row[0], "column_sequence": row[1], "column_comment": row[2]} for row in rows]


@router.get("/dq/scores")
async def dq_scores(run_id: str | None = Query(None), db: AsyncSession = Depends(get_db)):
    if run_id:
        r = await db.execute(text("""
            SELECT run_id, target_table, essential_total, essential_valid, optional_total, optional_valid,
                   essential_coverage_pct, optional_coverage_pct, dq_score, certified_ind, computed_at
            FROM meta.dq_table_score WHERE run_id = :rid ORDER BY target_table
        """), {"rid": run_id})
    else:
        r = await db.execute(text("""
            SELECT run_id, target_table, essential_total, essential_valid, optional_total, optional_valid,
                   essential_coverage_pct, optional_coverage_pct, dq_score, certified_ind, computed_at
            FROM meta.dq_table_score ORDER BY computed_at DESC, target_table LIMIT 200
        """))
    rows = r.fetchall()
    return [
        {
            "run_id": str(row[0]), "target_table": row[1],
            "essential_total": row[2], "essential_valid": row[3],
            "optional_total": row[4], "optional_valid": row[5],
            "essential_coverage_pct": float(row[6]), "optional_coverage_pct": float(row[7]),
            "dq_score": float(row[8]), "certified_ind": row[9], "computed_at": row[10].isoformat() if row[10] else None,
        }
        for row in rows
    ]


@router.get("/exceptions")
async def exceptions(
    run_id: str | None = Query(None),
    table_name: str | None = Query(None),
    db: AsyncSession = Depends(get_db),
):
    q = """
        SELECT exception_id, exception_table_name, exception_column_name, exception_type, error_message, run_id, exception_date
        FROM ppdm_lite.l_ppdm_exception WHERE 1=1
    """
    params = {}
    if run_id:
        q += " AND run_id = :run_id"
        params["run_id"] = run_id
    if table_name:
        q += " AND exception_table_name = :table_name"
        params["table_name"] = table_name
    q += " ORDER BY exception_date DESC LIMIT 500"
    r = await db.execute(text(q), params)
    rows = r.fetchall()
    return [
        {
            "exception_id": row[0], "exception_table_name": row[1], "exception_column_name": row[2],
            "exception_type": row[3], "error_message": row[4], "run_id": str(row[5]) if row[5] else None,
            "exception_date": row[6].isoformat() if row[6] else None,
        }
        for row in rows
    ]


@router.get("/lineage")
async def lineage(
    run_id: str | None = Query(None),
    target_table: str | None = Query(None),
    target_column: str | None = Query(None),
    db: AsyncSession = Depends(get_db),
):
    q = """
        SELECT source_table_name, source_column_name, target_table_name, target_column_name, business_rule, run_id, created_at
        FROM ppdm_lite.l_ppdm_origin WHERE 1=1
    """
    params = {}
    if run_id:
        q += " AND run_id = :run_id"
        params["run_id"] = run_id
    if target_table:
        q += " AND target_table_name = :target_table"
        params["target_table"] = target_table
    if target_column:
        q += " AND target_column_name = :target_column"
        params["target_column"] = target_column
    q += " ORDER BY created_at DESC LIMIT 500"
    r = await db.execute(text(q), params)
    rows = r.fetchall()
    return [
        {
            "source_table_name": row[0], "source_column_name": row[1],
            "target_table_name": row[2], "target_column_name": row[3],
            "business_rule": row[4], "run_id": str(row[5]) if row[5] else None,
            "created_at": row[6].isoformat() if row[6] else None,
        }
        for row in rows
    ]


@router.get("/sources")
async def list_sources(db: AsyncSession = Depends(get_db)):
    r = await db.execute(text("""
        SELECT source_id, source_name, source_type, is_enabled, created_at FROM meta.ingest_source ORDER BY source_name
    """))
    rows = r.fetchall()
    return [
        {"source_id": str(row[0]), "source_name": row[1], "source_type": row[2], "is_enabled": row[3], "created_at": row[4].isoformat() if row[4] else None}
        for row in rows
    ]
