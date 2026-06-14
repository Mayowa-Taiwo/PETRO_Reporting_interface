"""
Governance API (REQ-A-001: /v1/marts/governance/lineage).
"""
from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import text

from app.database import get_db

router = APIRouter()


@router.get("/lineage")
async def governance_lineage(
    target_table: str | None = Query(None),
    source_table: str | None = Query(None),
    run_id: str | None = Query(None),
    limit: int = Query(200, le=1000),
    db: AsyncSession = Depends(get_db),
):
    """Lineage graph: source → target. Same as GET /v1/metadata/lineage."""
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
