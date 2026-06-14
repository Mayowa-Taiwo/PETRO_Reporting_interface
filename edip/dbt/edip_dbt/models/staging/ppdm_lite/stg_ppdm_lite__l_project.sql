-- Staging for ppdm_lite.l_project (generated)
select
    project_id,
    complete_date,
    data_source,
    ppdm_guid,
    project_name,
    project_type,
    remark,
    start_date,
    status
from {{ source('ppdm_lite', 'l_project') }}
