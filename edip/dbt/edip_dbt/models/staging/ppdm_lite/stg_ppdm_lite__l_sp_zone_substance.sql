-- Staging for ppdm_lite.l_sp_zone_substance (generated)
select
    spatial_description_id,
    spatial_obs_no,
    mineral_zone_id,
    substance,
    base_md,
    base_strat_unit_id,
    data_source,
    excluded_ind,
    included_ind,
    ppdm_guid,
    remark,
    strat_name_set_id,
    top_md,
    top_strat_unit_id
from {{ source('ppdm_lite', 'l_sp_zone_substance') }}
