-- Staging for ppdm_lite.l_pool (generated)
select
    pool_id,
    business_associate,
    country,
    data_source,
    field_id,
    pool_name,
    pool_status,
    pool_type,
    ppdm_guid,
    province_state,
    remark,
    strat_name_set_id,
    strat_unit_id
from {{ source('ppdm_lite', 'l_pool') }}
