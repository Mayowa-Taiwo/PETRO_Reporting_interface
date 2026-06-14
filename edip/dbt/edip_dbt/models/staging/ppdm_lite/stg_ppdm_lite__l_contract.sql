-- Staging for ppdm_lite.l_contract (generated)
select
    contract_id,
    confidential_ind,
    contract_name,
    contract_num,
    contract_type,
    current_operator,
    current_status,
    current_status_date,
    data_source,
    dev_penalty_percent,
    equip_penalty_percent,
    expiry_date,
    expl_penalty_percent,
    mktg_fee_elect_percent,
    operating_procedure_type,
    ppdm_guid,
    remark,
    rofr_ind,
    termination_date
from {{ source('ppdm_lite', 'l_contract') }}
