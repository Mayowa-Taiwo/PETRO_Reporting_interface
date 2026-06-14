-- Staging for ppdm_lite.l_business_associate (generated)
select
    business_associate,
    ba_category,
    ba_code,
    ba_name,
    ba_type,
    current_status,
    data_source,
    effective_date,
    first_name,
    last_name,
    middle_initial,
    ppdm_guid,
    remark
from {{ source('ppdm_lite', 'l_business_associate') }}
