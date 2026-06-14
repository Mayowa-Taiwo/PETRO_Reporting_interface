-- Staging for ppdm_lite.l_seis_point (generated)
select
    seis_set_id,
    seis_set_type,
    seis_point_id,
    data_source,
    datum_elev,
    datum_elev_uom,
    elev,
    elev_ouom,
    end_bend_ind,
    measured_depth,
    measured_depth_uom,
    ppdm_guid,
    reference_datum,
    remark,
    seis_point_label,
    seis_point_lat,
    seis_point_long,
    seis_point_no,
    seis_station_type,
    spatial_seq_no
from {{ source('ppdm_lite', 'l_seis_point') }}
