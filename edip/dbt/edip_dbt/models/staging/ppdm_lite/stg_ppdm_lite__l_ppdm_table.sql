-- Staging for ppdm_lite.l_ppdm_table (generated)
select
    table_name,
    data_source,
    ppdm_guid,
    primary_key_name,
    remark,
    table_comment
from {{ source('ppdm_lite', 'l_ppdm_table') }}
