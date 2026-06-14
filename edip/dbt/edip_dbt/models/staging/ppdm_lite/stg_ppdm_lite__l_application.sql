-- Staging for ppdm_lite.l_application (generated)
select
    application_id,
    application_type,
    data_source,
    decision,
    ppdm_guid,
    received_date,
    remark,
    resubmission_ind,
    submitted_date
from {{ source('ppdm_lite', 'l_application') }}
