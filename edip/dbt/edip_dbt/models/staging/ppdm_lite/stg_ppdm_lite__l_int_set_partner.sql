-- Staging for ppdm_lite.l_int_set_partner (generated)
select
    interest_set_id,
    partner_ba_id,
    data_source,
    gross_fract_interest,
    gross_percent_interest,
    interest_set_role,
    net_fract_interest,
    net_percent_interest,
    ppdm_guid,
    remark
from {{ source('ppdm_lite', 'l_int_set_partner') }}
