-- Staging for ppdm_lite.l_land_alias (generated)
select
    land_right_id,
    land_right_type,
    lr_alias_id,
    alias_name,
    alias_owner_ba_id,
    alias_type,
    data_source,
    land_ref_num_type,
    ppdm_guid,
    reason_type,
    remark
from {{ source('ppdm_lite', 'l_land_alias') }}
