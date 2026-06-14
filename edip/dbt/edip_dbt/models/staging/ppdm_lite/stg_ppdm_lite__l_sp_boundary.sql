-- Staging for ppdm_lite.l_sp_boundary (generated)
select
    polygon_id,
    point_seq_no,
    data_source,
    latitude,
    longitude,
    ppdm_guid,
    remark
from {{ source('ppdm_lite', 'l_sp_boundary') }}
