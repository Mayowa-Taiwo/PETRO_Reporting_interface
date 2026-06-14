-- Staging for ppdm_lite.l_ba_address (generated)
select
    business_associate,
    source,
    address_obs_no,
    address_type,
    city_id,
    country,
    data_source,
    email_address,
    fax_num,
    first_address_line,
    phone_num,
    postal_zip_code,
    ppdm_guid,
    province_state,
    remark,
    second_address_line,
    third_address_line,
    web_url
from {{ source('ppdm_lite', 'l_ba_address') }}
