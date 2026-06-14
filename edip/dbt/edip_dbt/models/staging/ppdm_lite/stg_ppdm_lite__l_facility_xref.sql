-- Staging for ppdm_lite.l_facility_xref (generated)
select
    facility_id,
    facility_type,
    facility_id_2,
    facility_type_2,
    xref_obs_no,
    data_source,
    facility_xref_type,
    ppdm_guid,
    remark
from {{ source('ppdm_lite', 'l_facility_xref') }}
