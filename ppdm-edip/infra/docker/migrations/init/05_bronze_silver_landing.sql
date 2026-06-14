-- Bronze: raw landing (append-only)
CREATE TABLE IF NOT EXISTS bronze.ingest_file (
  file_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  run_id        UUID,
  file_name     TEXT NOT NULL,
  file_path     TEXT,
  row_count     INT,
  loaded_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Silver: conformed staging (MVP: one table per source entity)
CREATE TABLE IF NOT EXISTS silver.pden_staging (
  pden_id         TEXT,
  pden_type       TEXT,
  pden_source     TEXT,
  pden_name       TEXT,
  other_name      TEXT,
  primary_product TEXT,
  pool_id         TEXT,
  uwi             TEXT,
  project_id      TEXT,
  data_source     TEXT,
  run_id          UUID,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS silver.pden_vol_staging (
  pden_id           TEXT,
  pden_type         TEXT,
  pden_source       TEXT,
  volume_date       DATE,
  volume_method     TEXT,
  activity_type     TEXT,
  primary_product   TEXT,
  oil_cum_volume     NUMERIC(16,4),
  gas_cum_volume     NUMERIC(16,4),
  water_cum_volume   NUMERIC(16,4),
  boe_cum_volume     NUMERIC(16,4),
  data_source       TEXT,
  run_id            UUID,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);
