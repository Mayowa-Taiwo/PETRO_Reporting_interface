-- Staging for ppdm_lite.l_fin_cost_summary (generated)
select
    cost_id,
    cost_amount,
    cost_type,
    data_source,
    finance_component_id,
    finance_id,
    paid_date,
    parent_cost_id,
    ppdm_guid,
    remark,
    submit_date
from {{ source('ppdm_lite', 'l_fin_cost_summary') }}
