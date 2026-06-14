-- Staging for ppdm_lite.l_facility (generated)
select
    facility_id,
    facility_type,
    current_operator,
    data_source,
    facility_function,
    facility_name,
    facility_status,
    facility_status_type,
    h2s_ind,
    last_production_date,
    on_production_date,
    ppdm_guid,
    remark
from {{ source('ppdm_lite', 'l_facility') }}
