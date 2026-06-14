-- Staging for ppdm_lite.l_reserve_entity (generated)
select
    resent_id,
    created_by_ba_id,
    data_source,
    group_type,
    ppdm_guid,
    primary_product_type,
    remark,
    update_schedule
from {{ source('ppdm_lite', 'l_reserve_entity') }}
