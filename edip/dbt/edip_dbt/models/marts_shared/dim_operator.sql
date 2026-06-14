{{
  config(
    materialized='table',
    schema='marts_shared',
  )
}}
with ba as (
  select * from {{ ref('stg_ppdm_lite__l_business_associate') }}
),
distinct_ops as (
  select distinct
    coalesce(business_associate, '') as operator_id,
    coalesce(ba_name, business_associate, 'Unknown') as operator_name,
    'Company' as operator_type,
    null::text as country,
    data_source,
    null::date as effective_from,
    null::date as effective_to,
    true as is_current
  from ba
)
select
  row_number() over (order by operator_id)::int as operator_key,
  operator_id,
  operator_name,
  operator_type,
  country,
  data_source,
  effective_from,
  effective_to,
  is_current
from distinct_ops
