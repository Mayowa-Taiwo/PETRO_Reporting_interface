{{
  config(
    materialized='table',
    schema='marts_production',
  )
}}
with pden as (
  select * from {{ ref('stg_ppdm_lite__l_pden') }}
),
with_tenant as (
  select
    '{{ var("tenant_id_placeholder", "00000000-0000-0000-0000-000000000000") }}'::uuid as tenant_id,
    row_number() over (order by pden_id, pden_type, source)::bigint as pden_key,
    pden_id,
    pden_type,
    source as pden_source,
    pden_name,
    uwi,
    primary_product,
    pool_id,
    field_id,
    data_source,
    null::text as operator_id,
    null::date as effective_from,
    null::date as effective_to,
    true as is_current
  from pden
)
select * from with_tenant
