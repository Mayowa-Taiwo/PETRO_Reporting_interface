-- Staging for ppdm_lite.l_seis_record (generated)
select
    seis_set_id,
    seis_set_type,
    record_id,
    data_source,
    field_file_number,
    information_item_id,
    info_item_type,
    patch_used_ind,
    ppdm_guid,
    recording_remarks,
    record_number,
    record_quality,
    record_type,
    remark,
    seis_shot_point_id
from {{ source('ppdm_lite', 'l_seis_record') }}
