-- Staging for ppdm_lite.l_facility_alias (generated)
select
    facility_id,
    facility_type,
    facility_alias_id,
    source,
    alias_owner_ba_id,
    alias_type,
    data_source,
    facility_alias,
    ppdm_guid,
    preferred_ind,
    remark
from {{ source('ppdm_lite', 'l_facility_alias') }}
