-- Staging for ppdm_lite.l_sf_description (generated)
select
    support_facility_id,
    sf_type,
    description_obs_no,
    data_source,
    description,
    desc_type,
    desc_value,
    desc_value_code,
    desc_value_uom,
    ppdm_guid
from {{ source('ppdm_lite', 'l_sf_description') }}
