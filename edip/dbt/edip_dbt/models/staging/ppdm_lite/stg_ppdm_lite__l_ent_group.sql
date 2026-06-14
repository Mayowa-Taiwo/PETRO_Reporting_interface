-- Staging for ppdm_lite.l_ent_group (generated)
select
    entitlement_id,
    security_group_id,
    access_type,
    data_source,
    effective_date,
    ppdm_guid,
    restriction_desc
from {{ source('ppdm_lite', 'l_ent_group') }}
