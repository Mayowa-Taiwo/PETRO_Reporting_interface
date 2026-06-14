-- Staging for ppdm_lite.l_sf_xref (generated)
select
    support_facility_id,
    sf_type,
    support_facility_id2,
    sf_type2,
    data_source,
    ppdm_guid,
    remark,
    xref_type
from {{ source('ppdm_lite', 'l_sf_xref') }}
