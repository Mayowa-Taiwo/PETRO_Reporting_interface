-- Staging for ppdm_lite.l_sp_mineral_zone (generated)
select
    spatial_description_id,
    spatial_obs_no,
    mineral_zone_id,
    data_source,
    deep_right_reversion_ind,
    ppdm_guid,
    remark,
    zone_definition_id
from {{ source('ppdm_lite', 'l_sp_mineral_zone') }}
