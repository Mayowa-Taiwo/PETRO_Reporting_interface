-- Staging for ppdm_lite.l_strat_well_section (generated)
select
    uwi,
    strat_name_set_id,
    strat_unit_id,
    interp_id,
    data_source,
    interpreter,
    ordinal_seq_no,
    overturned_ind,
    pick_date,
    pick_tvd,
    ppdm_guid,
    remark,
    strat_unit_age
from {{ source('ppdm_lite', 'l_strat_well_section') }}
