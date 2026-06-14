from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import text

from app.database import get_db

router = APIRouter()


@router.get("/pdens")
async def list_pdens(
    q: str | None = Query(None),
    db: AsyncSession = Depends(get_db),
):
    if q:
        r = await db.execute(text("""
            SELECT pden_id, pden_type, pden_source, pden_name, primary_product, pool_id, uwi, data_source
            FROM ppdm_lite.l_pden
            WHERE pden_id ILIKE :search OR pden_name ILIKE :search OR uwi ILIKE :search
            ORDER BY pden_id LIMIT 100
        """), {"search": f"%{q}%"})
    else:
        r = await db.execute(text("""
            SELECT pden_id, pden_type, pden_source, pden_name, primary_product, pool_id, uwi, data_source
            FROM ppdm_lite.l_pden ORDER BY pden_id LIMIT 100
        """))
    rows = r.fetchall()
    return [
        {
            "pden_id": row[0], "pden_type": row[1], "pden_source": row[2], "pden_name": row[3],
            "primary_product": row[4], "pool_id": row[5], "uwi": row[6], "data_source": row[7],
        }
        for row in rows
    ]


@router.get("/pdens/by-id/{pden_id}")
async def get_pden_by_id(pden_id: str, db: AsyncSession = Depends(get_db)):
    """Resolve PDEN by id only (first match). Use returned pden_type/pden_source for volumes."""
    r = await db.execute(text("""
        SELECT pden_id, pden_type, pden_source, pden_name, other_name, primary_product, pool_id, uwi, project_id, data_source, remark
        FROM ppdm_lite.l_pden WHERE pden_id = :pid ORDER BY pden_type, pden_source LIMIT 1
    """), {"pid": pden_id})
    row = r.fetchone()
    if not row:
        return {"detail": "PDEN not found"}
    return {
        "pden_id": row[0], "pden_type": row[1], "pden_source": row[2], "pden_name": row[3],
        "other_name": row[4], "primary_product": row[5], "pool_id": row[6], "uwi": row[7],
        "project_id": row[8], "data_source": row[9], "remark": row[10],
    }


@router.get("/pdens/{pden_id}")
async def get_pden(
    pden_id: str,
    pden_type: str = Query("WELL"),
    pden_source: str = Query("DEMO"),
    db: AsyncSession = Depends(get_db),
):
    r = await db.execute(text("""
        SELECT pden_id, pden_type, pden_source, pden_name, other_name, primary_product, pool_id, uwi, project_id, data_source, remark
        FROM ppdm_lite.l_pden WHERE pden_id = :pid AND pden_type = :ptype AND pden_source = :psrc
    """), {"pid": pden_id, "ptype": pden_type, "psrc": pden_source})
    row = r.fetchone()
    if not row:
        return {"detail": "PDEN not found"}
    return {
        "pden_id": row[0], "pden_type": row[1], "pden_source": row[2], "pden_name": row[3],
        "other_name": row[4], "primary_product": row[5], "pool_id": row[6], "uwi": row[7],
        "project_id": row[8], "data_source": row[9], "remark": row[10],
    }


@router.get("/pdens/{pden_id}/volumes")
async def get_pden_volumes(
    pden_id: str,
    pden_type: str = Query("WELL"),
    pden_source: str = Query("DEMO"),
    from_date: str | None = Query(None, alias="from"),
    to_date: str | None = Query(None, alias="to"),
    db: AsyncSession = Depends(get_db),
):
    sql = """
        SELECT volume_date, volume_method, activity_type, primary_product,
               oil_cum_volume, gas_cum_volume, water_cum_volume, boe_cum_volume
        FROM ppdm_lite.l_pden_vol_summary
        WHERE pden_id = :pid AND pden_type = :ptype AND pden_source = :psrc
    """
    params = {"pid": pden_id, "ptype": pden_type, "psrc": pden_source}
    if from_date:
        sql += " AND volume_date >= :from_date"
        params["from_date"] = from_date
    if to_date:
        sql += " AND volume_date <= :to_date"
        params["to_date"] = to_date
    sql += " ORDER BY volume_date"
    r = await db.execute(text(sql), params)
    rows = r.fetchall()
    return [
        {
            "volume_date": row[0].isoformat() if row[0] else None,
            "volume_method": row[1], "activity_type": row[2], "primary_product": row[3],
            "oil_cum_volume": float(row[4]) if row[4] is not None else None,
            "gas_cum_volume": float(row[5]) if row[5] is not None else None,
            "water_cum_volume": float(row[6]) if row[6] is not None else None,
            "boe_cum_volume": float(row[7]) if row[7] is not None else None,
        }
        for row in rows
    ]


@router.get("/rollups")
async def rollups(
    group_by: str = Query("pool", pattern="^(pool|field|operator)$"),
    db: AsyncSession = Depends(get_db),
):
    if group_by == "pool":
        r = await db.execute(text("""
            SELECT p.pool_id, COUNT(DISTINCT p.pden_id) AS pden_count, COALESCE(SUM(v.oil_cum_volume), 0) AS oil_total, COALESCE(SUM(v.gas_cum_volume), 0) AS gas_total
            FROM ppdm_lite.l_pden p
            LEFT JOIN ppdm_lite.l_pden_vol_summary v ON p.pden_id = v.pden_id AND p.pden_type = v.pden_type AND p.pden_source = v.pden_source
            WHERE p.pool_id IS NOT NULL
            GROUP BY p.pool_id ORDER BY oil_total + gas_total / 6 DESC NULLS LAST
        """))
    elif group_by == "field":
        r = await db.execute(text("""
            SELECT p.pool_id AS field_id, COUNT(DISTINCT p.pden_id) AS pden_count, COALESCE(SUM(v.oil_cum_volume), 0) AS oil_total, COALESCE(SUM(v.gas_cum_volume), 0) AS gas_total
            FROM ppdm_lite.l_pden p
            LEFT JOIN ppdm_lite.l_pden_vol_summary v ON p.pden_id = v.pden_id AND p.pden_type = v.pden_type AND p.pden_source = v.pden_source
            GROUP BY p.pool_id ORDER BY oil_total + gas_total / 6 DESC NULLS LAST
        """))
    else:
        r = await db.execute(text("""
            SELECT p.data_source AS operator, COUNT(DISTINCT p.pden_id) AS pden_count, COALESCE(SUM(v.oil_cum_volume), 0) AS oil_total, COALESCE(SUM(v.gas_cum_volume), 0) AS gas_total
            FROM ppdm_lite.l_pden p
            LEFT JOIN ppdm_lite.l_pden_vol_summary v ON p.pden_id = v.pden_id AND p.pden_type = v.pden_type AND p.pden_source = v.pden_source
            GROUP BY p.data_source ORDER BY oil_total + gas_total / 6 DESC NULLS LAST
        """))
    rows = r.fetchall()
    return [
        {"group_key": row[0], "pden_count": row[1], "oil_total": float(row[2]), "gas_total": float(row[3])}
        for row in rows
    ]


@router.get("/kpis")
async def kpis(db: AsyncSession = Depends(get_db)):
    r = await db.execute(text("""
        SELECT COUNT(DISTINCT pden_id) FROM ppdm_lite.l_pden
    """))
    pden_count = r.scalar() or 0
    r = await db.execute(text("""
        SELECT COALESCE(SUM(oil_cum_volume), 0), COALESCE(SUM(gas_cum_volume), 0) FROM ppdm_lite.l_pden_vol_summary
    """))
    row = r.fetchone()
    return {
        "pden_count": pden_count,
        "oil_cum_total": float(row[0]) if row else 0,
        "gas_cum_total": float(row[1]) if row else 0,
    }
