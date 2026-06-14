-- Staging for ppdm_lite.l_land_sale (generated)
select
    jurisdiction,
    land_sale_number,
    close_date,
    data_source,
    land_sale_name,
    open_date,
    ppdm_guid,
    remark,
    sale_date
from {{ source('ppdm_lite', 'l_land_sale') }}
