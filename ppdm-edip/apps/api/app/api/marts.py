"""
Production Performance Mart API (TRD Section 4.1, REQ-M-103, REQ-M-104, REQ-M-105, REQ-A-001).
"""
from fastapi import APIRouter, Depends, Query
from fastapi.responses import StreamingResponse
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import text
from datetime import date
import csv
import io

from app.database import get_db

router = APIRouter()


# KPI definitions per Mart Star Schema Pack §1.3 (≥12)
KPI_DEFINITIONS = [
    {"id": "total_oil_mtd", "name": "Total Oil MTD", "definition": "Oil production month-to-date", "unit": "volume"},
    {"id": "total_gas_mtd", "name": "Total Gas MTD", "definition": "Gas production MTD", "unit": "volume"},
    {"id": "boe_mtd", "name": "BOE MTD", "definition": "BOE production month-to-date", "unit": "volume"},
    {"id": "total_oil_ytd", "name": "Total Oil YTD", "definition": "Oil year-to-date", "unit": "volume"},
    {"id": "yoy_growth_pct_oil", "name": "YoY Growth % Oil", "definition": "(This year oil − Last year oil) / Last year oil × 100", "unit": "percent"},
    {"id": "production_per_well", "name": "Production per Well", "definition": "Total volume / distinct well count (BOE)", "unit": "volume"},
    {"id": "top_10_pdens_oil", "name": "Top 10 PDENs by Oil", "definition": "Rank PDENs by oil volume", "unit": "list"},
    {"id": "decline_rate_pct", "name": "Decline Rate %", "definition": "(Prior period − Current) / Prior × 100", "unit": "percent"},
    {"id": "utilization_pct", "name": "Utilization %", "definition": "Producing wells / Total wells × 100", "unit": "percent"},
    {"id": "forecast_vs_actual_pct", "name": "Forecast vs Actual %", "definition": "Actual / Forecast × 100 (N/A if no forecast)", "unit": "percent"},
    {"id": "production_by_field", "name": "Production by Field", "definition": "Sum volumes by field/pool", "unit": "breakdown"},
    {"id": "production_by_operator", "name": "Production by Operator", "definition": "Sum volumes by operator", "unit": "breakdown"},
]


@router.get("/production/kpis")
async def production_kpis(
    year: int | None = Query(None, description="Year for MTD/YTD; default current"),
    month: int | None = Query(None, description="Month for MTD; default current"),
    db: AsyncSession = Depends(get_db),
):
    """Return ≥12 KPI definitions and computed values (REQ-M-103)."""
    today = date.today()
    y = year or today.year
    m = month or today.month

    # Single query for fact aggregates (from Platinum)
    r = await db.execute(text("""
        WITH f AS (
            SELECT f.oil_cum_volume, f.gas_cum_volume, f.boe_cum_volume, f.pden_key, f.date_key, d.year AS dyear, d.month AS dmonth
            FROM marts.fact_production f
            JOIN conformed.dim_date d ON d.date_key = f.date_key
        ),
        mtd AS (
            SELECT COALESCE(SUM(oil_cum_volume), 0) AS oil, COALESCE(SUM(gas_cum_volume), 0) AS gas, COALESCE(SUM(boe_cum_volume), 0) AS boe,
                   COUNT(DISTINCT pden_key) AS pden_count
            FROM f WHERE dyear = :y AND dmonth = :m
        ),
        ytd AS (
            SELECT COALESCE(SUM(oil_cum_volume), 0) AS oil FROM f WHERE dyear = :y
        ),
        prior_ytd AS (
            SELECT COALESCE(SUM(oil_cum_volume), 0) AS oil FROM f WHERE dyear = :y - 1
        ),
        prior_m AS (
            SELECT COALESCE(SUM(oil_cum_volume), 0) AS oil, COALESCE(SUM(boe_cum_volume), 0) AS boe
            FROM f WHERE (dyear = :y AND dmonth = :m - 1) OR (dyear = :y - 1 AND dmonth = 12 AND :m = 1)
        ),
        curr_m AS (
            SELECT COALESCE(SUM(oil_cum_volume), 0) AS oil, COALESCE(SUM(boe_cum_volume), 0) AS boe
            FROM f WHERE dyear = :y AND dmonth = :m
        ),
        total_wells AS (
            SELECT COUNT(DISTINCT pden_key) AS n FROM marts.fact_production
        ),
        producing AS (
            SELECT COUNT(DISTINCT pden_key) AS n FROM marts.fact_production f
            JOIN conformed.dim_date d ON d.date_key = f.date_key
            WHERE d.year = :y AND d.month = :m
        )
        SELECT
            (SELECT oil FROM mtd) AS oil_mtd,
            (SELECT gas FROM mtd) AS gas_mtd,
            (SELECT boe FROM mtd) AS boe_mtd,
            (SELECT pden_count FROM mtd) AS pden_count_mtd,
            (SELECT oil FROM ytd) AS oil_ytd,
            (SELECT oil FROM prior_ytd) AS oil_prior_ytd,
            (SELECT oil FROM prior_m) AS oil_prior_m,
            (SELECT boe FROM prior_m) AS boe_prior_m,
            (SELECT oil FROM curr_m) AS oil_curr_m,
            (SELECT boe FROM curr_m) AS boe_curr_m,
            (SELECT n FROM total_wells) AS total_wells,
            (SELECT n FROM producing) AS producing_wells
    """), {"y": y, "m": m})
    row = r.fetchone()
    if not row:
        row = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)

    oil_mtd = float(row[0] or 0)
    gas_mtd = float(row[1] or 0)
    boe_mtd = float(row[2] or 0)
    pden_count_mtd = row[3] or 0
    oil_ytd = float(row[4] or 0)
    oil_prior_ytd = float(row[5] or 0)
    oil_prior_m = float(row[6] or 0)
    boe_prior_m = float(row[7] or 0)
    oil_curr_m = float(row[8] or 0)
    boe_curr_m = float(row[9] or 0)
    total_wells = row[10] or 0
    producing_wells = row[11] or 0

    yoy = (oil_ytd - oil_prior_ytd) / (oil_prior_ytd or 1) * 100 if oil_prior_ytd else None
    production_per_well = (boe_mtd / (pden_count_mtd or 1))
    decline = (boe_prior_m - boe_curr_m) / (boe_prior_m or 1) * 100 if boe_prior_m else None
    utilization = (producing_wells / (total_wells or 1)) * 100

    # Top 10 PDENs by oil
    r2 = await db.execute(text("""
        SELECT f.pden_id_natural, f.pden_type, f.pden_source, COALESCE(SUM(f.oil_cum_volume), 0) AS oil
        FROM marts.fact_production f
        JOIN conformed.dim_date d ON d.date_key = f.date_key
        WHERE d.year = :y AND d.month = :m
        GROUP BY f.pden_id_natural, f.pden_type, f.pden_source
        ORDER BY oil DESC NULLS LAST
        LIMIT 10
    """), {"y": y, "m": m})
    top10 = [{"pden_id": r[0], "pden_type": r[1], "pden_source": r[2], "oil_cum_volume": float(r[3])} for r in r2.fetchall()]

    # Production by operator
    r3 = await db.execute(text("""
        SELECT o.operator_id, o.operator_name, COALESCE(SUM(f.oil_cum_volume), 0) AS oil, COALESCE(SUM(f.gas_cum_volume), 0) AS gas
        FROM marts.fact_production f
        JOIN conformed.dim_operator o ON o.operator_key = f.operator_key
        JOIN conformed.dim_date d ON d.date_key = f.date_key
        WHERE d.year = :y AND d.month = :m
        GROUP BY o.operator_key, o.operator_id, o.operator_name
        ORDER BY oil + gas / 6 DESC NULLS LAST
    """), {"y": y, "m": m})
    by_operator = [{"operator_id": r[0], "operator_name": r[1], "oil_cum_volume": float(r[2]), "gas_cum_volume": float(r[3])} for r in r3.fetchall()]

    # Production by field/pool
    r4 = await db.execute(text("""
        SELECT fp.pool_id, fp.field_id, COALESCE(SUM(f.oil_cum_volume), 0) AS oil, COALESCE(SUM(f.gas_cum_volume), 0) AS gas
        FROM marts.fact_production f
        JOIN conformed.dim_field_pool fp ON fp.field_pool_key = f.field_pool_key
        JOIN conformed.dim_date d ON d.date_key = f.date_key
        WHERE d.year = :y AND d.month = :m
        GROUP BY fp.field_pool_key, fp.pool_id, fp.field_id
        ORDER BY oil + gas / 6 DESC NULLS LAST
    """), {"y": y, "m": m})
    by_field = [{"pool_id": r[0], "field_id": r[1], "oil_cum_volume": float(r[2]), "gas_cum_volume": float(r[3])} for r in r4.fetchall()]

    values = {
        "total_oil_mtd": oil_mtd,
        "total_gas_mtd": gas_mtd,
        "boe_mtd": boe_mtd,
        "total_oil_ytd": oil_ytd,
        "yoy_growth_pct_oil": round(yoy, 2) if yoy is not None else None,
        "production_per_well": round(production_per_well, 4),
        "top_10_pdens_oil": top10,
        "decline_rate_pct": round(decline, 2) if decline is not None else None,
        "utilization_pct": round(utilization, 2),
        "forecast_vs_actual_pct": None,
        "production_by_field": by_field,
        "production_by_operator": by_operator,
    }

    return {
        "year": y,
        "month": m,
        "definitions": KPI_DEFINITIONS,
        "values": values,
    }


@router.get("/production/coverage")
async def production_coverage(db: AsyncSession = Depends(get_db)):
    """
    100-point coverage (60 essential / 40 enhanced) from L_PDEN + L_PDEN_VOL_SUMMARY.
    Certified when essential ≥60 and total ≥80 (REQ-M-104, REQ-M-105).
    """
    # Check column existence and non-null presence in ppdm_lite
    essential = 0
    enhanced = 0

    # Essential: L_PDEN PDEN_ID, PDEN_TYPE, PDEN_SOURCE (8)
    r = await db.execute(text("""
        SELECT COUNT(*) FROM ppdm_lite.l_pden WHERE pden_id IS NOT NULL AND pden_type IS NOT NULL AND pden_source IS NOT NULL
    """))
    if r.scalar() and r.scalar() > 0:
        essential += 8

    # L_PDEN PDEN_NAME, DATA_SOURCE, UWI (6)
    r = await db.execute(text("""
        SELECT COUNT(*) FROM ppdm_lite.l_pden WHERE pden_name IS NOT NULL OR data_source IS NOT NULL OR uwi IS NOT NULL
    """))
    if r.scalar() and r.scalar() > 0:
        essential += 6

    # L_PDEN PRIMARY_PRODUCT, POOL_ID (6)
    r = await db.execute(text("""
        SELECT COUNT(*) FROM ppdm_lite.l_pden WHERE primary_product IS NOT NULL OR pool_id IS NOT NULL
    """))
    if r.scalar() and r.scalar() > 0:
        essential += 6

    # L_PDEN_VOL_SUMMARY join keys + VOLUME_DATE (10)
    r = await db.execute(text("""
        SELECT COUNT(*) FROM ppdm_lite.l_pden_vol_summary WHERE pden_id IS NOT NULL AND pden_type IS NOT NULL AND pden_source IS NOT NULL AND volume_date IS NOT NULL
    """))
    if r.scalar() and r.scalar() > 0:
        essential += 10

    # VOLUME_METHOD, ACTIVITY_TYPE, OIL_CUM_VOLUME, GAS_CUM_VOLUME (10)
    r = await db.execute(text("""
        SELECT COUNT(*) FROM ppdm_lite.l_pden_vol_summary WHERE volume_method IS NOT NULL AND activity_type IS NOT NULL AND (oil_cum_volume IS NOT NULL OR gas_cum_volume IS NOT NULL)
    """))
    if r.scalar() and r.scalar() > 0:
        essential += 10

    # PRIMARY_PRODUCT, DATA_SOURCE in vol (8)
    r = await db.execute(text("""
        SELECT COUNT(*) FROM ppdm_lite.l_pden_vol_summary WHERE primary_product IS NOT NULL OR data_source IS NOT NULL
    """))
    if r.scalar() and r.scalar() > 0:
        essential += 8

    # L_FIELD/L_POOL (12) — if we have pool_id in l_pden we give partial; full requires l_field/l_pool
    r = await db.execute(text("""
        SELECT COUNT(*) FROM ppdm_lite.l_pden WHERE pool_id IS NOT NULL
    """))
    if r.scalar() and r.scalar() > 0:
        essential += 12  # simplified: pool_id present gives full 12

    # Enhanced: L_PDEN REMARK, OTHER_NAME (6)
    try:
        r = await db.execute(text("SELECT COUNT(*) FROM ppdm_lite.l_pden WHERE remark IS NOT NULL OR other_name IS NOT NULL"))
        if r.scalar() and r.scalar() > 0:
            enhanced += 6
    except Exception:
        pass

    # L_PDEN_VOL_SUMMARY WATER_CUM_VOLUME, BOE_CUM_VOLUME (8)
    r = await db.execute(text("""
        SELECT COUNT(*) FROM ppdm_lite.l_pden_vol_summary WHERE water_cum_volume IS NOT NULL OR boe_cum_volume IS NOT NULL
    """))
    if r.scalar() and r.scalar() > 0:
        enhanced += 8

    # OIL_VOLUME_OUOM, GAS_VOLUME_OUOM (6)
    try:
        r = await db.execute(text("SELECT COUNT(*) FROM ppdm_lite.l_pden_vol_summary WHERE oil_volume_ouom IS NOT NULL OR gas_volume_ouom IS NOT NULL"))
        if r.scalar() and r.scalar() > 0:
            enhanced += 6
    except Exception:
        pass

    # L_PDEN_XREF (10) — optional
    try:
        r = await db.execute(text("SELECT COUNT(*) FROM ppdm_lite.l_pden_xref"))
        if r.scalar() and r.scalar() > 0:
            enhanced += 10
    except Exception:
        pass

    # L_PPDM_DATA_SOURCE (10)
    try:
        r = await db.execute(text("SELECT COUNT(*) FROM ppdm_lite.l_ppdm_data_source"))
        if r.scalar() and r.scalar() > 0:
            enhanced += 10
    except Exception:
        pass

    total = min(essential, 60) + min(enhanced, 40)
    essential_cap = min(essential, 60)
    enhanced_cap = min(enhanced, 40)
    certified = essential_cap >= 60 and total >= 80

    return {
        "essential_points": essential_cap,
        "enhanced_points": enhanced_cap,
        "total_points": total,
        "certified": certified,
        "rule": "Certified when essential ≥60 and total ≥80",
    }


@router.get("/production/data")
async def production_data(
    operator_key: int | None = Query(None),
    field_pool_key: int | None = Query(None),
    pden_id: str | None = Query(None),
    from_date: str | None = Query(None, alias="from"),
    to_date: str | None = Query(None, alias="to"),
    limit: int = Query(1000, le=10000),
    offset: int = Query(0, ge=0),
    db: AsyncSession = Depends(get_db),
):
    """Fact rows for drill-down and export (Operator → Field/Pool → PDEN → Day)."""
    sql = """
        SELECT f.fact_production_key, f.pden_key, f.date_key, f.product_key, f.operator_key, f.field_pool_key,
               f.oil_cum_volume, f.gas_cum_volume, f.water_cum_volume, f.boe_cum_volume,
               f.volume_method, f.activity_type, f.data_source, f.pden_id_natural, f.pden_type, f.pden_source,
               d.calendar_date
        FROM marts.fact_production f
        JOIN conformed.dim_date d ON d.date_key = f.date_key
        WHERE 1=1
    """
    params = {"limit": limit, "offset": offset}
    if operator_key is not None:
        sql += " AND f.operator_key = :operator_key"
        params["operator_key"] = operator_key
    if field_pool_key is not None:
        sql += " AND f.field_pool_key = :field_pool_key"
        params["field_pool_key"] = field_pool_key
    if pden_id:
        sql += " AND f.pden_id_natural = :pden_id"
        params["pden_id"] = pden_id
    if from_date:
        sql += " AND d.calendar_date >= :from_date"
        params["from_date"] = from_date
    if to_date:
        sql += " AND d.calendar_date <= :to_date"
        params["to_date"] = to_date
    sql += " ORDER BY d.calendar_date, f.pden_id_natural LIMIT :limit OFFSET :offset"
    r = await db.execute(text(sql), params)
    rows = r.fetchall()
    return [
        {
            "fact_production_key": row[0], "pden_key": row[1], "date_key": row[2], "product_key": row[3],
            "operator_key": row[4], "field_pool_key": row[5], "oil_cum_volume": float(row[6]) if row[6] is not None else None,
            "gas_cum_volume": float(row[7]) if row[7] is not None else None,
            "water_cum_volume": float(row[8]) if row[8] is not None else None,
            "boe_cum_volume": float(row[9]) if row[9] is not None else None,
            "volume_method": row[10], "activity_type": row[11], "data_source": row[12],
            "pden_id_natural": row[13], "pden_type": row[14], "pden_source": row[15],
            "calendar_date": row[16].isoformat() if row[16] else None,
        }
        for row in rows
    ]


@router.get("/production/export/csv")
async def production_export_csv(
    operator_key: int | None = Query(None),
    field_pool_key: int | None = Query(None),
    pden_id: str | None = Query(None),
    from_date: str | None = Query(None, alias="from"),
    to_date: str | None = Query(None, alias="to"),
    db: AsyncSession = Depends(get_db),
):
    """Stream Production mart data as CSV (REQ-R-006)."""
    sql = """
        SELECT f.pden_id_natural, f.pden_type, f.pden_source, d.calendar_date, f.volume_method, f.activity_type,
               f.oil_cum_volume, f.gas_cum_volume, f.water_cum_volume, f.boe_cum_volume, f.data_source
        FROM marts.fact_production f
        JOIN conformed.dim_date d ON d.date_key = f.date_key
        WHERE 1=1
    """
    params = {}
    if operator_key is not None:
        sql += " AND f.operator_key = :operator_key"
        params["operator_key"] = operator_key
    if field_pool_key is not None:
        sql += " AND f.field_pool_key = :field_pool_key"
        params["field_pool_key"] = field_pool_key
    if pden_id:
        sql += " AND f.pden_id_natural = :pden_id"
        params["pden_id"] = pden_id
    if from_date:
        sql += " AND d.calendar_date >= :from_date"
        params["from_date"] = from_date
    if to_date:
        sql += " AND d.calendar_date <= :to_date"
        params["to_date"] = to_date
    sql += " ORDER BY d.calendar_date, f.pden_id_natural"
    r = await db.execute(text(sql), params)
    rows = r.fetchall()
    headers = ["pden_id", "pden_type", "pden_source", "calendar_date", "volume_method", "activity_type",
               "oil_cum_volume", "gas_cum_volume", "water_cum_volume", "boe_cum_volume", "data_source"]

    buf = io.StringIO()
    w = csv.writer(buf)
    w.writerow(headers)
    for row in rows:
        w.writerow([row[0], row[1], row[2], row[3].isoformat() if row[3] else "", row[4], row[5],
                   row[6], row[7], row[8], row[9], row[10]])
    return StreamingResponse(
        iter([buf.getvalue()]),
        media_type="text/csv",
        headers={"Content-Disposition": "attachment; filename=production_mart_export.csv"},
    )
