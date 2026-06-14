"""
Metadata & catalog API (REQ-MD-001, REQ-MD-002, REQ-MD-003).
Data dictionary, lineage, exception monitor.
"""
from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import text

from app.database import get_db

router = APIRouter()


@router.get("/dictionary")
async def data_dictionary(
    schema: str | None = Query(None, description="Filter by schema: ppdm_lite, marts, conformed, meta"),
    db: AsyncSession = Depends(get_db),
):
    """Table and column list with types and comments (REQ-MD-001). From information_schema + L_PPDM_TABLE/L_PPDM_COLUMN when available."""
    schemas = ["ppdm_lite", "marts", "conformed", "meta"] if schema is None else [schema]
    placeholders = ", ".join([f":s{i}" for i in range(len(schemas))])
    params = {f"s{i}": s for i, s in enumerate(schemas)}
    r = await db.execute(text(f"""
        SELECT table_schema, table_name, column_name, ordinal_position, data_type, is_nullable
        FROM information_schema.columns
        WHERE table_schema IN ({placeholders})
        AND table_schema NOT LIKE 'pg_%'
        ORDER BY table_schema, table_name, ordinal_position
    """), params)
    rows = r.fetchall()
    tables: dict = {}
    for row in rows:
        sch, tbl, col, pos, dtype, nullable = row
        key = f"{sch}.{tbl}"
        if key not in tables:
            tables[key] = {"schema": sch, "table": tbl, "columns": []}
        tables[key]["columns"].append({
            "column_name": col,
            "ordinal_position": pos,
            "data_type": dtype,
            "is_nullable": nullable == "YES",
        })
    return {"tables": list(tables.values())}


@router.get("/lineage")
async def lineage(
    target_table: str | None = Query(None),
    source_table: str | None = Query(None),
    run_id: str | None = Query(None),
    limit: int = Query(200, le=1000),
    db: AsyncSession = Depends(get_db),
):
    """Lineage from L_PPDM_ORIGIN: source → target edges (REQ-MD-002). Impact: downstream objects for a source."""
    try:
        sql = """
            SELECT source_table_name, source_column_name, target_table_name, target_column_name, run_id, created_at
            FROM ppdm_lite.l_ppdm_origin
            WHERE 1=1
        """
        params = {"limit": limit}
        if target_table:
            sql += " AND target_table_name ILIKE :target_table"
            params["target_table"] = f"%{target_table}%"
        if source_table:
            sql += " AND source_table_name ILIKE :source_table"
            params["source_table"] = f"%{source_table}%"
        if run_id:
            sql += " AND run_id::text = :run_id"
            params["run_id"] = run_id
        sql += " ORDER BY created_at DESC NULLS LAST LIMIT :limit"
        r = await db.execute(text(sql), params)
        rows = r.fetchall()
        edges = [
            {
                "source_table": row[0], "source_column": row[1],
                "target_table": row[2], "target_column": row[3],
                "run_id": str(row[4]) if row[4] else None,
                "created_at": row[5].isoformat() if row[5] else None,
            }
            for row in rows
        ]
        return {"edges": edges, "count": len(edges)}
    except Exception:
        return {"edges": [], "count": 0}


@router.get("/exceptions")
async def exceptions(
    table_name: str | None = Query(None),
    run_id: str | None = Query(None),
    group_by: str | None = Query(None, pattern="^(table|column|run|date)$"),
    limit: int = Query(500, le=2000),
    db: AsyncSession = Depends(get_db),
):
    """Exception monitor: aggregate L_PPDM_EXCEPTION by table/column/run/date (REQ-MD-003)."""
    if group_by:
        try:
            if group_by == "table":
                r = await db.execute(text("""
                    SELECT exception_table_name AS group_key, COUNT(*) AS exception_count
                    FROM ppdm_lite.l_ppdm_exception
                    WHERE (:tbl IS NULL OR exception_table_name ILIKE :tbl)
                    AND (:rid::uuid IS NULL OR run_id = :rid::uuid)
                    GROUP BY exception_table_name
                    ORDER BY exception_count DESC
                    LIMIT :limit
                """), {"tbl": f"%{table_name}%" if table_name else None, "rid": run_id or None, "limit": limit})
            elif group_by == "column":
                r = await db.execute(text("""
                    SELECT exception_table_name || '.' || COALESCE(exception_column_name, '') AS group_key, COUNT(*) AS exception_count
                    FROM ppdm_lite.l_ppdm_exception
                    WHERE (:tbl IS NULL OR exception_table_name ILIKE :tbl)
                    AND (:rid::uuid IS NULL OR run_id = :rid::uuid)
                    GROUP BY exception_table_name, exception_column_name
                    ORDER BY exception_count DESC
                    LIMIT :limit
                """), {"tbl": f"%{table_name}%" if table_name else None, "rid": run_id or None, "limit": limit})
            elif group_by == "run":
                r = await db.execute(text("""
                    SELECT run_id::text AS group_key, COUNT(*) AS exception_count
                    FROM ppdm_lite.l_ppdm_exception
                    WHERE (:tbl IS NULL OR exception_table_name ILIKE :tbl)
                    GROUP BY run_id
                    ORDER BY exception_count DESC
                    LIMIT :limit
                """), {"tbl": f"%{table_name}%" if table_name else None, "limit": limit})
            else:
                r = await db.execute(text("""
                    SELECT date_trunc('day', exception_date)::date::text AS group_key, COUNT(*) AS exception_count
                    FROM ppdm_lite.l_ppdm_exception
                    WHERE (:tbl IS NULL OR exception_table_name ILIKE :tbl)
                    AND (:rid::uuid IS NULL OR run_id = :rid::uuid)
                    GROUP BY date_trunc('day', exception_date)
                    ORDER BY group_key DESC
                    LIMIT :limit
                """), {"tbl": f"%{table_name}%" if table_name else None, "rid": run_id or None, "limit": limit})
            rows = r.fetchall()
            return {"group_by": group_by, "aggregates": [{"group_key": row[0], "exception_count": row[1]} for row in rows]}
        except Exception:
            return {"group_by": group_by, "aggregates": []}
    sql = """
        SELECT exception_id, exception_table_name, exception_column_name, exception_type, error_message, exception_date, run_id
        FROM ppdm_lite.l_ppdm_exception
        WHERE 1=1
    """
    params = {"limit": limit}
    if table_name:
        sql += " AND exception_table_name ILIKE :tbl"
        params["tbl"] = f"%{table_name}%"
    if run_id:
        sql += " AND run_id::text = :rid"
        params["rid"] = run_id
    sql += " ORDER BY exception_date DESC NULLS LAST LIMIT :limit"
    try:
        r = await db.execute(text(sql), params)
        rows = r.fetchall()
        return {
            "exceptions": [
                {
                    "exception_id": row[0], "exception_table_name": row[1], "exception_column_name": row[2],
                    "exception_type": row[3], "error_message": row[4],
                    "exception_date": row[5].isoformat() if row[5] else None,
                    "run_id": str(row[6]) if row[6] else None,
                }
                for row in rows
            ],
        }
    except Exception:
        return {"exceptions": []}
