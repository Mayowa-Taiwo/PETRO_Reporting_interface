-- Staging for ppdm_lite.l_entitlement (generated)
select
    entitlement_id,
    data_source,
    entitlement_type,
    expiry_action,
    expiry_date,
    ppdm_guid,
    primary_term,
    primary_term_uom,
    remark
from {{ source('ppdm_lite', 'l_entitlement') }}
