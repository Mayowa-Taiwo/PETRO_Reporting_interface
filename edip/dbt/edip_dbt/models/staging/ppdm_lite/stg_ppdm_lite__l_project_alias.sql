-- Staging for ppdm_lite.l_project_alias (generated)
select
    project_id,
    alias_id,
    alias_name,
    alias_type,
    data_source,
    owner_ba_id,
    ppdm_guid,
    preferred_ind,
    remark
from {{ source('ppdm_lite', 'l_project_alias') }}
