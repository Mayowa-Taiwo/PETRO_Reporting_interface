-- Staging for ppdm_lite.l_sp_line_point (generated)
select
    line_id,
    point_seq_no,
    bend_ind,
    data_source,
    depth,
    elevation,
    first_point_ind,
    last_point_ind,
    latitude,
    longitude,
    ppdm_guid,
    remark
from {{ source('ppdm_lite', 'l_sp_line_point') }}
