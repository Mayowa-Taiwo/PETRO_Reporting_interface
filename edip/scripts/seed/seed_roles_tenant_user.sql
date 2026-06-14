-- Seed roles, demo tenant, demo user (run after 001_schemas_meta_ref_security)
INSERT INTO security.roles (role_id, role_name) VALUES
  ('tenant_admin', 'Tenant Administrator'),
  ('executive_viewer', 'Executive Viewer'),
  ('analyst', 'Analyst'),
  ('finance_analyst', 'Finance Analyst'),
  ('geo_analyst', 'Geo Analyst'),
  ('data_steward', 'Data Steward'),
  ('api_client', 'API Client')
ON CONFLICT (role_id) DO NOTHING;

INSERT INTO security.tenants (tenant_id, tenant_name) VALUES
  ('a0000000-0000-0000-0000-000000000001', 'Demo Tenant')
ON CONFLICT (tenant_id) DO NOTHING;

-- Password: demo123 (bcrypt, verified with bcrypt.checkpw)
INSERT INTO security.users (user_id, tenant_id, email, hashed_password, full_name) VALUES
  ('b0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000001', 'admin@demo.edip.local', '$2b$12$6DMD72sr2C58gCafe2Iou.lKOpbt7SMNQ/CK.qKHA7fsN3gcPcena', 'Demo Admin')
ON CONFLICT (user_id) DO UPDATE SET
  email = EXCLUDED.email,
  hashed_password = EXCLUDED.hashed_password,
  full_name = EXCLUDED.full_name;

INSERT INTO security.user_roles (user_id, role_id) VALUES
  ('b0000000-0000-0000-0000-000000000001', 'tenant_admin'),
  ('b0000000-0000-0000-0000-000000000001', 'analyst')
ON CONFLICT (user_id, role_id) DO NOTHING;

-- Production mart contract: 60 essential + 40 enhanced (l_pden, l_pden_vol_summary)
INSERT INTO meta.mart_registry (mart_id, mart_name, schema_name, description) VALUES
  ('production', 'Production Performance', 'marts_production', 'Production volumes by PDEN')
ON CONFLICT (mart_id) DO NOTHING;

INSERT INTO meta.mart_contract_item (mart_id, source_schema, source_table, source_column, points, is_essential) VALUES
  ('production', 'ppdm_lite', 'l_pden', 'pden_id', 3, true),
  ('production', 'ppdm_lite', 'l_pden', 'pden_type', 3, true),
  ('production', 'ppdm_lite', 'l_pden', 'pden_source', 2, true),
  ('production', 'ppdm_lite', 'l_pden', 'pden_name', 2, true),
  ('production', 'ppdm_lite', 'l_pden', 'data_source', 2, true),
  ('production', 'ppdm_lite', 'l_pden', 'uwi', 2, true),
  ('production', 'ppdm_lite', 'l_pden', 'primary_product', 2, true),
  ('production', 'ppdm_lite', 'l_pden', 'pool_id', 2, true),
  ('production', 'ppdm_lite', 'l_pden_vol_summary', 'pden_id', 3, true),
  ('production', 'ppdm_lite', 'l_pden_vol_summary', 'pden_type', 2, true),
  ('production', 'ppdm_lite', 'l_pden_vol_summary', 'pden_source', 2, true),
  ('production', 'ppdm_lite', 'l_pden_vol_summary', 'volume_date', 3, true),
  ('production', 'ppdm_lite', 'l_pden_vol_summary', 'volume_method', 2, true),
  ('production', 'ppdm_lite', 'l_pden_vol_summary', 'activity_type', 2, true),
  ('production', 'ppdm_lite', 'l_pden_vol_summary', 'oil_cum_volume', 3, true),
  ('production', 'ppdm_lite', 'l_pden_vol_summary', 'gas_cum_volume', 3, true),
  ('production', 'ppdm_lite', 'l_pden', 'remark', 2, false),
  ('production', 'ppdm_lite', 'l_pden', 'other_name', 2, false),
  ('production', 'ppdm_lite', 'l_pden_vol_summary', 'water_cum_volume', 2, false),
  ('production', 'ppdm_lite', 'l_pden_vol_summary', 'boe_cum_volume', 2, false),
  ('production', 'ppdm_lite', 'l_pden_vol_summary', 'oil_volume_ouom', 2, false),
  ('production', 'ppdm_lite', 'l_pden_vol_summary', 'gas_volume_ouom', 2, false)
ON CONFLICT (mart_id, source_schema, source_table, source_column) DO NOTHING;
