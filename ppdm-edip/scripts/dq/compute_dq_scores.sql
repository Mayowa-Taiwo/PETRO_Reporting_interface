-- Compute DQ score for one target_table and one run_id.
-- Parameters: :run_id, :target_table
-- Output: run_id, target_table, essential_total, essential_valid, optional_total, optional_valid,
--         essential_coverage_pct, optional_coverage_pct, dq_score_final, certified_ind
WITH
contract AS (
  SELECT c.table_name, c.column_name
  FROM ppdm_lite.l_ppdm_column c
  WHERE c.table_name = :target_table
),
policy AS (
  SELECT table_name, column_name,
         COALESCE(ep.is_essential, 
           (column_name IN ('pden_id','pden_type','pden_source','data_source','ppdm_guid','volume_date','volume_method','activity_type','spatial_description_id','spatial_obs_no'))
           OR column_name LIKE '%_id' OR column_name = 'data_source' OR column_name = 'ppdm_guid'
         ) AS is_essential
  FROM contract co
  LEFT JOIN meta.essential_policy ep ON ep.table_name = co.table_name AND ep.column_name = co.column_name
),
mapped AS (
  SELECT m.target_table, m.target_column, COALESCE(p.is_essential, true) AS is_essential
  FROM meta.mapping_registry m
  JOIN policy p ON p.table_name = m.target_table AND p.column_name = m.target_column
  WHERE m.is_enabled AND m.target_table = :target_table
),
with_valid AS (
  SELECT
    m.target_column,
    m.is_essential,
    EXISTS (
      SELECT 1 FROM ppdm_lite.l_ppdm_origin o
      WHERE o.run_id = :run_id AND o.target_table_name = :target_table AND o.target_column_name = m.target_column
    ) AS valid
  FROM mapped m
),
coverage AS (
  SELECT
    :run_id::uuid AS run_id,
    :target_table::text AS target_table,
    SUM(CASE WHEN is_essential THEN 1 ELSE 0 END)::int AS essential_total,
    SUM(CASE WHEN is_essential AND valid THEN 1 ELSE 0 END)::int AS essential_valid,
    SUM(CASE WHEN NOT is_essential THEN 1 ELSE 0 END)::int AS optional_total,
    SUM(CASE WHEN NOT is_essential AND valid THEN 1 ELSE 0 END)::int AS optional_valid
  FROM with_valid
)
SELECT
  run_id, target_table,
  essential_total, essential_valid, optional_total, optional_valid,
  CASE WHEN essential_total = 0 THEN 0 ELSE ROUND((essential_valid::numeric / essential_total) * 100, 2) END AS essential_coverage_pct,
  CASE WHEN optional_total = 0 THEN 0 ELSE ROUND((optional_valid::numeric / optional_total) * 100, 2) END AS optional_coverage_pct,
  CASE
    WHEN essential_total > 0 AND (essential_valid::numeric / essential_total) < 0.90 THEN 59
    ELSE ROUND(
      COALESCE(60 * (essential_valid::numeric / NULLIF(essential_total,0)), 0) +
      COALESCE(40 * (optional_valid::numeric / NULLIF(optional_total,0)), 0), 2)
  END AS dq_score_final,
  (essential_total = 0 OR (essential_valid::numeric / essential_total) >= 0.90)
    AND (COALESCE(60 * (essential_valid::numeric / NULLIF(essential_total,0)), 0) + COALESCE(40 * (optional_valid::numeric / NULLIF(optional_total,0)), 0)) >= 80 AS certified_ind
FROM coverage;
