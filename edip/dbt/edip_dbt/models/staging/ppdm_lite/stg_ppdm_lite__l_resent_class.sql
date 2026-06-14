-- Staging for ppdm_lite.l_resent_class (generated)
select
    resent_id,
    reserve_class_id,
    confidence_factor,
    data_source,
    effective_date,
    ppdm_guid,
    remark
from {{ source('ppdm_lite', 'l_resent_class') }}
