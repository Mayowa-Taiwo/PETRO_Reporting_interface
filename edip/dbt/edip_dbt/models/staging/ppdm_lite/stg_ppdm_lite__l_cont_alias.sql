-- Staging for ppdm_lite.l_cont_alias (generated)
select
    contract_id,
    alias_id,
    alias_name,
    alias_owner,
    alias_type,
    data_source,
    ppdm_guid,
    remark
from {{ source('ppdm_lite', 'l_cont_alias') }}
