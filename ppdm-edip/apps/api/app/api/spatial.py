from fastapi import APIRouter, Depends, Query
from fastapi.responses import JSONResponse
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import text

from app.database import get_db

router = APIRouter()


@router.get("/layers")
async def list_layers(db: AsyncSession = Depends(get_db)):
    """Return configured spatial layers (MVP: wells as points, land as polygons from edip_feature_geom)."""
    r = await db.execute(text("""
        SELECT DISTINCT source_table, geom_type FROM ppdm_lite.edip_feature_geom ORDER BY source_table, geom_type
    """))
    rows = r.fetchall()
    layers = [{"layer_id": f"{row[0]}_{row[1]}", "source_table": row[0], "geom_type": row[1]} for row in rows]
    if not layers:
        layers = [
            {"layer_id": "l_well_point", "source_table": "l_well", "geom_type": "point"},
            {"layer_id": "l_pden_point", "source_table": "l_pden", "geom_type": "point"},
        ]
    return layers


@router.get("/layers/{layer_id}/features")
async def layer_features(
    layer_id: str,
    db: AsyncSession = Depends(get_db),
):
    """Return GeoJSON FeatureCollection for the layer. layer_id format: source_table_geom_type."""
    parts = layer_id.rsplit("_", 1)
    source_table = parts[0] if len(parts) == 2 else "edip_feature_geom"
    geom_type = parts[1] if len(parts) == 2 else "point"

    r = await db.execute(text("""
        SELECT feature_id, source_pk, geom_type, ST_AsGeoJSON(geom)::json AS geom_json, properties
        FROM ppdm_lite.edip_feature_geom WHERE source_table = :st AND geom_type = :gt
    """), {"st": source_table, "gt": geom_type})
    rows = r.fetchall()

    features = []
    for row in rows:
        fid, pk, gt, geom_json, props = row[0], row[1], row[2], row[3], row[4] or {}
        if not geom_json:
            continue
        features.append({
            "type": "Feature",
            "id": str(fid),
            "geometry": geom_json,
            "properties": {"source_pk": pk, "geom_type": gt, **props},
        })
    return JSONResponse(content={"type": "FeatureCollection", "features": features})


@router.get("/features/{feature_id}")
async def get_feature(feature_id: str, db: AsyncSession = Depends(get_db)):
    r = await db.execute(text("""
        SELECT feature_id, source_table, source_pk, geom_type, ST_AsGeoJSON(geom)::json, properties, created_at
        FROM ppdm_lite.edip_feature_geom WHERE feature_id = :fid
    """), {"fid": feature_id})
    row = r.fetchone()
    if not row:
        return {"detail": "Feature not found"}
    return {
        "feature_id": str(row[0]), "source_table": row[1], "source_pk": row[2],
        "geom_type": row[3], "geometry": row[4], "properties": row[5], "created_at": row[6].isoformat() if row[6] else None,
    }


@router.get("/search")
async def spatial_search(q: str = Query(..., min_length=1), db: AsyncSession = Depends(get_db)):
    """Search features by source_pk or properties."""
    r = await db.execute(text("""
        SELECT feature_id, source_table, source_pk, geom_type, properties
        FROM ppdm_lite.edip_feature_geom
        WHERE source_pk ILIKE :search OR properties::text ILIKE :search
        LIMIT 20
    """), {"search": f"%{q}%"})
    rows = r.fetchall()
    return [{"feature_id": str(row[0]), "source_table": row[1], "source_pk": row[2], "geom_type": row[3], "properties": row[4]} for row in rows]
