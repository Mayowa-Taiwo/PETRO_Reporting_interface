-- Platinum layer: Production Performance Mart (TRD Section 4.1, Mart Star Schema Pack §1)
-- Builds from Gold (ppdm_lite). Conformed dimensions + fact_production.

CREATE SCHEMA IF NOT EXISTS conformed;
CREATE SCHEMA IF NOT EXISTS marts;

-- Conformed dim_date (shared): calendar 2010-2030
CREATE TABLE IF NOT EXISTS conformed.dim_date (
  date_key       INT PRIMARY KEY,
  calendar_date  DATE NOT NULL UNIQUE,
  day_of_week    INT NOT NULL,
  day_of_month   INT NOT NULL,
  month          INT NOT NULL,
  quarter        INT NOT NULL,
  year           INT NOT NULL,
  month_name     TEXT NOT NULL,
  quarter_name   TEXT NOT NULL,
  is_weekend     BOOLEAN NOT NULL DEFAULT false,
  fiscal_year    INT,
  fiscal_quarter INT
);

INSERT INTO conformed.dim_date (date_key, calendar_date, day_of_week, day_of_month, month, quarter, year, month_name, quarter_name, is_weekend, fiscal_year, fiscal_quarter)
SELECT
  to_char(d, 'YYYYMMDD')::INT,
  d,
  EXTRACT(ISODOW FROM d)::INT,
  EXTRACT(DAY FROM d)::INT,
  EXTRACT(MONTH FROM d)::INT,
  EXTRACT(QUARTER FROM d)::INT,
  EXTRACT(YEAR FROM d)::INT,
  to_char(d, 'Month'),
  'Q' || EXTRACT(QUARTER FROM d)::TEXT,
  EXTRACT(ISODOW FROM d) IN (6, 7),
  EXTRACT(YEAR FROM d)::INT,
  EXTRACT(QUARTER FROM d)::INT
FROM generate_series('2010-01-01'::date, '2030-12-31'::date, '1 day'::interval) AS d
ON CONFLICT (date_key) DO NOTHING;

-- Conformed dim_product (from distinct primary_product in Gold)
CREATE OR REPLACE VIEW conformed.dim_product AS
SELECT
  row_number() OVER (ORDER BY COALESCE(primary_product, '')) AS product_key,
  COALESCE(primary_product, '') AS product_code,
  COALESCE(primary_product, 'Unknown') AS product_name,
  CASE WHEN COALESCE(primary_product,'') IN ('OIL','GAS','WATER') THEN 'Hydrocarbon' ELSE 'Other' END AS product_group,
  true AS is_primary,
  row_number() OVER (ORDER BY COALESCE(primary_product, '')) AS sort_order,
  NULL::TEXT AS data_source,
  NULL::DATE AS effective_from,
  NULL::DATE AS effective_to,
  true AS is_current
FROM (SELECT DISTINCT primary_product FROM ppdm_lite.l_pden
      UNION SELECT DISTINCT primary_product FROM ppdm_lite.l_pden_vol_summary) s(primary_product);

-- Conformed dim_operator (data_source as operator proxy from Gold)
CREATE OR REPLACE VIEW conformed.dim_operator AS
SELECT
  row_number() OVER (ORDER BY COALESCE(data_source, '')) AS operator_key,
  COALESCE(data_source, '') AS operator_id,
  COALESCE(data_source, 'Unknown') AS operator_name,
  'Company'::TEXT AS operator_type,
  NULL::TEXT AS country,
  COALESCE(data_source, '') AS data_source,
  NULL::DATE AS effective_from,
  NULL::DATE AS effective_to,
  true AS is_current,
  NULL::TEXT AS row_checksum
FROM (SELECT DISTINCT data_source FROM ppdm_lite.l_pden) s(data_source);

-- Conformed dim_field_pool (from L_PDEN pool_id/field_id; L_FIELD/L_POOL if present)
CREATE OR REPLACE VIEW conformed.dim_field_pool AS
SELECT
  row_number() OVER (ORDER BY COALESCE(pool_id, ''), COALESCE(field_id, '')) AS field_pool_key,
  COALESCE(field_id, '') AS field_id,
  COALESCE(pool_id, '') AS pool_id,
  COALESCE(pool_id, '') AS field_name,
  COALESCE(pool_id, '') AS pool_name,
  NULL::TEXT AS area_id,
  NULL::TEXT AS data_source,
  NULL::DATE AS effective_from,
  NULL::DATE AS effective_to,
  true AS is_current
FROM (SELECT DISTINCT pool_id, NULL::TEXT AS field_id FROM ppdm_lite.l_pden WHERE pool_id IS NOT NULL
      UNION
      SELECT ''::TEXT, NULL::TEXT) s(pool_id, field_id);

-- Mart-specific dim_pden (from L_PDEN)
CREATE OR REPLACE VIEW marts.dim_pden AS
SELECT
  row_number() OVER (ORDER BY pden_id, pden_type, pden_source)::BIGINT AS pden_key,
  pden_id,
  pden_type,
  pden_source,
  pden_name,
  uwi,
  primary_product,
  pool_id,
  COALESCE(p.field_id, NULL)::TEXT AS field_id,
  data_source,
  NULL::TEXT AS operator_id,
  NULL::DATE AS effective_from,
  NULL::DATE AS effective_to,
  true AS is_current
FROM ppdm_lite.l_pden p;

-- Fact Production: one row per PDEN per volume_date per volume_method per activity_type (from Gold)
CREATE OR REPLACE VIEW marts.fact_production AS
SELECT
  row_number() OVER (ORDER BY v.volume_date, p.pden_id, v.volume_method, v.activity_type)::BIGINT AS fact_production_key,
  NULL::UUID AS tenant_id,
  (SELECT pden_key FROM marts.dim_pden dp WHERE dp.pden_id = p.pden_id AND dp.pden_type = p.pden_type AND dp.pden_source = p.pden_source LIMIT 1) AS pden_key,
  to_char(v.volume_date, 'YYYYMMDD')::INT AS date_key,
  (SELECT product_key FROM conformed.dim_product pr WHERE pr.product_code = COALESCE(v.primary_product, p.primary_product, '') LIMIT 1) AS product_key,
  (SELECT operator_key FROM conformed.dim_operator o WHERE o.operator_id = COALESCE(p.data_source, '') LIMIT 1) AS operator_key,
  (SELECT field_pool_key FROM conformed.dim_field_pool fp WHERE fp.pool_id = COALESCE(p.pool_id, '') LIMIT 1) AS field_pool_key,
  v.oil_cum_volume     AS oil_cum_volume,
  v.gas_cum_volume     AS gas_cum_volume,
  v.water_cum_volume   AS water_cum_volume,
  v.boe_cum_volume     AS boe_cum_volume,
  NULL::TEXT           AS oil_volume_ouom,
  NULL::TEXT           AS gas_volume_ouom,
  v.volume_method     AS volume_method,
  v.activity_type      AS activity_type,
  COALESCE(p.data_source, v.data_source) AS data_source,
  NULL::INT            AS uom_key,
  NULL::UUID           AS load_run_id,
  now()                AS refreshed_at,
  p.pden_id            AS pden_id_natural,
  p.pden_type          AS pden_type,
  p.pden_source        AS pden_source
FROM ppdm_lite.l_pden_vol_summary v
JOIN ppdm_lite.l_pden p ON p.pden_id = v.pden_id AND p.pden_type = v.pden_type AND p.pden_source = v.pden_source;
