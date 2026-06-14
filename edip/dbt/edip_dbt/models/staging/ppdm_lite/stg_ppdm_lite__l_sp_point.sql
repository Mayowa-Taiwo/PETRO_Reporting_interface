-- Staging for ppdm_lite.l_sp_point (generated)
select
    point_id,
    data_source,
    latitude,
    longitude,
    ppdm_guid,
    remark,
    spatial_description_id,
    spatial_obs_no
from {{ source('ppdm_lite', 'l_sp_point') }}
