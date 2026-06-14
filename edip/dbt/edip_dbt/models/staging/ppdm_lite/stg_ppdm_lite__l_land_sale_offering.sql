-- Staging for ppdm_lite.l_land_sale_offering (generated)
select
    jurisdiction,
    land_sale_number,
    land_sale_offering_id,
    area_id,
    area_type,
    cancel_reason,
    data_source,
    land_offering_status,
    land_offering_type,
    ppdm_guid,
    remark,
    status_date
from {{ source('ppdm_lite', 'l_land_sale_offering') }}
