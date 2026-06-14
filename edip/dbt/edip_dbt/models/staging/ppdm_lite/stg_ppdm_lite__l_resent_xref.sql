-- Staging for ppdm_lite.l_resent_xref (generated)
select
    resent_id,
    resent_id2,
    xref_obs_no,
    data_source,
    ppdm_guid,
    remark,
    xref_type
from {{ source('ppdm_lite', 'l_resent_xref') }}
