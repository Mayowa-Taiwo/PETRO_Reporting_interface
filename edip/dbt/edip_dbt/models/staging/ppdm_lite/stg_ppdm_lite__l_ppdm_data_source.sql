-- Staging for ppdm_lite.l_ppdm_data_source (generated)
select
    data_source,
    database_name,
    effective_date,
    ppdm_guid,
    remark,
    user_name
from {{ source('ppdm_lite', 'l_ppdm_data_source') }}
