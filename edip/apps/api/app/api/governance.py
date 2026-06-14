from fastapi import APIRouter, Depends, Query
from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncSession

from app.auth import get_current_user
from app.database import get_db

router = APIRouter()


@router.get("/dq-scores")
async def dq_scores(
    mart_id: str | None = Query(None),
    db: AsyncSession = Depends(get_db),
    user: dict = Depends(get_current_user),
):
    """DQ scores from marts_governance.fact_dq_score (or meta)."""
    try:
        sql = """
            SELECT mart_id, run_id, essential_coverage_pct, enhanced_coverage_pct, dq_score, certified_ind, computed_at
            FROM marts_governance.fact_dq_score
            WHERE tenant_id = :tid
        """
        params = {"tid": user["tenant_id"]}
        if mart_id:
            sql += " AND mart_id = :mart_id"
            params["mart_id"] = mart_id
        sql += " ORDER BY computed_at DESC LIMIT 50"
        r = await db.execute(text(sql), params)
        rows = r.fetchall()
    except Exception:
        rows = []
    return [
        {
            "mart_id": r[0], "run_id": str(r[1]) if r[1] else None,
            "essential_coverage_pct": float(r[2]) if r[2] else None,
            "enhanced_coverage_pct": float(r[3]) if r[3] else None,
            "dq_score": float(r[4]) if r[4] else None,
            "certified_ind": r[5],
            "computed_at": r[6].isoformat() if r[6] else None,
        }
        for r in rows
    ]
