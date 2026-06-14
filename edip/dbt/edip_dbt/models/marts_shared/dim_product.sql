{{
  config(
    materialized='table',
    schema='marts_shared',
  )
}}
with pden as (
  select distinct primary_product from {{ ref('stg_ppdm_lite__l_pden') }}
  union
  select distinct primary_product from {{ ref('stg_ppdm_lite__l_pden_vol_summary') }}
),
final as (
  select
    row_number() over (order by coalesce(primary_product, ''))::int as product_key,
    coalesce(primary_product, '') as product_code,
    coalesce(primary_product, 'Unknown') as product_name,
    case when coalesce(primary_product, '') in ('OIL', 'GAS', 'WATER') then 'Hydrocarbon' else 'Other' end as product_group,
    true as is_primary,
    row_number() over (order by coalesce(primary_product, ''))::int as sort_order,
    null::text as data_source,
    null::date as effective_from,
    null::date as effective_to,
    true as is_current
  from pden
)
select * from final
