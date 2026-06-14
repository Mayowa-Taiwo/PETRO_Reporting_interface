-- Staging for ppdm_lite.l_finance (generated)
select
    finance_id,
    actual_cost,
    authorized_by_ba_id,
    budget_cost,
    data_source,
    finance_type,
    fin_status,
    issue_date,
    limit_amount,
    ppdm_guid,
    reference_number,
    remark,
    tax_credit_code
from {{ source('ppdm_lite', 'l_finance') }}
