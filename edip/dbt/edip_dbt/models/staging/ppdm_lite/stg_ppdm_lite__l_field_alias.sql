-- Staging for ppdm_lite.l_field_alias (generated)
select
    field_id,
    field_alias_id,
    source,
    alias_owner_ba_id,
    alias_type,
    data_source,
    field_alias,
    ppdm_guid,
    preferred_ind,
    remark
from {{ source('ppdm_lite', 'l_field_alias') }}
