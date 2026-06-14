-- Staging for ppdm_lite.l_ba_alias (generated)
select
    business_associate,
    source,
    ba_alias_id,
    alias_name,
    alias_type,
    data_source,
    ppdm_guid,
    preferred_ind,
    remark
from {{ source('ppdm_lite', 'l_ba_alias') }}
