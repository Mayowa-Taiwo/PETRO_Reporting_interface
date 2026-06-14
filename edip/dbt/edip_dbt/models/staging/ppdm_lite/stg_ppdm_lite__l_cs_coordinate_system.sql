-- Staging for ppdm_lite.l_cs_coordinate_system (generated)
select
    coord_system_id,
    coordinate_system_type,
    coord_system_from_uom,
    coord_system_name,
    coord_system_to_uom,
    data_source,
    ellipsoid_id,
    ellipsoid_inverse_flattening,
    ellipsoid_name,
    ellipsoid_semi_major_axis,
    factor_denominator,
    factor_numerator,
    geodetic_datum,
    geodetic_datum_name,
    greenwich_longitude,
    ppdm_guid,
    prime_meridian_id,
    prime_meridian_name,
    remark
from {{ source('ppdm_lite', 'l_cs_coordinate_system') }}
