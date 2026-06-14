-- Staging for ppdm_lite.l_strat_unit (generated)
select
    strat_name_set_id,
    strat_unit_id,
    average_age,
    business_associate,
    data_source,
    effective_date,
    fault_type,
    form_code,
    long_name,
    max_age,
    min_age,
    ordinal_age_code,
    ppdm_guid,
    remark
from {{ source('ppdm_lite', 'l_strat_unit') }}
