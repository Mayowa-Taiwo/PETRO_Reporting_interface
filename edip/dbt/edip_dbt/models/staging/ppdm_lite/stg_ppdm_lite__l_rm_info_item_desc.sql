-- Staging for ppdm_lite.l_rm_info_item_desc (generated)
select
    information_item_id,
    info_item_type,
    description_id,
    data_source,
    description,
    description_date,
    description_type,
    desc_value,
    desc_value_uom,
    ppdm_guid,
    remark
from {{ source('ppdm_lite', 'l_rm_info_item_desc') }}
