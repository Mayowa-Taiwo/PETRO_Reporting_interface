-- Staging for ppdm_lite.l_ppdm_column (generated)
select
    table_name,
    column_name,
    column_comment,
    column_sequence,
    data_source,
    data_type,
    ppdm_guid,
    primary_key_sequence,
    remark
from {{ source('ppdm_lite', 'l_ppdm_column') }}
