-- Meta: operational platform
CREATE TABLE IF NOT EXISTS meta.ingest_source (
  source_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  source_name     TEXT NOT NULL,
  source_type     TEXT NOT NULL,
  connection_ref  TEXT,
  owner          TEXT,
  is_enabled     BOOLEAN NOT NULL DEFAULT TRUE,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS meta.ingest_run (
  run_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  source_id      UUID NOT NULL REFERENCES meta.ingest_source(source_id),
  started_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  finished_at    TIMESTAMPTZ,
  status         TEXT NOT NULL,
  mode           TEXT NOT NULL,
  notes          TEXT
);

CREATE TABLE IF NOT EXISTS meta.mapping_registry (
  mapping_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  source_id      UUID NOT NULL REFERENCES meta.ingest_source(source_id),
  source_table   TEXT NOT NULL,
  source_column  TEXT NOT NULL,
  target_table   TEXT NOT NULL,
  target_column  TEXT NOT NULL,
  transform_rule TEXT,
  is_essential   BOOLEAN NOT NULL DEFAULT FALSE,
  is_enabled     BOOLEAN NOT NULL DEFAULT TRUE,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS meta.essential_policy (
  table_name     TEXT NOT NULL,
  column_name    TEXT NOT NULL,
  is_essential   BOOLEAN NOT NULL,
  reason         TEXT,
  PRIMARY KEY (table_name, column_name)
);

CREATE TABLE IF NOT EXISTS meta.dq_table_score (
  run_id                  UUID NOT NULL REFERENCES meta.ingest_run(run_id),
  target_table            TEXT NOT NULL,
  essential_total         INT NOT NULL,
  essential_valid         INT NOT NULL,
  optional_total          INT NOT NULL,
  optional_valid          INT NOT NULL,
  essential_coverage_pct  NUMERIC(6,2) NOT NULL,
  optional_coverage_pct   NUMERIC(6,2) NOT NULL,
  dq_score                NUMERIC(6,2) NOT NULL,
  certified_ind           BOOLEAN NOT NULL,
  computed_at             TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (run_id, target_table)
);
