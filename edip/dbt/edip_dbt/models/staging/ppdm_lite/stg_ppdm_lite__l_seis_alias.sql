-- Staging for ppdm_lite.l_seis_alias (generated)
select
    seis_set_id,
    seis_set_type,
    seis_alias_id,
    alias_owner,
    data_source,
    ppdm_guid,
    preferred_ind,
    remark,
    seis_set_alias
from {{ source('ppdm_lite', 'l_seis_alias') }}
