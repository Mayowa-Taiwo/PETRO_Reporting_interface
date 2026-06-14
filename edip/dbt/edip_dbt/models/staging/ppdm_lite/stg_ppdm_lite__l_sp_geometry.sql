-- Staging for ppdm_lite.l_sp_geometry (generated)
select
    spatial_obs_no,
    spatial_description_id,
    geometry_format,
    geometry_id,
    geometry_obs_no,
    data_source,
    geometry_date,
    geometry_source,
    geometry_type,
    object_source,
    ppdm_guid,
    remark
from {{ source('ppdm_lite', 'l_sp_geometry') }}
