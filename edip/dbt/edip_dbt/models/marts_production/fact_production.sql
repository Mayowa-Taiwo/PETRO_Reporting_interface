{{
  config(
    materialized='table',
    schema='marts_production',
  )
}}
with vol as (
  select * from {{ ref('stg_ppdm_lite__l_pden_vol_summary') }}
),
pden as (
  select * from {{ ref('dim_pden') }}
),
dim_d as (
  select * from {{ ref('dim_date') }}
),
dim_pr as (
  select * from {{ ref('dim_product') }}
),
dim_op as (
  select * from {{ ref('dim_operator') }}
),
joined as (
  select
    p.tenant_id,
    p.pden_key,
    to_char(v.volume_date::date, 'YYYYMMDD')::int as date_key,
    (select product_key from dim_pr where product_code = coalesce(v.primary_product, p.primary_product, '') limit 1) as product_key,
    (select operator_key from dim_op where operator_id = coalesce(p.data_source, '') limit 1) as operator_key,
    null::int as field_pool_key,
    v.oil_cum_volume,
    v.gas_cum_volume,
    v.water_cum_volume,
    v.boe_cum_volume,
    v.oil_volume_ouom,
    v.gas_volume_ouom,
    v.volume_method,
    v.activity_type,
    coalesce(p.data_source, v.data_source) as data_source,
    null::int as uom_key,
    null::uuid as load_run_id,
    current_timestamp as refreshed_at,
    p.pden_id as pden_id_natural,
    p.pden_type,
    p.pden_source
  from vol v
  join pden p on p.pden_id = v.pden_id and p.pden_type = v.pden_type and p.pden_source = v.pden_source
)
select
  row_number() over (order by date_key, pden_key)::bigint as fact_production_key,
  tenant_id,
  pden_key,
  date_key,
  product_key,
  operator_key,
  field_pool_key,
  oil_cum_volume,
  gas_cum_volume,
  water_cum_volume,
  boe_cum_volume,
  oil_volume_ouom,
  gas_volume_ouom,
  volume_method,
  activity_type,
  data_source,
  uom_key,
  load_run_id,
  refreshed_at,
  pden_id_natural,
  pden_type,
  pden_source
from joined
