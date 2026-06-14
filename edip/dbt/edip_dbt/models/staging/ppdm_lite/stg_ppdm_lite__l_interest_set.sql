-- Staging for ppdm_lite.l_interest_set (generated)
select
    interest_set_id,
    data_source,
    effective_date,
    interest_set_type,
    ppdm_guid,
    remark
from {{ source('ppdm_lite', 'l_interest_set') }}
