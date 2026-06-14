-- Seed L_PPDM_TABLE and L_PPDM_COLUMN from current ppdm_lite schema (run after DDL).
-- Alternative: run from backend with raw SQL using information_schema.
INSERT INTO ppdm_lite.l_ppdm_table (table_name, table_comment) VALUES
  ('l_ppdm_table', 'PPDM Lite meta'),
  ('l_ppdm_column', 'PPDM Lite meta'),
  ('l_ppdm_origin', 'PPDM Lite meta'),
  ('l_ppdm_exception', 'PPDM Lite meta'),
  ('l_pden', 'Producing entity'),
  ('l_pden_vol_summary', 'Volume summary'),
  ('l_sp_component', 'Spatial component'),
  ('edip_feature_geom', 'EDIP GeoJSON helper')
ON CONFLICT (table_name) DO NOTHING;

-- Columns for l_pden
INSERT INTO ppdm_lite.l_ppdm_column (table_name, column_name, column_sequence, column_comment) VALUES
  ('l_pden', 'pden_id', 1, 'PK'),
  ('l_pden', 'pden_type', 2, 'PK'),
  ('l_pden', 'pden_source', 3, 'PK'),
  ('l_pden', 'pden_name', 4, NULL),
  ('l_pden', 'data_source', 5, 'Governance'),
  ('l_pden', 'ppdm_guid', 6, 'Governance'),
  ('l_pden', 'remark', 7, NULL)
ON CONFLICT (table_name, column_name) DO NOTHING;

-- Columns for l_pden_vol_summary
INSERT INTO ppdm_lite.l_ppdm_column (table_name, column_name, column_sequence, column_comment) VALUES
  ('l_pden_vol_summary', 'pden_id', 1, 'FK'),
  ('l_pden_vol_summary', 'pden_type', 2, 'FK'),
  ('l_pden_vol_summary', 'pden_source', 3, 'FK'),
  ('l_pden_vol_summary', 'volume_date', 4, 'Grain'),
  ('l_pden_vol_summary', 'volume_method', 5, NULL),
  ('l_pden_vol_summary', 'activity_type', 6, NULL),
  ('l_pden_vol_summary', 'data_source', 7, 'Governance'),
  ('l_pden_vol_summary', 'ppdm_guid', 8, 'Governance'),
  ('l_pden_vol_summary', 'oil_cum_volume', 9, NULL),
  ('l_pden_vol_summary', 'gas_cum_volume', 10, NULL),
  ('l_pden_vol_summary', 'remark', 11, NULL)
ON CONFLICT (table_name, column_name) DO NOTHING;

-- Columns for l_sp_component
INSERT INTO ppdm_lite.l_ppdm_column (table_name, column_name, column_sequence, column_comment) VALUES
  ('l_sp_component', 'spatial_description_id', 1, 'PK'),
  ('l_sp_component', 'spatial_obs_no', 2, 'PK'),
  ('l_sp_component', 'pden_id', 3, NULL),
  ('l_sp_component', 'uwi', 4, NULL),
  ('l_sp_component', 'data_source', 5, 'Governance'),
  ('l_sp_component', 'ppdm_guid', 6, 'Governance'),
  ('l_sp_component', 'remark', 7, NULL)
ON CONFLICT (table_name, column_name) DO NOTHING;
