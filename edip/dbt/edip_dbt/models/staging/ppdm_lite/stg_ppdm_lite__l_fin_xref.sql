-- Staging for ppdm_lite.l_fin_xref (generated)
select
    finance_id1,
    finance_id2,
    data_source,
    distribution_percent,
    fin_xref_type,
    ppdm_guid,
    remark
from {{ source('ppdm_lite', 'l_fin_xref') }}
