-- Contract catalog: populate L_PPDM_TABLE and L_PPDM_COLUMN from information_schema
-- (full PPDM Lite 1.1 schema in ppdm_lite). Ensures 100% contract coverage for DQ scoring.

INSERT INTO ppdm_lite.l_ppdm_table (table_name, table_comment)
SELECT t.table_name, obj_description((quote_ident(t.table_schema) || '.' || quote_ident(t.table_name))::regclass, 'pg_class')
FROM information_schema.tables t
WHERE t.table_schema = 'ppdm_lite'
  AND t.table_type = 'BASE TABLE'
ON CONFLICT (table_name) DO UPDATE SET table_comment = EXCLUDED.table_comment;

INSERT INTO ppdm_lite.l_ppdm_column (table_name, column_name, column_sequence, column_comment)
SELECT c.table_name, c.column_name, c.ordinal_position::int, NULL
FROM information_schema.columns c
WHERE c.table_schema = 'ppdm_lite'
ON CONFLICT (table_name, column_name) DO UPDATE SET column_sequence = EXCLUDED.column_sequence;
