-- Staging for ppdm_lite.l_facility_substance (generated)
select
    facility_id,
    facility_type,
    substance_id,
    average_capacity,
    capacity_uom,
    data_source,
    max_capacity,
    ppdm_guid,
    remark
from {{ source('ppdm_lite', 'l_facility_substance') }}
