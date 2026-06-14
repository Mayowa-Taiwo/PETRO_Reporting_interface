-- Staging for ppdm_lite.l_ppdm_origin (generated)
select
    source_table_name,
    source_ppdm_guid,
    target_table_name,
    target_ppdm_guid,
    data_source,
    business_rule,
    ppdm_guid,
    remark,
    source_column_name,
    target_column_name
from {{ source('ppdm_lite', 'l_ppdm_origin') }}
