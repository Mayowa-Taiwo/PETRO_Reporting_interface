-- Staging for ppdm_lite.l_pden_strat_unit (generated)
select
    pden_id,
    pden_type,
    pden_source,
    strat_name_set_id,
    strat_unit_id,
    pden_su_obs_no,
    data_source,
    ppdm_guid,
    remark
from {{ source('ppdm_lite', 'l_pden_strat_unit') }}
