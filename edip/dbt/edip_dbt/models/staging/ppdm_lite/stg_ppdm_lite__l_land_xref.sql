-- Staging for ppdm_lite.l_land_xref (generated)
select
    lr_xref_seq_no,
    child_land_right_type,
    child_land_right_id,
    parent_land_right_type,
    parent_land_right_id,
    allocation_percent,
    data_source,
    land_xref_type,
    ppdm_guid,
    remark
from {{ source('ppdm_lite', 'l_land_xref') }}
