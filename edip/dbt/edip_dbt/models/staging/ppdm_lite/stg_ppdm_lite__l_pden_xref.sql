-- Staging for ppdm_lite.l_pden_xref (generated)
select
    from_pden_id,
    from_pden_type,
    to_pden_id,
    to_pden_type,
    pden_source,
    xref_obs_no,
    data_source,
    pden_xref_type,
    ppdm_guid,
    remark
from {{ source('ppdm_lite', 'l_pden_xref') }}
