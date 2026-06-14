-- Staging for ppdm_lite.l_sp_polygon (generated)
select
    polygon_id,
    boundary_direction,
    contained_by_polygon_id,
    data_source,
    exclusion_ind,
    polygon_set_id,
    ppdm_guid,
    remark,
    spatial_description_id,
    spatial_obs_no
from {{ source('ppdm_lite', 'l_sp_polygon') }}
