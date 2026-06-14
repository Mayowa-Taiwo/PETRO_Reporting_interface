-- Staging for ppdm_lite.l_sp_line (generated)
select
    line_id,
    data_source,
    ppdm_guid,
    remark,
    spatial_description_id,
    spatial_obs_no
from {{ source('ppdm_lite', 'l_sp_line') }}
