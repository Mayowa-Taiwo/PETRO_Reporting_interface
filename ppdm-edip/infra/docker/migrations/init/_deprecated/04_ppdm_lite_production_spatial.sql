-- PPDM Lite Production (MVP)
CREATE TABLE IF NOT EXISTS ppdm_lite.l_pden (
  pden_id         TEXT NOT NULL,
  pden_type       TEXT NOT NULL,
  pden_source     TEXT NOT NULL,
  pden_name       TEXT,
  other_name      TEXT,
  primary_product TEXT,
  pool_id         TEXT,
  uwi             TEXT,
  project_id      TEXT,
  data_source     TEXT,
  ppdm_guid       UUID,
  remark          TEXT,
  PRIMARY KEY (pden_id, pden_type, pden_source)
);

CREATE TABLE IF NOT EXISTS ppdm_lite.l_pden_vol_summary (
  pden_id                    TEXT NOT NULL,
  pden_type                  TEXT NOT NULL,
  pden_source                TEXT NOT NULL,
  volume_date                DATE,
  volume_method              TEXT,
  activity_type              TEXT,
  primary_product            TEXT,
  oil_cum_volume             NUMERIC(16,4),
  oil_volume_ouom            TEXT,
  gas_cum_volume             NUMERIC(16,4),
  gas_volume_ouom            TEXT,
  water_cum_volume           NUMERIC(16,4),
  water_volume_ouom          TEXT,
  sulphur_cum_volume         NUMERIC(16,4),
  sulphur_volume_ouom        TEXT,
  boe_cum_volume             NUMERIC(16,4),
  boe_volume_ouom            TEXT,
  co2_cum_volume             NUMERIC(16,4),
  co2_volume_ouom            TEXT,
  nitrogen_cum_volume        NUMERIC(16,4),
  nitrogen_volume_ouom      TEXT,
  period_on_production       NUMERIC(38,0),
  period_on_production_uom   TEXT,
  period_on_injection       NUMERIC(38,0),
  period_on_injection_uom   TEXT,
  project_id                 TEXT,
  data_source                TEXT,
  ppdm_guid                  UUID,
  remark                     TEXT,
  PRIMARY KEY (pden_id, pden_type, pden_source, volume_date, volume_method, activity_type),
  CONSTRAINT fk_pden_vol_to_pden
    FOREIGN KEY (pden_id, pden_type, pden_source)
    REFERENCES ppdm_lite.l_pden (pden_id, pden_type, pden_source)
);

-- PPDM Lite Spatial (MVP)
CREATE TABLE IF NOT EXISTS ppdm_lite.l_sp_component (
  spatial_description_id  TEXT NOT NULL,
  spatial_obs_no          INT NOT NULL,
  component_id            TEXT,
  component_type          TEXT,
  application_id          TEXT,
  area_id                 TEXT,
  area_type               TEXT,
  facility_id             TEXT,
  facility_type            TEXT,
  field_id                TEXT,
  interest_set_id         TEXT,
  jurisdiction            TEXT,
  land_right_id           TEXT,
  land_right_type         TEXT,
  land_sale_number        TEXT,
  land_sale_offering_id   TEXT,
  license_id              TEXT,
  license_table           TEXT,
  pden_id                 TEXT,
  pden_source             TEXT,
  pden_type               TEXT,
  pool_id                 TEXT,
  resent_id               TEXT,
  seis_set_id             TEXT,
  seis_set_type           TEXT,
  support_facility_id     TEXT,
  support_facility_type   TEXT,
  uwi                     TEXT,
  data_source             TEXT,
  ppdm_guid               UUID,
  remark                  TEXT,
  PRIMARY KEY (spatial_description_id, spatial_obs_no)
);

-- EDIP helper for GeoJSON publishing
CREATE TABLE IF NOT EXISTS ppdm_lite.edip_feature_geom (
  feature_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  source_table TEXT NOT NULL,
  source_pk    TEXT NOT NULL,
  geom_type    TEXT NOT NULL,
  geom         geometry,
  properties   JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_edip_feature_geom_gix ON ppdm_lite.edip_feature_geom USING GIST (geom);
