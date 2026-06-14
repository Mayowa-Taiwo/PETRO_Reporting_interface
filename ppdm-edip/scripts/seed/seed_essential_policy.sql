-- Essential vs optional policy for DQ scoring (60/40 tranche)
INSERT INTO meta.essential_policy (table_name, column_name, is_essential, reason) VALUES
  ('l_pden', 'pden_id', true, 'Identity'),
  ('l_pden', 'pden_type', true, 'Identity'),
  ('l_pden', 'pden_source', true, 'Identity'),
  ('l_pden', 'data_source', true, 'Governance'),
  ('l_pden', 'ppdm_guid', true, 'Governance'),
  ('l_pden_vol_summary', 'pden_id', true, 'Join key'),
  ('l_pden_vol_summary', 'pden_type', true, 'Join key'),
  ('l_pden_vol_summary', 'pden_source', true, 'Join key'),
  ('l_pden_vol_summary', 'volume_date', true, 'Measure grain'),
  ('l_pden_vol_summary', 'volume_method', true, 'Measure meaning'),
  ('l_pden_vol_summary', 'activity_type', true, 'Measure meaning'),
  ('l_pden_vol_summary', 'data_source', true, 'Governance'),
  ('l_pden_vol_summary', 'ppdm_guid', true, 'Governance'),
  ('l_sp_component', 'spatial_description_id', true, 'Identity'),
  ('l_sp_component', 'spatial_obs_no', true, 'Identity'),
  ('l_sp_component', 'data_source', true, 'Governance'),
  ('l_sp_component', 'ppdm_guid', true, 'Governance')
ON CONFLICT (table_name, column_name) DO NOTHING;
