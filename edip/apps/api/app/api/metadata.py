from fastapi import APIRouter, Depends, Query
from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncSession

from app.auth import get_current_user
from app.database import get_db

router = APIRouter()


@router.get("/dictionary/tables")
async def dictionary_tables(
    schema: str | None = Query(None),
    db: AsyncSession = Depends(get_db),
    user: dict = Depends(get_current_user),
):
    """Table list from information_schema."""
    schemas = ["ppdm_lite", "marts_shared", "marts_production", "meta"] if not schema else [schema]
    placeholders = ", ".join([f":s{i}" for i in range(len(schemas))])
    params = {f"s{i}": s for i, s in enumerate(schemas)}
    r = await db.execute(
        text(f"""
            SELECT table_schema, table_name
            FROM information_schema.tables
            WHERE table_schema IN ({placeholders}) AND table_type = 'BASE TABLE'
            ORDER BY table_schema, table_name
        """),
        params,
    )
    rows = r.fetchall()
    return [{"schema": r[0], "table": r[1]} for r in rows]


@router.get("/dictionary/tables/{table_name}/columns")
async def dictionary_columns(
    table_name: str,
    schema: str = Query("ppdm_lite"),
    db: AsyncSession = Depends(get_db),
    user: dict = Depends(get_current_user),
):
    """Column list for a table (schema query param)."""
    r = await db.execute(
        text("""
            SELECT column_name, ordinal_position, data_type, is_nullable
            FROM information_schema.columns
            WHERE table_schema = :sch AND table_name = :tbl
            ORDER BY ordinal_position
        """),
        {"sch": schema, "tbl": table_name},
    )
    rows = r.fetchall()
    return [{"column_name": r[0], "ordinal_position": r[1], "data_type": r[2], "is_nullable": r[3] == "YES"} for r in rows]


@router.get("/lineage")
async def lineage(
    target_table: str | None = Query(None),
    db: AsyncSession = Depends(get_db),
    user: dict = Depends(get_current_user),
):
    """Lineage: L_PPDM_ORIGIN or meta.lineage_edge."""
    try:
        r = await db.execute(
            text("""
                SELECT source_table_name, source_column_name, target_table_name, target_column_name, run_id
                FROM ppdm_lite.l_ppdm_origin
                WHERE 1=1
                ORDER BY 1, 2
                LIMIT 200
            """),
        )
        rows = r.fetchall()
    except Exception:
        r = await db.execute(
            text("""
                SELECT source_table, source_column, target_table, target_column, run_id
                FROM meta.lineage_edge
                ORDER BY 1, 2
                LIMIT 200
            """),
        )
        rows = r.fetchall()
    return {
        "edges": [
            {"source_table": r[0], "source_column": r[1], "target_table": r[2], "target_column": r[3], "run_id": str(r[4]) if r[4] else None}
            for r in rows
        ],
    }


@router.get("/exceptions")
async def exceptions(
    table_name: str | None = Query(None),
    run_id: str | None = Query(None),
    limit: int = Query(200, le=1000),
    db: AsyncSession = Depends(get_db),
    user: dict = Depends(get_current_user),
):
    """Exceptions from meta.data_exception or ppdm_lite.l_ppdm_exception."""
    try:
        sql = "SELECT exception_id, table_name, column_name, exception_type, error_message, exception_date, run_id FROM meta.data_exception WHERE 1=1"
        params = {"limit": limit}
        if table_name:
            sql += " AND table_name ILIKE :tbl"
            params["tbl"] = f"%{table_name}%"
        if run_id:
            sql += " AND run_id::text = :rid"
            params["rid"] = run_id
        sql += " ORDER BY exception_date DESC NULLS LAST LIMIT :limit"
        r = await db.execute(text(sql), params)
        rows = r.fetchall()
    except Exception:
        rows = []
    return {
        "exceptions": [
            {"exception_id": r[0], "table_name": r[1], "column_name": r[2], "exception_type": r[3], "error_message": r[4], "exception_date": r[5].isoformat() if r[5] else None, "run_id": str(r[6]) if r[6] else None}
            for r in rows
        ],
    }
