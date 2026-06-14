-- Ensure L_PDEN and L_PDEN_VOL_SUMMARY have columns required for Production mart and API
-- (Full DDL 03 creates these tables with REMARK only; this adds columns when missing.)
SET search_path TO ppdm_lite;

-- L_PDEN: add columns if not present (e.g. after full DDL)
ALTER TABLE ppdm_lite.l_pden ADD COLUMN IF NOT EXISTS pden_id VARCHAR(40);
ALTER TABLE ppdm_lite.l_pden ADD COLUMN IF NOT EXISTS pden_type VARCHAR(30);
ALTER TABLE ppdm_lite.l_pden ADD COLUMN IF NOT EXISTS pden_source VARCHAR(30);
ALTER TABLE ppdm_lite.l_pden ADD COLUMN IF NOT EXISTS pden_name VARCHAR(60);
ALTER TABLE ppdm_lite.l_pden ADD COLUMN IF NOT EXISTS other_name VARCHAR(60);
ALTER TABLE ppdm_lite.l_pden ADD COLUMN IF NOT EXISTS primary_product VARCHAR(20);
ALTER TABLE ppdm_lite.l_pden ADD COLUMN IF NOT EXISTS pool_id VARCHAR(20);
ALTER TABLE ppdm_lite.l_pden ADD COLUMN IF NOT EXISTS uwi VARCHAR(20);
ALTER TABLE ppdm_lite.l_pden ADD COLUMN IF NOT EXISTS project_id VARCHAR(20);
ALTER TABLE ppdm_lite.l_pden ADD COLUMN IF NOT EXISTS data_source VARCHAR(30);
ALTER TABLE ppdm_lite.l_pden ADD COLUMN IF NOT EXISTS field_id VARCHAR(20);

-- L_PDEN_VOL_SUMMARY: add columns if not present
ALTER TABLE ppdm_lite.l_pden_vol_summary ADD COLUMN IF NOT EXISTS pden_id VARCHAR(40);
ALTER TABLE ppdm_lite.l_pden_vol_summary ADD COLUMN IF NOT EXISTS pden_type VARCHAR(30);
ALTER TABLE ppdm_lite.l_pden_vol_summary ADD COLUMN IF NOT EXISTS pden_source VARCHAR(30);
ALTER TABLE ppdm_lite.l_pden_vol_summary ADD COLUMN IF NOT EXISTS volume_date DATE;
ALTER TABLE ppdm_lite.l_pden_vol_summary ADD COLUMN IF NOT EXISTS volume_method VARCHAR(20);
ALTER TABLE ppdm_lite.l_pden_vol_summary ADD COLUMN IF NOT EXISTS activity_type VARCHAR(20);
ALTER TABLE ppdm_lite.l_pden_vol_summary ADD COLUMN IF NOT EXISTS primary_product VARCHAR(20);
ALTER TABLE ppdm_lite.l_pden_vol_summary ADD COLUMN IF NOT EXISTS oil_cum_volume NUMERIC(16,4);
ALTER TABLE ppdm_lite.l_pden_vol_summary ADD COLUMN IF NOT EXISTS gas_cum_volume NUMERIC(16,4);
ALTER TABLE ppdm_lite.l_pden_vol_summary ADD COLUMN IF NOT EXISTS water_cum_volume NUMERIC(16,4);
ALTER TABLE ppdm_lite.l_pden_vol_summary ADD COLUMN IF NOT EXISTS boe_cum_volume NUMERIC(16,4);
ALTER TABLE ppdm_lite.l_pden_vol_summary ADD COLUMN IF NOT EXISTS data_source VARCHAR(30);
