-- Staging for ppdm_lite.l_sf_support_facility (generated)
select
    support_facility_id,
    sf_type,
    data_source,
    facility_status,
    ppdm_guid,
    remark,
    status_type
from {{ source('ppdm_lite', 'l_sf_support_facility') }}
