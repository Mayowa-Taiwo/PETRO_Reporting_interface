-- Staging for ppdm_lite.l_cont_extension (generated)
select
    contract_id,
    extension_id,
    data_source,
    extension_type,
    issued_by,
    issued_date,
    land_right_id,
    land_right_type,
    ppdm_guid,
    remark
from {{ source('ppdm_lite', 'l_cont_extension') }}
