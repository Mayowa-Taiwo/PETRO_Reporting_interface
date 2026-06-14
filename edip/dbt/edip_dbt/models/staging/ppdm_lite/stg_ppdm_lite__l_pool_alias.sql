-- Staging for ppdm_lite.l_pool_alias (generated)
select
    pool_id,
    source,
    pool_alias_id,
    alias_owner_ba_id,
    alias_type,
    data_source,
    pool_alias,
    ppdm_guid,
    preferred_ind,
    remark
from {{ source('ppdm_lite', 'l_pool_alias') }}
