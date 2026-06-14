-- Staging for ppdm_lite.l_spatial_description (generated)
select
    spatial_description_id,
    spatial_obs_no,
    coord_system_id,
    data_source,
    line_ind,
    max_latitude,
    max_longitude,
    min_latitude,
    min_longitude,
    point_ind,
    polygon_ind,
    ppdm_guid,
    remark,
    spatial_desc_text_ind,
    spatial_desc_type
from {{ source('ppdm_lite', 'l_spatial_description') }}
