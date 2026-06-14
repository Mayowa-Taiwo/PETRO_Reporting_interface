-- PPDM Lite meta-model
CREATE TABLE IF NOT EXISTS ppdm_lite.l_ppdm_table (
  table_name       TEXT PRIMARY KEY,
  data_source      TEXT,
  ppdm_guid        UUID,
  primary_key_name TEXT,
  table_comment    TEXT,
  remark          TEXT
);

CREATE TABLE IF NOT EXISTS ppdm_lite.l_ppdm_column (
  table_name          TEXT NOT NULL REFERENCES ppdm_lite.l_ppdm_table(table_name),
  column_name         TEXT NOT NULL,
  column_sequence     INT,
  data_source         TEXT,
  data_type           TEXT,
  primary_key_sequence INT,
  column_comment      TEXT,
  ppdm_guid           UUID,
  remark              TEXT,
  PRIMARY KEY (table_name, column_name)
);

CREATE TABLE IF NOT EXISTS ppdm_lite.l_ppdm_origin (
  origin_id           BIGSERIAL PRIMARY KEY,
  data_source         TEXT,
  source_table_name   TEXT NOT NULL,
  source_column_name  TEXT,
  source_ppdm_guid    UUID,
  target_table_name   TEXT NOT NULL,
  target_column_name  TEXT,
  target_ppdm_guid    UUID,
  business_rule       TEXT,
  remark              TEXT,
  run_id              UUID REFERENCES meta.ingest_run(run_id),
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS ppdm_lite.l_ppdm_exception (
  exception_id          BIGSERIAL PRIMARY KEY,
  data_source          TEXT,
  exception_type       TEXT,
  exception_date       TIMESTAMPTZ NOT NULL DEFAULT now(),
  exception_table_name TEXT,
  exception_column_name TEXT,
  error_no             TEXT,
  error_message        TEXT,
  plsql_name           TEXT,
  ppdm_guid            UUID,
  remark               TEXT,
  run_id               UUID REFERENCES meta.ingest_run(run_id)
);
