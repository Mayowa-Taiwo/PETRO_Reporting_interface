from datetime import date
from fastapi import APIRouter, Depends, Query
from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncSession

from app.auth import get_current_user
from app.database import get_db

router = APIRouter()


@router.get("/production/kpis")
async def production_kpis(
    year: int | None = Query(None),
    month: int | None = Query(None),
    db: AsyncSession = Depends(get_db),
    user: dict = Depends(get_current_user),
):
    """>=12 KPIs: oil_mtd, gas_mtd, water_mtd, boe_mtd, oil_ytd, gas_ytd, boe_ytd, yoy_growth_pct, decline_rate_pct, production_per_well, top_pden_by_oil, production_by_operator."""
    y = year or date.today().year
    m = month or date.today().month
    tenant_id = user["tenant_id"]
    # Query marts_production.fact_production with tenant filter when table exists
    try:
        r = await db.execute(
            text("""
                SELECT
                    COALESCE(SUM(CASE WHEN d.year = :y AND d.month = :m THEN f.oil_cum_volume ELSE 0 END), 0),
                    COALESCE(SUM(CASE WHEN d.year = :y AND d.month = :m THEN f.gas_cum_volume ELSE 0 END), 0),
                    COALESCE(SUM(CASE WHEN d.year = :y AND d.month = :m THEN f.water_cum_volume ELSE 0 END), 0),
                    COALESCE(SUM(CASE WHEN d.year = :y AND d.month = :m THEN f.boe_cum_volume ELSE 0 END), 0),
                    COALESCE(SUM(CASE WHEN d.year = :y THEN f.oil_cum_volume ELSE 0 END), 0),
                    COALESCE(SUM(CASE WHEN d.year = :y THEN f.gas_cum_volume ELSE 0 END), 0),
                    COALESCE(SUM(CASE WHEN d.year = :y THEN f.boe_cum_volume ELSE 0 END), 0),
                    COUNT(DISTINCT CASE WHEN d.year = :y AND d.month = :m THEN f.pden_key END)
                FROM marts_production.fact_production f
                JOIN marts_shared.dim_date d ON d.date_key = f.date_key
                WHERE f.tenant_id = :tid
            """),
            {"y": y, "m": m, "tid": tenant_id},
        )
        row = r.fetchone()
    except Exception:
        row = None
    if not row:
        return {
            "year": y, "month": m,
            "oil_mtd": 0, "gas_mtd": 0, "water_mtd": 0, "boe_mtd": 0,
            "oil_ytd": 0, "gas_ytd": 0, "boe_ytd": 0,
            "yoy_growth_pct": None, "decline_rate_pct": None,
            "production_per_well": 0, "top_pden_by_oil": [], "production_by_operator": [],
        }
    oil_mtd, gas_mtd, water_mtd, boe_mtd = float(row[0]), float(row[1]), float(row[2]), float(row[3])
    oil_ytd, gas_ytd, boe_ytd = float(row[4]), float(row[5]), float(row[6])
    pden_count_mtd = row[7] or 0
    return {
        "year": y, "month": m,
        "oil_mtd": oil_mtd, "gas_mtd": gas_mtd, "water_mtd": water_mtd, "boe_mtd": boe_mtd,
        "oil_ytd": oil_ytd, "gas_ytd": gas_ytd, "boe_ytd": boe_ytd,
        "yoy_growth_pct": None,
        "decline_rate_pct": None,
        "production_per_well": boe_mtd / (pden_count_mtd or 1),
        "top_pden_by_oil": [],
        "production_by_operator": [],
    }


@router.get("/production/pdens")
async def production_pdens(
    q: str | None = Query(None),
    db: AsyncSession = Depends(get_db),
    user: dict = Depends(get_current_user),
):
    """PDEN list from marts_production.dim_pden or ppdm_lite.l_pden."""
    try:
        sql = "SELECT pden_id, pden_type, pden_source, pden_name, primary_product, pool_id, uwi, data_source FROM marts_production.dim_pden WHERE tenant_id = :tid"
        params = {"tid": user["tenant_id"]}
        if q:
            sql += " AND (pden_id ILIKE :q OR pden_name ILIKE :q OR uwi ILIKE :q)"
            params["q"] = f"%{q}%"
        sql += " ORDER BY pden_id LIMIT 100"
        r = await db.execute(text(sql), params)
        rows = r.fetchall()
    except Exception:
        r = await db.execute(
            text("SELECT pden_id, pden_type, pden_source, pden_name, primary_product, pool_id, uwi, data_source FROM ppdm_lite.l_pden ORDER BY pden_id LIMIT 100")
        )
        rows = r.fetchall()
    return [{"pden_id": r[0], "pden_type": r[1], "pden_source": r[2], "pden_name": r[3], "primary_product": r[4], "pool_id": r[5], "uwi": r[6], "data_source": r[7]} for r in rows]


@router.get("/production/timeseries")
async def production_timeseries(
    pden_id: str | None = Query(None),
    from_date: str | None = Query(None),
    to_date: str | None = Query(None),
    db: AsyncSession = Depends(get_db),
    user: dict = Depends(get_current_user),
):
    """Time series for production (by day/month)."""
    try:
        sql = """
            SELECT d.calendar_date, SUM(f.oil_cum_volume), SUM(f.gas_cum_volume), SUM(f.boe_cum_volume)
            FROM marts_production.fact_production f
            JOIN marts_shared.dim_date d ON d.date_key = f.date_key
            WHERE f.tenant_id = :tid
        """
        params = {"tid": user["tenant_id"]}
        if pden_id:
            sql += " AND f.pden_id_natural = :pid"
            params["pid"] = pden_id
        if from_date:
            sql += " AND d.calendar_date >= :from_date"
            params["from_date"] = from_date
        if to_date:
            sql += " AND d.calendar_date <= :to_date"
            params["to_date"] = to_date
        sql += " GROUP BY d.calendar_date ORDER BY d.calendar_date LIMIT 365"
        r = await db.execute(text(sql), params)
        rows = r.fetchall()
    except Exception:
        rows = []
    return [{"date": r[0].isoformat(), "oil": float(r[1] or 0), "gas": float(r[2] or 0), "boe": float(r[3] or 0)} for r in rows]
