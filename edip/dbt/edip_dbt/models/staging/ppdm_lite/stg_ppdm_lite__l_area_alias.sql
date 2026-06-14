-- Staging for ppdm_lite.l_area_alias (generated)
select
    area_id,
    area_type,
    area_alias_id,
    alias_owner_ba_id,
    alias_type,
    area_full_name,
    data_source,
    ppdm_guid,
    preferred_ind,
    remark
from {{ source('ppdm_lite', 'l_area_alias') }}
