-- Staging for ppdm_lite.l_ppdm_exception (generated)
select
    exception_id,
    data_source,
    error_message,
    error_no,
    exception_column_name,
    exception_date,
    exception_table_name,
    exception_type,
    plsql_name,
    ppdm_guid,
    remark
from {{ source('ppdm_lite', 'l_ppdm_exception') }}
