-- Staging for ppdm_lite.l_rm_information_item (generated)
select
    information_item_id,
    info_item_type,
    catalogue_date,
    catalogue_name,
    data_source,
    information_quality,
    item_category,
    item_sub_category,
    media_type,
    origin_date,
    physical_item_id,
    physical_item_status,
    ppdm_guid,
    reference_num,
    remark,
    retention_period,
    store_id,
    title
from {{ source('ppdm_lite', 'l_rm_information_item') }}
