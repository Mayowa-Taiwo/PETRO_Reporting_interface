-- Staging for ppdm_lite.l_field (generated)
select
    field_id,
    country,
    data_source,
    discovery_date,
    field_name,
    field_type,
    group_field_id,
    ppdm_guid,
    province_state,
    remark
from {{ source('ppdm_lite', 'l_field') }}
