-- Staging for ppdm_lite.l_well_service (generated)
select
    uwi,
    source,
    service_table,
    service_type,
    service_number,
    base_md,
    base_strat_unit_age,
    base_strat_unit_id,
    data_source,
    ppdm_guid,
    primary_strat_unit_age,
    primary_strat_unit_id,
    remark,
    service_date,
    strat_name_set_id,
    top_md,
    top_strat_unit_age,
    top_strat_unit_id
from {{ source('ppdm_lite', 'l_well_service') }}
