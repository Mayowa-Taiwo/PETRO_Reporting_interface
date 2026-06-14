-- Staging for ppdm_lite.l_sf_alias (generated)
select
    support_facility_id,
    sf_type,
    alias_id,
    alias,
    alias_type,
    data_source,
    owner_ba_id,
    ppdm_guid,
    preferred_ind,
    remark
from {{ source('ppdm_lite', 'l_sf_alias') }}
