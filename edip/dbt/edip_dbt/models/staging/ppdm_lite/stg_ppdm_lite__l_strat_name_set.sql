-- Staging for ppdm_lite.l_strat_name_set (generated)
select
    strat_name_set_id,
    business_associate,
    data_source,
    effective_date,
    ppdm_guid,
    preferred_ind,
    remark
from {{ source('ppdm_lite', 'l_strat_name_set') }}
