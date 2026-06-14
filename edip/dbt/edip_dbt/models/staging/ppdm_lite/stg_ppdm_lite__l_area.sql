-- Staging for ppdm_lite.l_area (generated)
select
    area_id,
    area_type,
    data_source,
    ppdm_guid,
    preferred_name,
    remark
from {{ source('ppdm_lite', 'l_area') }}
