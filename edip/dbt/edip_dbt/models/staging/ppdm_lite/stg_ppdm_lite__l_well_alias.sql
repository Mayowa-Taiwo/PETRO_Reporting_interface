-- Staging for ppdm_lite.l_well_alias (generated)
select
    uwi,
    source,
    well_alias_id,
    alias_type,
    data_source,
    ppdm_guid,
    preferred_ind,
    remark,
    well_alias
from {{ source('ppdm_lite', 'l_well_alias') }}
