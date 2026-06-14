-- After full PPDM Lite 1.1 DDL: ensure L_PPDM_TABLE and L_PPDM_COLUMN have columns
-- needed for contract catalog / data dictionary (full DDL has only REMARK active).
-- Enables seeding from information_schema in 06.

-- L_PPDM_TABLE: add table_name, table_comment if missing (for catalog)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'ppdm_lite' AND table_name = 'l_ppdm_table' AND column_name = 'table_name') THEN
    ALTER TABLE ppdm_lite.l_ppdm_table ADD COLUMN table_name TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'ppdm_lite' AND table_name = 'l_ppdm_table' AND column_name = 'table_comment') THEN
    ALTER TABLE ppdm_lite.l_ppdm_table ADD COLUMN table_comment TEXT;
  END IF;
END $$;

-- L_PPDM_COLUMN: add table_name, column_name, column_sequence, column_comment if missing
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'ppdm_lite' AND table_name = 'l_ppdm_column' AND column_name = 'table_name') THEN
    ALTER TABLE ppdm_lite.l_ppdm_column ADD COLUMN table_name TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'ppdm_lite' AND table_name = 'l_ppdm_column' AND column_name = 'column_name') THEN
    ALTER TABLE ppdm_lite.l_ppdm_column ADD COLUMN column_name TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'ppdm_lite' AND table_name = 'l_ppdm_column' AND column_name = 'column_sequence') THEN
    ALTER TABLE ppdm_lite.l_ppdm_column ADD COLUMN column_sequence INT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'ppdm_lite' AND table_name = 'l_ppdm_column' AND column_name = 'column_comment') THEN
    ALTER TABLE ppdm_lite.l_ppdm_column ADD COLUMN column_comment TEXT;
  END IF;
END $$;

-- Primary keys for catalog use (idempotent: drop if exists then add)
ALTER TABLE ppdm_lite.l_ppdm_table DROP CONSTRAINT IF EXISTS l_pt_pk;
ALTER TABLE ppdm_lite.l_ppdm_table ADD CONSTRAINT l_pt_pk PRIMARY KEY (table_name);

ALTER TABLE ppdm_lite.l_ppdm_column DROP CONSTRAINT IF EXISTS l_pc_pk;
ALTER TABLE ppdm_lite.l_ppdm_column ADD CONSTRAINT l_pc_pk PRIMARY KEY (table_name, column_name);

-- L_PPDM_ORIGIN: columns for lineage (EDIP pipeline)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'ppdm_lite' AND table_name = 'l_ppdm_origin' AND column_name = 'source_table_name') THEN
    ALTER TABLE ppdm_lite.l_ppdm_origin ADD COLUMN source_table_name TEXT, ADD COLUMN source_column_name TEXT, ADD COLUMN target_table_name TEXT, ADD COLUMN target_column_name TEXT, ADD COLUMN run_id UUID REFERENCES meta.ingest_run(run_id), ADD COLUMN created_at TIMESTAMPTZ DEFAULT now();
  END IF;
END $$;

-- L_PPDM_EXCEPTION: columns for exception logging (EDIP pipeline)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'ppdm_lite' AND table_name = 'l_ppdm_exception' AND column_name = 'exception_id') THEN
    ALTER TABLE ppdm_lite.l_ppdm_exception ADD COLUMN exception_id BIGSERIAL;
    ALTER TABLE ppdm_lite.l_ppdm_exception ADD CONSTRAINT l_pe_pk PRIMARY KEY (exception_id);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'ppdm_lite' AND table_name = 'l_ppdm_exception' AND column_name = 'exception_table_name') THEN
    ALTER TABLE ppdm_lite.l_ppdm_exception ADD COLUMN exception_table_name TEXT, ADD COLUMN exception_column_name TEXT, ADD COLUMN exception_type TEXT, ADD COLUMN error_message TEXT, ADD COLUMN exception_date TIMESTAMPTZ DEFAULT now(), ADD COLUMN run_id UUID REFERENCES meta.ingest_run(run_id);
  END IF;
EXCEPTION WHEN duplicate_column OR duplicate_object THEN NULL;
END $$;
