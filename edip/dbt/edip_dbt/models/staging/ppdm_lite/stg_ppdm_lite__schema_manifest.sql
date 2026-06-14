-- Schema manifest: (table_name, column_name) for governance and coverage scoring (generated)
with base as (
    select 'l_application' as table_name, 'application_id' as column_name
union all
    select 'l_application' as table_name, 'application_type' as column_name
union all
    select 'l_application' as table_name, 'data_source' as column_name
union all
    select 'l_application' as table_name, 'decision' as column_name
union all
    select 'l_application' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_application' as table_name, 'received_date' as column_name
union all
    select 'l_application' as table_name, 'remark' as column_name
union all
    select 'l_application' as table_name, 'resubmission_ind' as column_name
union all
    select 'l_application' as table_name, 'submitted_date' as column_name
union all
    select 'l_area' as table_name, 'area_id' as column_name
union all
    select 'l_area' as table_name, 'area_type' as column_name
union all
    select 'l_area' as table_name, 'data_source' as column_name
union all
    select 'l_area' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_area' as table_name, 'preferred_name' as column_name
union all
    select 'l_area' as table_name, 'remark' as column_name
union all
    select 'l_area_alias' as table_name, 'area_id' as column_name
union all
    select 'l_area_alias' as table_name, 'area_type' as column_name
union all
    select 'l_area_alias' as table_name, 'area_alias_id' as column_name
union all
    select 'l_area_alias' as table_name, 'alias_owner_ba_id' as column_name
union all
    select 'l_area_alias' as table_name, 'alias_type' as column_name
union all
    select 'l_area_alias' as table_name, 'area_full_name' as column_name
union all
    select 'l_area_alias' as table_name, 'data_source' as column_name
union all
    select 'l_area_alias' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_area_alias' as table_name, 'preferred_ind' as column_name
union all
    select 'l_area_alias' as table_name, 'remark' as column_name
union all
    select 'l_ba_address' as table_name, 'business_associate' as column_name
union all
    select 'l_ba_address' as table_name, 'source' as column_name
union all
    select 'l_ba_address' as table_name, 'address_obs_no' as column_name
union all
    select 'l_ba_address' as table_name, 'address_type' as column_name
union all
    select 'l_ba_address' as table_name, 'city_id' as column_name
union all
    select 'l_ba_address' as table_name, 'country' as column_name
union all
    select 'l_ba_address' as table_name, 'data_source' as column_name
union all
    select 'l_ba_address' as table_name, 'email_address' as column_name
union all
    select 'l_ba_address' as table_name, 'fax_num' as column_name
union all
    select 'l_ba_address' as table_name, 'first_address_line' as column_name
union all
    select 'l_ba_address' as table_name, 'phone_num' as column_name
union all
    select 'l_ba_address' as table_name, 'postal_zip_code' as column_name
union all
    select 'l_ba_address' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_ba_address' as table_name, 'province_state' as column_name
union all
    select 'l_ba_address' as table_name, 'remark' as column_name
union all
    select 'l_ba_address' as table_name, 'second_address_line' as column_name
union all
    select 'l_ba_address' as table_name, 'third_address_line' as column_name
union all
    select 'l_ba_address' as table_name, 'web_url' as column_name
union all
    select 'l_ba_alias' as table_name, 'business_associate' as column_name
union all
    select 'l_ba_alias' as table_name, 'source' as column_name
union all
    select 'l_ba_alias' as table_name, 'ba_alias_id' as column_name
union all
    select 'l_ba_alias' as table_name, 'alias_name' as column_name
union all
    select 'l_ba_alias' as table_name, 'alias_type' as column_name
union all
    select 'l_ba_alias' as table_name, 'data_source' as column_name
union all
    select 'l_ba_alias' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_ba_alias' as table_name, 'preferred_ind' as column_name
union all
    select 'l_ba_alias' as table_name, 'remark' as column_name
union all
    select 'l_business_associate' as table_name, 'business_associate' as column_name
union all
    select 'l_business_associate' as table_name, 'ba_category' as column_name
union all
    select 'l_business_associate' as table_name, 'ba_code' as column_name
union all
    select 'l_business_associate' as table_name, 'ba_name' as column_name
union all
    select 'l_business_associate' as table_name, 'ba_type' as column_name
union all
    select 'l_business_associate' as table_name, 'current_status' as column_name
union all
    select 'l_business_associate' as table_name, 'data_source' as column_name
union all
    select 'l_business_associate' as table_name, 'effective_date' as column_name
union all
    select 'l_business_associate' as table_name, 'first_name' as column_name
union all
    select 'l_business_associate' as table_name, 'last_name' as column_name
union all
    select 'l_business_associate' as table_name, 'middle_initial' as column_name
union all
    select 'l_business_associate' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_business_associate' as table_name, 'remark' as column_name
union all
    select 'l_cont_alias' as table_name, 'contract_id' as column_name
union all
    select 'l_cont_alias' as table_name, 'alias_id' as column_name
union all
    select 'l_cont_alias' as table_name, 'alias_name' as column_name
union all
    select 'l_cont_alias' as table_name, 'alias_owner' as column_name
union all
    select 'l_cont_alias' as table_name, 'alias_type' as column_name
union all
    select 'l_cont_alias' as table_name, 'data_source' as column_name
union all
    select 'l_cont_alias' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_cont_alias' as table_name, 'remark' as column_name
union all
    select 'l_cont_extension' as table_name, 'contract_id' as column_name
union all
    select 'l_cont_extension' as table_name, 'extension_id' as column_name
union all
    select 'l_cont_extension' as table_name, 'data_source' as column_name
union all
    select 'l_cont_extension' as table_name, 'extension_type' as column_name
union all
    select 'l_cont_extension' as table_name, 'issued_by' as column_name
union all
    select 'l_cont_extension' as table_name, 'issued_date' as column_name
union all
    select 'l_cont_extension' as table_name, 'land_right_id' as column_name
union all
    select 'l_cont_extension' as table_name, 'land_right_type' as column_name
union all
    select 'l_cont_extension' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_cont_extension' as table_name, 'remark' as column_name
union all
    select 'l_contract' as table_name, 'contract_id' as column_name
union all
    select 'l_contract' as table_name, 'confidential_ind' as column_name
union all
    select 'l_contract' as table_name, 'contract_name' as column_name
union all
    select 'l_contract' as table_name, 'contract_num' as column_name
union all
    select 'l_contract' as table_name, 'contract_type' as column_name
union all
    select 'l_contract' as table_name, 'current_operator' as column_name
union all
    select 'l_contract' as table_name, 'current_status' as column_name
union all
    select 'l_contract' as table_name, 'current_status_date' as column_name
union all
    select 'l_contract' as table_name, 'data_source' as column_name
union all
    select 'l_contract' as table_name, 'dev_penalty_percent' as column_name
union all
    select 'l_contract' as table_name, 'equip_penalty_percent' as column_name
union all
    select 'l_contract' as table_name, 'expiry_date' as column_name
union all
    select 'l_contract' as table_name, 'expl_penalty_percent' as column_name
union all
    select 'l_contract' as table_name, 'mktg_fee_elect_percent' as column_name
union all
    select 'l_contract' as table_name, 'operating_procedure_type' as column_name
union all
    select 'l_contract' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_contract' as table_name, 'remark' as column_name
union all
    select 'l_contract' as table_name, 'rofr_ind' as column_name
union all
    select 'l_contract' as table_name, 'termination_date' as column_name
union all
    select 'l_contract_component' as table_name, 'contract_id' as column_name
union all
    select 'l_contract_component' as table_name, 'component_id' as column_name
union all
    select 'l_contract_component' as table_name, 'application_id' as column_name
union all
    select 'l_contract_component' as table_name, 'area_id' as column_name
union all
    select 'l_contract_component' as table_name, 'area_type' as column_name
union all
    select 'l_contract_component' as table_name, 'business_associate' as column_name
union all
    select 'l_contract_component' as table_name, 'data_source' as column_name
union all
    select 'l_contract_component' as table_name, 'facility_id' as column_name
union all
    select 'l_contract_component' as table_name, 'facility_type' as column_name
union all
    select 'l_contract_component' as table_name, 'field_id' as column_name
union all
    select 'l_contract_component' as table_name, 'information_item_id' as column_name
union all
    select 'l_contract_component' as table_name, 'info_item_type' as column_name
union all
    select 'l_contract_component' as table_name, 'jurisdiction' as column_name
union all
    select 'l_contract_component' as table_name, 'land_right_id' as column_name
union all
    select 'l_contract_component' as table_name, 'land_right_type' as column_name
union all
    select 'l_contract_component' as table_name, 'land_sale_number' as column_name
union all
    select 'l_contract_component' as table_name, 'land_sale_offering_id' as column_name
union all
    select 'l_contract_component' as table_name, 'pden_id' as column_name
union all
    select 'l_contract_component' as table_name, 'pden_source' as column_name
union all
    select 'l_contract_component' as table_name, 'pden_type' as column_name
union all
    select 'l_contract_component' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_contract_component' as table_name, 'reason_type' as column_name
union all
    select 'l_contract_component' as table_name, 'remark' as column_name
union all
    select 'l_contract_component' as table_name, 'seis_set_id' as column_name
union all
    select 'l_contract_component' as table_name, 'seis_set_type' as column_name
union all
    select 'l_contract_component' as table_name, 'support_facility_id' as column_name
union all
    select 'l_contract_component' as table_name, 'support_facility_type' as column_name
union all
    select 'l_contract_component' as table_name, 'uwi' as column_name
union all
    select 'l_cs_coordinate_system' as table_name, 'coord_system_id' as column_name
union all
    select 'l_cs_coordinate_system' as table_name, 'coordinate_system_type' as column_name
union all
    select 'l_cs_coordinate_system' as table_name, 'coord_system_from_uom' as column_name
union all
    select 'l_cs_coordinate_system' as table_name, 'coord_system_name' as column_name
union all
    select 'l_cs_coordinate_system' as table_name, 'coord_system_to_uom' as column_name
union all
    select 'l_cs_coordinate_system' as table_name, 'data_source' as column_name
union all
    select 'l_cs_coordinate_system' as table_name, 'ellipsoid_id' as column_name
union all
    select 'l_cs_coordinate_system' as table_name, 'ellipsoid_inverse_flattening' as column_name
union all
    select 'l_cs_coordinate_system' as table_name, 'ellipsoid_name' as column_name
union all
    select 'l_cs_coordinate_system' as table_name, 'ellipsoid_semi_major_axis' as column_name
union all
    select 'l_cs_coordinate_system' as table_name, 'factor_denominator' as column_name
union all
    select 'l_cs_coordinate_system' as table_name, 'factor_numerator' as column_name
union all
    select 'l_cs_coordinate_system' as table_name, 'geodetic_datum' as column_name
union all
    select 'l_cs_coordinate_system' as table_name, 'geodetic_datum_name' as column_name
union all
    select 'l_cs_coordinate_system' as table_name, 'greenwich_longitude' as column_name
union all
    select 'l_cs_coordinate_system' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_cs_coordinate_system' as table_name, 'prime_meridian_id' as column_name
union all
    select 'l_cs_coordinate_system' as table_name, 'prime_meridian_name' as column_name
union all
    select 'l_cs_coordinate_system' as table_name, 'remark' as column_name
union all
    select 'l_ent_component' as table_name, 'entitlement_id' as column_name
union all
    select 'l_ent_component' as table_name, 'component_id' as column_name
union all
    select 'l_ent_component' as table_name, 'area_id' as column_name
union all
    select 'l_ent_component' as table_name, 'area_type' as column_name
union all
    select 'l_ent_component' as table_name, 'business_associate' as column_name
union all
    select 'l_ent_component' as table_name, 'contract_id' as column_name
union all
    select 'l_ent_component' as table_name, 'data_source' as column_name
union all
    select 'l_ent_component' as table_name, 'description' as column_name
union all
    select 'l_ent_component' as table_name, 'ent_comp_type' as column_name
union all
    select 'l_ent_component' as table_name, 'ent_rule' as column_name
union all
    select 'l_ent_component' as table_name, 'facility_id' as column_name
union all
    select 'l_ent_component' as table_name, 'facility_type' as column_name
union all
    select 'l_ent_component' as table_name, 'field_id' as column_name
union all
    select 'l_ent_component' as table_name, 'information_item_id' as column_name
union all
    select 'l_ent_component' as table_name, 'info_item_type' as column_name
union all
    select 'l_ent_component' as table_name, 'interest_set_id' as column_name
union all
    select 'l_ent_component' as table_name, 'land_right_id' as column_name
union all
    select 'l_ent_component' as table_name, 'land_right_type' as column_name
union all
    select 'l_ent_component' as table_name, 'pden_id' as column_name
union all
    select 'l_ent_component' as table_name, 'pden_source' as column_name
union all
    select 'l_ent_component' as table_name, 'pden_type' as column_name
union all
    select 'l_ent_component' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_ent_component' as table_name, 'resent_id' as column_name
union all
    select 'l_ent_component' as table_name, 'seis_set_id' as column_name
union all
    select 'l_ent_component' as table_name, 'seis_set_type' as column_name
union all
    select 'l_ent_component' as table_name, 'uwi' as column_name
union all
    select 'l_ent_group' as table_name, 'entitlement_id' as column_name
union all
    select 'l_ent_group' as table_name, 'security_group_id' as column_name
union all
    select 'l_ent_group' as table_name, 'access_type' as column_name
union all
    select 'l_ent_group' as table_name, 'data_source' as column_name
union all
    select 'l_ent_group' as table_name, 'effective_date' as column_name
union all
    select 'l_ent_group' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_ent_group' as table_name, 'restriction_desc' as column_name
union all
    select 'l_entitlement' as table_name, 'entitlement_id' as column_name
union all
    select 'l_entitlement' as table_name, 'data_source' as column_name
union all
    select 'l_entitlement' as table_name, 'entitlement_type' as column_name
union all
    select 'l_entitlement' as table_name, 'expiry_action' as column_name
union all
    select 'l_entitlement' as table_name, 'expiry_date' as column_name
union all
    select 'l_entitlement' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_entitlement' as table_name, 'primary_term' as column_name
union all
    select 'l_entitlement' as table_name, 'primary_term_uom' as column_name
union all
    select 'l_entitlement' as table_name, 'remark' as column_name
union all
    select 'l_facility' as table_name, 'facility_id' as column_name
union all
    select 'l_facility' as table_name, 'facility_type' as column_name
union all
    select 'l_facility' as table_name, 'current_operator' as column_name
union all
    select 'l_facility' as table_name, 'data_source' as column_name
union all
    select 'l_facility' as table_name, 'facility_function' as column_name
union all
    select 'l_facility' as table_name, 'facility_name' as column_name
union all
    select 'l_facility' as table_name, 'facility_status' as column_name
union all
    select 'l_facility' as table_name, 'facility_status_type' as column_name
union all
    select 'l_facility' as table_name, 'h2s_ind' as column_name
union all
    select 'l_facility' as table_name, 'last_production_date' as column_name
union all
    select 'l_facility' as table_name, 'on_production_date' as column_name
union all
    select 'l_facility' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_facility' as table_name, 'remark' as column_name
union all
    select 'l_facility_alias' as table_name, 'facility_id' as column_name
union all
    select 'l_facility_alias' as table_name, 'facility_type' as column_name
union all
    select 'l_facility_alias' as table_name, 'facility_alias_id' as column_name
union all
    select 'l_facility_alias' as table_name, 'source' as column_name
union all
    select 'l_facility_alias' as table_name, 'alias_owner_ba_id' as column_name
union all
    select 'l_facility_alias' as table_name, 'alias_type' as column_name
union all
    select 'l_facility_alias' as table_name, 'data_source' as column_name
union all
    select 'l_facility_alias' as table_name, 'facility_alias' as column_name
union all
    select 'l_facility_alias' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_facility_alias' as table_name, 'preferred_ind' as column_name
union all
    select 'l_facility_alias' as table_name, 'remark' as column_name
union all
    select 'l_facility_substance' as table_name, 'facility_id' as column_name
union all
    select 'l_facility_substance' as table_name, 'facility_type' as column_name
union all
    select 'l_facility_substance' as table_name, 'substance_id' as column_name
union all
    select 'l_facility_substance' as table_name, 'average_capacity' as column_name
union all
    select 'l_facility_substance' as table_name, 'capacity_uom' as column_name
union all
    select 'l_facility_substance' as table_name, 'data_source' as column_name
union all
    select 'l_facility_substance' as table_name, 'max_capacity' as column_name
union all
    select 'l_facility_substance' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_facility_substance' as table_name, 'remark' as column_name
union all
    select 'l_facility_xref' as table_name, 'facility_id' as column_name
union all
    select 'l_facility_xref' as table_name, 'facility_type' as column_name
union all
    select 'l_facility_xref' as table_name, 'facility_id_2' as column_name
union all
    select 'l_facility_xref' as table_name, 'facility_type_2' as column_name
union all
    select 'l_facility_xref' as table_name, 'xref_obs_no' as column_name
union all
    select 'l_facility_xref' as table_name, 'data_source' as column_name
union all
    select 'l_facility_xref' as table_name, 'facility_xref_type' as column_name
union all
    select 'l_facility_xref' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_facility_xref' as table_name, 'remark' as column_name
union all
    select 'l_field' as table_name, 'field_id' as column_name
union all
    select 'l_field' as table_name, 'country' as column_name
union all
    select 'l_field' as table_name, 'data_source' as column_name
union all
    select 'l_field' as table_name, 'discovery_date' as column_name
union all
    select 'l_field' as table_name, 'field_name' as column_name
union all
    select 'l_field' as table_name, 'field_type' as column_name
union all
    select 'l_field' as table_name, 'group_field_id' as column_name
union all
    select 'l_field' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_field' as table_name, 'province_state' as column_name
union all
    select 'l_field' as table_name, 'remark' as column_name
union all
    select 'l_field_alias' as table_name, 'field_id' as column_name
union all
    select 'l_field_alias' as table_name, 'field_alias_id' as column_name
union all
    select 'l_field_alias' as table_name, 'source' as column_name
union all
    select 'l_field_alias' as table_name, 'alias_owner_ba_id' as column_name
union all
    select 'l_field_alias' as table_name, 'alias_type' as column_name
union all
    select 'l_field_alias' as table_name, 'data_source' as column_name
union all
    select 'l_field_alias' as table_name, 'field_alias' as column_name
union all
    select 'l_field_alias' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_field_alias' as table_name, 'preferred_ind' as column_name
union all
    select 'l_field_alias' as table_name, 'remark' as column_name
union all
    select 'l_fin_component' as table_name, 'finance_id' as column_name
union all
    select 'l_fin_component' as table_name, 'finance_component_id' as column_name
union all
    select 'l_fin_component' as table_name, 'application_id' as column_name
union all
    select 'l_fin_component' as table_name, 'area_id' as column_name
union all
    select 'l_fin_component' as table_name, 'area_type' as column_name
union all
    select 'l_fin_component' as table_name, 'business_associate' as column_name
union all
    select 'l_fin_component' as table_name, 'data_source' as column_name
union all
    select 'l_fin_component' as table_name, 'facility_id' as column_name
union all
    select 'l_fin_component' as table_name, 'facility_type' as column_name
union all
    select 'l_fin_component' as table_name, 'field_id' as column_name
union all
    select 'l_fin_component' as table_name, 'information_item_id' as column_name
union all
    select 'l_fin_component' as table_name, 'info_item_type' as column_name
union all
    select 'l_fin_component' as table_name, 'interest_set_id' as column_name
union all
    select 'l_fin_component' as table_name, 'land_right_id' as column_name
union all
    select 'l_fin_component' as table_name, 'land_right_type' as column_name
union all
    select 'l_fin_component' as table_name, 'land_sale_jurisdiction' as column_name
union all
    select 'l_fin_component' as table_name, 'land_sale_number' as column_name
union all
    select 'l_fin_component' as table_name, 'land_sale_offering_id' as column_name
union all
    select 'l_fin_component' as table_name, 'license_id' as column_name
union all
    select 'l_fin_component' as table_name, 'license_table' as column_name
union all
    select 'l_fin_component' as table_name, 'pool_id' as column_name
union all
    select 'l_fin_component' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_fin_component' as table_name, 'remark' as column_name
union all
    select 'l_fin_component' as table_name, 'resent_id' as column_name
union all
    select 'l_fin_component' as table_name, 'reserve_class_id' as column_name
union all
    select 'l_fin_component' as table_name, 'seis_set_id' as column_name
union all
    select 'l_fin_component' as table_name, 'seis_set_type' as column_name
union all
    select 'l_fin_component' as table_name, 'support_facility_id' as column_name
union all
    select 'l_fin_component' as table_name, 'support_facility_type' as column_name
union all
    select 'l_fin_component' as table_name, 'uwi' as column_name
union all
    select 'l_fin_cost_summary' as table_name, 'cost_id' as column_name
union all
    select 'l_fin_cost_summary' as table_name, 'cost_amount' as column_name
union all
    select 'l_fin_cost_summary' as table_name, 'cost_type' as column_name
union all
    select 'l_fin_cost_summary' as table_name, 'data_source' as column_name
union all
    select 'l_fin_cost_summary' as table_name, 'finance_component_id' as column_name
union all
    select 'l_fin_cost_summary' as table_name, 'finance_id' as column_name
union all
    select 'l_fin_cost_summary' as table_name, 'paid_date' as column_name
union all
    select 'l_fin_cost_summary' as table_name, 'parent_cost_id' as column_name
union all
    select 'l_fin_cost_summary' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_fin_cost_summary' as table_name, 'remark' as column_name
union all
    select 'l_fin_cost_summary' as table_name, 'submit_date' as column_name
union all
    select 'l_fin_xref' as table_name, 'finance_id1' as column_name
union all
    select 'l_fin_xref' as table_name, 'finance_id2' as column_name
union all
    select 'l_fin_xref' as table_name, 'data_source' as column_name
union all
    select 'l_fin_xref' as table_name, 'distribution_percent' as column_name
union all
    select 'l_fin_xref' as table_name, 'fin_xref_type' as column_name
union all
    select 'l_fin_xref' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_fin_xref' as table_name, 'remark' as column_name
union all
    select 'l_finance' as table_name, 'finance_id' as column_name
union all
    select 'l_finance' as table_name, 'actual_cost' as column_name
union all
    select 'l_finance' as table_name, 'authorized_by_ba_id' as column_name
union all
    select 'l_finance' as table_name, 'budget_cost' as column_name
union all
    select 'l_finance' as table_name, 'data_source' as column_name
union all
    select 'l_finance' as table_name, 'finance_type' as column_name
union all
    select 'l_finance' as table_name, 'fin_status' as column_name
union all
    select 'l_finance' as table_name, 'issue_date' as column_name
union all
    select 'l_finance' as table_name, 'limit_amount' as column_name
union all
    select 'l_finance' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_finance' as table_name, 'reference_number' as column_name
union all
    select 'l_finance' as table_name, 'remark' as column_name
union all
    select 'l_finance' as table_name, 'tax_credit_code' as column_name
union all
    select 'l_int_set_component' as table_name, 'interest_set_id' as column_name
union all
    select 'l_int_set_component' as table_name, 'business_associate' as column_name
union all
    select 'l_int_set_component' as table_name, 'component_type' as column_name
union all
    select 'l_int_set_component' as table_name, 'contract_id' as column_name
union all
    select 'l_int_set_component' as table_name, 'data_source' as column_name
union all
    select 'l_int_set_component' as table_name, 'facility_id' as column_name
union all
    select 'l_int_set_component' as table_name, 'facility_type' as column_name
union all
    select 'l_int_set_component' as table_name, 'information_item_id' as column_name
union all
    select 'l_int_set_component' as table_name, 'info_item_type' as column_name
union all
    select 'l_int_set_component' as table_name, 'jurisdiction' as column_name
union all
    select 'l_int_set_component' as table_name, 'land_offering_bid' as column_name
union all
    select 'l_int_set_component' as table_name, 'land_right_id' as column_name
union all
    select 'l_int_set_component' as table_name, 'land_right_type' as column_name
union all
    select 'l_int_set_component' as table_name, 'land_sale_number' as column_name
union all
    select 'l_int_set_component' as table_name, 'pden_id' as column_name
union all
    select 'l_int_set_component' as table_name, 'pden_source' as column_name
union all
    select 'l_int_set_component' as table_name, 'pden_type' as column_name
union all
    select 'l_int_set_component' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_int_set_component' as table_name, 'remark' as column_name
union all
    select 'l_int_set_component' as table_name, 'resent_id' as column_name
union all
    select 'l_int_set_component' as table_name, 'reserve_class_id' as column_name
union all
    select 'l_int_set_component' as table_name, 'seis_set_id' as column_name
union all
    select 'l_int_set_component' as table_name, 'seis_set_type' as column_name
union all
    select 'l_int_set_component' as table_name, 'sf_type' as column_name
union all
    select 'l_int_set_component' as table_name, 'support_facility_id' as column_name
union all
    select 'l_int_set_component' as table_name, 'uwi' as column_name
union all
    select 'l_int_set_partner' as table_name, 'interest_set_id' as column_name
union all
    select 'l_int_set_partner' as table_name, 'partner_ba_id' as column_name
union all
    select 'l_int_set_partner' as table_name, 'data_source' as column_name
union all
    select 'l_int_set_partner' as table_name, 'gross_fract_interest' as column_name
union all
    select 'l_int_set_partner' as table_name, 'gross_percent_interest' as column_name
union all
    select 'l_int_set_partner' as table_name, 'interest_set_role' as column_name
union all
    select 'l_int_set_partner' as table_name, 'net_fract_interest' as column_name
union all
    select 'l_int_set_partner' as table_name, 'net_percent_interest' as column_name
union all
    select 'l_int_set_partner' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_int_set_partner' as table_name, 'remark' as column_name
union all
    select 'l_interest_set' as table_name, 'interest_set_id' as column_name
union all
    select 'l_interest_set' as table_name, 'data_source' as column_name
union all
    select 'l_interest_set' as table_name, 'effective_date' as column_name
union all
    select 'l_interest_set' as table_name, 'interest_set_type' as column_name
union all
    select 'l_interest_set' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_interest_set' as table_name, 'remark' as column_name
union all
    select 'l_land_alias' as table_name, 'land_right_id' as column_name
union all
    select 'l_land_alias' as table_name, 'land_right_type' as column_name
union all
    select 'l_land_alias' as table_name, 'lr_alias_id' as column_name
union all
    select 'l_land_alias' as table_name, 'alias_name' as column_name
union all
    select 'l_land_alias' as table_name, 'alias_owner_ba_id' as column_name
union all
    select 'l_land_alias' as table_name, 'alias_type' as column_name
union all
    select 'l_land_alias' as table_name, 'data_source' as column_name
union all
    select 'l_land_alias' as table_name, 'land_ref_num_type' as column_name
union all
    select 'l_land_alias' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_land_alias' as table_name, 'reason_type' as column_name
union all
    select 'l_land_alias' as table_name, 'remark' as column_name
union all
    select 'l_land_right' as table_name, 'land_right_id' as column_name
union all
    select 'l_land_right' as table_name, 'land_right_type' as column_name
union all
    select 'l_land_right' as table_name, 'cost_center_num' as column_name
union all
    select 'l_land_right' as table_name, 'country' as column_name
union all
    select 'l_land_right' as table_name, 'data_source' as column_name
union all
    select 'l_land_right' as table_name, 'expiry_date' as column_name
union all
    select 'l_land_right' as table_name, 'granted_right_type' as column_name
union all
    select 'l_land_right' as table_name, 'jurisdiction' as column_name
union all
    select 'l_land_right' as table_name, 'land_acqtn_method' as column_name
union all
    select 'l_land_right' as table_name, 'land_property_type' as column_name
union all
    select 'l_land_right' as table_name, 'land_right_category' as column_name
union all
    select 'l_land_right' as table_name, 'land_sale_number' as column_name
union all
    select 'l_land_right' as table_name, 'land_sale_offering_id' as column_name
union all
    select 'l_land_right' as table_name, 'lessor_num' as column_name
union all
    select 'l_land_right' as table_name, 'lessor_type' as column_name
union all
    select 'l_land_right' as table_name, 'occupant_name' as column_name
union all
    select 'l_land_right' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_land_right' as table_name, 'primary_term' as column_name
union all
    select 'l_land_right' as table_name, 'primary_term_uom' as column_name
union all
    select 'l_land_right' as table_name, 'province_state' as column_name
union all
    select 'l_land_right' as table_name, 'remark' as column_name
union all
    select 'l_land_right' as table_name, 'rofr_ind' as column_name
union all
    select 'l_land_sale' as table_name, 'jurisdiction' as column_name
union all
    select 'l_land_sale' as table_name, 'land_sale_number' as column_name
union all
    select 'l_land_sale' as table_name, 'close_date' as column_name
union all
    select 'l_land_sale' as table_name, 'data_source' as column_name
union all
    select 'l_land_sale' as table_name, 'land_sale_name' as column_name
union all
    select 'l_land_sale' as table_name, 'open_date' as column_name
union all
    select 'l_land_sale' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_land_sale' as table_name, 'remark' as column_name
union all
    select 'l_land_sale' as table_name, 'sale_date' as column_name
union all
    select 'l_land_sale_offering' as table_name, 'jurisdiction' as column_name
union all
    select 'l_land_sale_offering' as table_name, 'land_sale_number' as column_name
union all
    select 'l_land_sale_offering' as table_name, 'land_sale_offering_id' as column_name
union all
    select 'l_land_sale_offering' as table_name, 'area_id' as column_name
union all
    select 'l_land_sale_offering' as table_name, 'area_type' as column_name
union all
    select 'l_land_sale_offering' as table_name, 'cancel_reason' as column_name
union all
    select 'l_land_sale_offering' as table_name, 'data_source' as column_name
union all
    select 'l_land_sale_offering' as table_name, 'land_offering_status' as column_name
union all
    select 'l_land_sale_offering' as table_name, 'land_offering_type' as column_name
union all
    select 'l_land_sale_offering' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_land_sale_offering' as table_name, 'remark' as column_name
union all
    select 'l_land_sale_offering' as table_name, 'status_date' as column_name
union all
    select 'l_land_xref' as table_name, 'lr_xref_seq_no' as column_name
union all
    select 'l_land_xref' as table_name, 'child_land_right_type' as column_name
union all
    select 'l_land_xref' as table_name, 'child_land_right_id' as column_name
union all
    select 'l_land_xref' as table_name, 'parent_land_right_type' as column_name
union all
    select 'l_land_xref' as table_name, 'parent_land_right_id' as column_name
union all
    select 'l_land_xref' as table_name, 'allocation_percent' as column_name
union all
    select 'l_land_xref' as table_name, 'data_source' as column_name
union all
    select 'l_land_xref' as table_name, 'land_xref_type' as column_name
union all
    select 'l_land_xref' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_land_xref' as table_name, 'remark' as column_name
union all
    select 'l_license' as table_name, 'license_id' as column_name
union all
    select 'l_license' as table_name, 'license_table' as column_name
union all
    select 'l_license' as table_name, 'data_source' as column_name
union all
    select 'l_license' as table_name, 'effective_date' as column_name
union all
    select 'l_license' as table_name, 'expiry_date' as column_name
union all
    select 'l_license' as table_name, 'facility_id' as column_name
union all
    select 'l_license' as table_name, 'facility_type' as column_name
union all
    select 'l_license' as table_name, 'granted_by_ba_id' as column_name
union all
    select 'l_license' as table_name, 'granted_date' as column_name
union all
    select 'l_license' as table_name, 'granted_to_ba_id' as column_name
union all
    select 'l_license' as table_name, 'license_ba_id' as column_name
union all
    select 'l_license' as table_name, 'license_num' as column_name
union all
    select 'l_license' as table_name, 'license_status' as column_name
union all
    select 'l_license' as table_name, 'license_term' as column_name
union all
    select 'l_license' as table_name, 'license_type' as column_name
union all
    select 'l_license' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_license' as table_name, 'remark' as column_name
union all
    select 'l_license' as table_name, 'secondary_term' as column_name
union all
    select 'l_license' as table_name, 'seis_set_id' as column_name
union all
    select 'l_license' as table_name, 'seis_set_type' as column_name
union all
    select 'l_license' as table_name, 'uwi' as column_name
union all
    select 'l_license' as table_name, 'well_license_source' as column_name
union all
    select 'l_pden' as table_name, 'pden_id' as column_name
union all
    select 'l_pden' as table_name, 'pden_type' as column_name
union all
    select 'l_pden' as table_name, 'source' as column_name
union all
    select 'l_pden' as table_name, 'area_id' as column_name
union all
    select 'l_pden' as table_name, 'area_type' as column_name
union all
    select 'l_pden' as table_name, 'country' as column_name
union all
    select 'l_pden' as table_name, 'current_operator' as column_name
union all
    select 'l_pden' as table_name, 'current_status_date' as column_name
union all
    select 'l_pden' as table_name, 'data_source' as column_name
union all
    select 'l_pden' as table_name, 'facility_id' as column_name
union all
    select 'l_pden' as table_name, 'facility_type' as column_name
union all
    select 'l_pden' as table_name, 'field_id' as column_name
union all
    select 'l_pden' as table_name, 'geologic_province' as column_name
union all
    select 'l_pden' as table_name, 'last_injection_date' as column_name
union all
    select 'l_pden' as table_name, 'last_production_date' as column_name
union all
    select 'l_pden' as table_name, 'last_reported_date' as column_name
union all
    select 'l_pden' as table_name, 'on_injection_date' as column_name
union all
    select 'l_pden' as table_name, 'on_production_date' as column_name
union all
    select 'l_pden' as table_name, 'other_name' as column_name
union all
    select 'l_pden' as table_name, 'pden_name' as column_name
union all
    select 'l_pden' as table_name, 'pool_id' as column_name
union all
    select 'l_pden' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_pden' as table_name, 'primary_product' as column_name
union all
    select 'l_pden' as table_name, 'production_method' as column_name
union all
    select 'l_pden' as table_name, 'province_state' as column_name
union all
    select 'l_pden' as table_name, 'pr_str_form_obs_no' as column_name
union all
    select 'l_pden' as table_name, 'remark' as column_name
union all
    select 'l_pden' as table_name, 'resent_id' as column_name
union all
    select 'l_pden' as table_name, 'reserve_class_id' as column_name
union all
    select 'l_pden' as table_name, 'string_id' as column_name
union all
    select 'l_pden' as table_name, 'string_source' as column_name
union all
    select 'l_pden' as table_name, 'uwi' as column_name
union all
    select 'l_pden_strat_unit' as table_name, 'pden_id' as column_name
union all
    select 'l_pden_strat_unit' as table_name, 'pden_type' as column_name
union all
    select 'l_pden_strat_unit' as table_name, 'pden_source' as column_name
union all
    select 'l_pden_strat_unit' as table_name, 'strat_name_set_id' as column_name
union all
    select 'l_pden_strat_unit' as table_name, 'strat_unit_id' as column_name
union all
    select 'l_pden_strat_unit' as table_name, 'pden_su_obs_no' as column_name
union all
    select 'l_pden_strat_unit' as table_name, 'data_source' as column_name
union all
    select 'l_pden_strat_unit' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_pden_strat_unit' as table_name, 'remark' as column_name
union all
    select 'l_pden_vol_summary' as table_name, 'pden_id' as column_name
union all
    select 'l_pden_vol_summary' as table_name, 'pden_type' as column_name
union all
    select 'l_pden_vol_summary' as table_name, 'pden_source' as column_name
union all
    select 'l_pden_vol_summary' as table_name, 'volume_method' as column_name
union all
    select 'l_pden_vol_summary' as table_name, 'activity_type' as column_name
union all
    select 'l_pden_vol_summary' as table_name, 'volume_date' as column_name
union all
    select 'l_pden_vol_summary' as table_name, 'boe_cum_volume' as column_name
union all
    select 'l_pden_vol_summary' as table_name, 'boe_volume_uom' as column_name
union all
    select 'l_pden_vol_summary' as table_name, 'co2_cum_volume' as column_name
union all
    select 'l_pden_vol_summary' as table_name, 'co2_volume_uom' as column_name
union all
    select 'l_pden_vol_summary' as table_name, 'data_source' as column_name
union all
    select 'l_pden_vol_summary' as table_name, 'gas_cum_volume' as column_name
union all
    select 'l_pden_vol_summary' as table_name, 'gas_volume_uom' as column_name
union all
    select 'l_pden_vol_summary' as table_name, 'injection_cum_volume' as column_name
union all
    select 'l_pden_vol_summary' as table_name, 'injection_volume_uom' as column_name
union all
    select 'l_pden_vol_summary' as table_name, 'ngl_cum_volume' as column_name
union all
    select 'l_pden_vol_summary' as table_name, 'ngl_volume_uom' as column_name
union all
    select 'l_pden_vol_summary' as table_name, 'nitrogen_cum_volume' as column_name
union all
    select 'l_pden_vol_summary' as table_name, 'nitrogen_volume_uom' as column_name
union all
    select 'l_pden_vol_summary' as table_name, 'oil_cum_volume' as column_name
union all
    select 'l_pden_vol_summary' as table_name, 'oil_volume_uom' as column_name
union all
    select 'l_pden_vol_summary' as table_name, 'period_on_injection' as column_name
union all
    select 'l_pden_vol_summary' as table_name, 'period_on_injection_uom' as column_name
union all
    select 'l_pden_vol_summary' as table_name, 'period_on_production' as column_name
union all
    select 'l_pden_vol_summary' as table_name, 'period_on_production_uom' as column_name
union all
    select 'l_pden_vol_summary' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_pden_vol_summary' as table_name, 'primary_product' as column_name
union all
    select 'l_pden_vol_summary' as table_name, 'project_id' as column_name
union all
    select 'l_pden_vol_summary' as table_name, 'remark' as column_name
union all
    select 'l_pden_vol_summary' as table_name, 'sulphur_cum_volume' as column_name
union all
    select 'l_pden_vol_summary' as table_name, 'sulphur_volume_uom' as column_name
union all
    select 'l_pden_vol_summary' as table_name, 'water_cum_volume' as column_name
union all
    select 'l_pden_vol_summary' as table_name, 'water_volume_uom' as column_name
union all
    select 'l_pden_xref' as table_name, 'from_pden_id' as column_name
union all
    select 'l_pden_xref' as table_name, 'from_pden_type' as column_name
union all
    select 'l_pden_xref' as table_name, 'to_pden_id' as column_name
union all
    select 'l_pden_xref' as table_name, 'to_pden_type' as column_name
union all
    select 'l_pden_xref' as table_name, 'pden_source' as column_name
union all
    select 'l_pden_xref' as table_name, 'xref_obs_no' as column_name
union all
    select 'l_pden_xref' as table_name, 'data_source' as column_name
union all
    select 'l_pden_xref' as table_name, 'pden_xref_type' as column_name
union all
    select 'l_pden_xref' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_pden_xref' as table_name, 'remark' as column_name
union all
    select 'l_pool' as table_name, 'pool_id' as column_name
union all
    select 'l_pool' as table_name, 'business_associate' as column_name
union all
    select 'l_pool' as table_name, 'country' as column_name
union all
    select 'l_pool' as table_name, 'data_source' as column_name
union all
    select 'l_pool' as table_name, 'field_id' as column_name
union all
    select 'l_pool' as table_name, 'pool_name' as column_name
union all
    select 'l_pool' as table_name, 'pool_status' as column_name
union all
    select 'l_pool' as table_name, 'pool_type' as column_name
union all
    select 'l_pool' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_pool' as table_name, 'province_state' as column_name
union all
    select 'l_pool' as table_name, 'remark' as column_name
union all
    select 'l_pool' as table_name, 'strat_name_set_id' as column_name
union all
    select 'l_pool' as table_name, 'strat_unit_id' as column_name
union all
    select 'l_pool_alias' as table_name, 'pool_id' as column_name
union all
    select 'l_pool_alias' as table_name, 'source' as column_name
union all
    select 'l_pool_alias' as table_name, 'pool_alias_id' as column_name
union all
    select 'l_pool_alias' as table_name, 'alias_owner_ba_id' as column_name
union all
    select 'l_pool_alias' as table_name, 'alias_type' as column_name
union all
    select 'l_pool_alias' as table_name, 'data_source' as column_name
union all
    select 'l_pool_alias' as table_name, 'pool_alias' as column_name
union all
    select 'l_pool_alias' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_pool_alias' as table_name, 'preferred_ind' as column_name
union all
    select 'l_pool_alias' as table_name, 'remark' as column_name
union all
    select 'l_ppdm_column' as table_name, 'table_name' as column_name
union all
    select 'l_ppdm_column' as table_name, 'column_name' as column_name
union all
    select 'l_ppdm_column' as table_name, 'column_comment' as column_name
union all
    select 'l_ppdm_column' as table_name, 'column_sequence' as column_name
union all
    select 'l_ppdm_column' as table_name, 'data_source' as column_name
union all
    select 'l_ppdm_column' as table_name, 'data_type' as column_name
union all
    select 'l_ppdm_column' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_ppdm_column' as table_name, 'primary_key_sequence' as column_name
union all
    select 'l_ppdm_column' as table_name, 'remark' as column_name
union all
    select 'l_ppdm_data_source' as table_name, 'data_source' as column_name
union all
    select 'l_ppdm_data_source' as table_name, 'database_name' as column_name
union all
    select 'l_ppdm_data_source' as table_name, 'effective_date' as column_name
union all
    select 'l_ppdm_data_source' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_ppdm_data_source' as table_name, 'remark' as column_name
union all
    select 'l_ppdm_data_source' as table_name, 'user_name' as column_name
union all
    select 'l_ppdm_exception' as table_name, 'exception_id' as column_name
union all
    select 'l_ppdm_exception' as table_name, 'data_source' as column_name
union all
    select 'l_ppdm_exception' as table_name, 'error_message' as column_name
union all
    select 'l_ppdm_exception' as table_name, 'error_no' as column_name
union all
    select 'l_ppdm_exception' as table_name, 'exception_column_name' as column_name
union all
    select 'l_ppdm_exception' as table_name, 'exception_date' as column_name
union all
    select 'l_ppdm_exception' as table_name, 'exception_table_name' as column_name
union all
    select 'l_ppdm_exception' as table_name, 'exception_type' as column_name
union all
    select 'l_ppdm_exception' as table_name, 'plsql_name' as column_name
union all
    select 'l_ppdm_exception' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_ppdm_exception' as table_name, 'remark' as column_name
union all
    select 'l_ppdm_origin' as table_name, 'source_table_name' as column_name
union all
    select 'l_ppdm_origin' as table_name, 'source_ppdm_guid' as column_name
union all
    select 'l_ppdm_origin' as table_name, 'target_table_name' as column_name
union all
    select 'l_ppdm_origin' as table_name, 'target_ppdm_guid' as column_name
union all
    select 'l_ppdm_origin' as table_name, 'data_source' as column_name
union all
    select 'l_ppdm_origin' as table_name, 'business_rule' as column_name
union all
    select 'l_ppdm_origin' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_ppdm_origin' as table_name, 'remark' as column_name
union all
    select 'l_ppdm_origin' as table_name, 'source_column_name' as column_name
union all
    select 'l_ppdm_origin' as table_name, 'target_column_name' as column_name
union all
    select 'l_ppdm_table' as table_name, 'table_name' as column_name
union all
    select 'l_ppdm_table' as table_name, 'data_source' as column_name
union all
    select 'l_ppdm_table' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_ppdm_table' as table_name, 'primary_key_name' as column_name
union all
    select 'l_ppdm_table' as table_name, 'remark' as column_name
union all
    select 'l_ppdm_table' as table_name, 'table_comment' as column_name
union all
    select 'l_project' as table_name, 'project_id' as column_name
union all
    select 'l_project' as table_name, 'complete_date' as column_name
union all
    select 'l_project' as table_name, 'data_source' as column_name
union all
    select 'l_project' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_project' as table_name, 'project_name' as column_name
union all
    select 'l_project' as table_name, 'project_type' as column_name
union all
    select 'l_project' as table_name, 'remark' as column_name
union all
    select 'l_project' as table_name, 'start_date' as column_name
union all
    select 'l_project' as table_name, 'status' as column_name
union all
    select 'l_project_alias' as table_name, 'project_id' as column_name
union all
    select 'l_project_alias' as table_name, 'alias_id' as column_name
union all
    select 'l_project_alias' as table_name, 'alias_name' as column_name
union all
    select 'l_project_alias' as table_name, 'alias_type' as column_name
union all
    select 'l_project_alias' as table_name, 'data_source' as column_name
union all
    select 'l_project_alias' as table_name, 'owner_ba_id' as column_name
union all
    select 'l_project_alias' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_project_alias' as table_name, 'preferred_ind' as column_name
union all
    select 'l_project_alias' as table_name, 'remark' as column_name
union all
    select 'l_project_component' as table_name, 'project_id' as column_name
union all
    select 'l_project_component' as table_name, 'area_id' as column_name
union all
    select 'l_project_component' as table_name, 'area_type' as column_name
union all
    select 'l_project_component' as table_name, 'ba_id' as column_name
union all
    select 'l_project_component' as table_name, 'component_type' as column_name
union all
    select 'l_project_component' as table_name, 'contract_id' as column_name
union all
    select 'l_project_component' as table_name, 'data_source' as column_name
union all
    select 'l_project_component' as table_name, 'facility_id' as column_name
union all
    select 'l_project_component' as table_name, 'facility_type' as column_name
union all
    select 'l_project_component' as table_name, 'field_id' as column_name
union all
    select 'l_project_component' as table_name, 'jurisdiction' as column_name
union all
    select 'l_project_component' as table_name, 'land_right_id' as column_name
union all
    select 'l_project_component' as table_name, 'land_right_type' as column_name
union all
    select 'l_project_component' as table_name, 'land_sale_number' as column_name
union all
    select 'l_project_component' as table_name, 'license_id' as column_name
union all
    select 'l_project_component' as table_name, 'license_table' as column_name
union all
    select 'l_project_component' as table_name, 'pden_id' as column_name
union all
    select 'l_project_component' as table_name, 'pden_source' as column_name
union all
    select 'l_project_component' as table_name, 'pden_type' as column_name
union all
    select 'l_project_component' as table_name, 'pool_id' as column_name
union all
    select 'l_project_component' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_project_component' as table_name, 'resent_id' as column_name
union all
    select 'l_project_component' as table_name, 'reserve_class_id' as column_name
union all
    select 'l_project_component' as table_name, 'seis_set_id' as column_name
union all
    select 'l_project_component' as table_name, 'seis_set_type' as column_name
union all
    select 'l_project_component' as table_name, 'strat_name_set_id' as column_name
union all
    select 'l_project_component' as table_name, 'support_facility_id' as column_name
union all
    select 'l_project_component' as table_name, 'support_facility_type' as column_name
union all
    select 'l_project_component' as table_name, 'uwi' as column_name
union all
    select 'l_resent_class' as table_name, 'resent_id' as column_name
union all
    select 'l_resent_class' as table_name, 'reserve_class_id' as column_name
union all
    select 'l_resent_class' as table_name, 'confidence_factor' as column_name
union all
    select 'l_resent_class' as table_name, 'data_source' as column_name
union all
    select 'l_resent_class' as table_name, 'effective_date' as column_name
union all
    select 'l_resent_class' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_resent_class' as table_name, 'remark' as column_name
union all
    select 'l_resent_component' as table_name, 'resent_id' as column_name
union all
    select 'l_resent_component' as table_name, 'component_id' as column_name
union all
    select 'l_resent_component' as table_name, 'area_id' as column_name
union all
    select 'l_resent_component' as table_name, 'area_type' as column_name
union all
    select 'l_resent_component' as table_name, 'business_associate' as column_name
union all
    select 'l_resent_component' as table_name, 'contract_id' as column_name
union all
    select 'l_resent_component' as table_name, 'contribution_percent' as column_name
union all
    select 'l_resent_component' as table_name, 'data_source' as column_name
union all
    select 'l_resent_component' as table_name, 'facility_id' as column_name
union all
    select 'l_resent_component' as table_name, 'facility_type' as column_name
union all
    select 'l_resent_component' as table_name, 'field_id' as column_name
union all
    select 'l_resent_component' as table_name, 'land_right_id' as column_name
union all
    select 'l_resent_component' as table_name, 'land_right_type' as column_name
union all
    select 'l_resent_component' as table_name, 'pden_id' as column_name
union all
    select 'l_resent_component' as table_name, 'pden_source' as column_name
union all
    select 'l_resent_component' as table_name, 'pden_type' as column_name
union all
    select 'l_resent_component' as table_name, 'pool_id' as column_name
union all
    select 'l_resent_component' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_resent_component' as table_name, 'product_type' as column_name
union all
    select 'l_resent_component' as table_name, 'project_id' as column_name
union all
    select 'l_resent_component' as table_name, 'remark' as column_name
union all
    select 'l_resent_component' as table_name, 'strat_name_set_id' as column_name
union all
    select 'l_resent_component' as table_name, 'strat_unit_id' as column_name
union all
    select 'l_resent_component' as table_name, 'uwi' as column_name
union all
    select 'l_resent_xref' as table_name, 'resent_id' as column_name
union all
    select 'l_resent_xref' as table_name, 'resent_id2' as column_name
union all
    select 'l_resent_xref' as table_name, 'xref_obs_no' as column_name
union all
    select 'l_resent_xref' as table_name, 'data_source' as column_name
union all
    select 'l_resent_xref' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_resent_xref' as table_name, 'remark' as column_name
union all
    select 'l_resent_xref' as table_name, 'xref_type' as column_name
union all
    select 'l_reserve_entity' as table_name, 'resent_id' as column_name
union all
    select 'l_reserve_entity' as table_name, 'created_by_ba_id' as column_name
union all
    select 'l_reserve_entity' as table_name, 'data_source' as column_name
union all
    select 'l_reserve_entity' as table_name, 'group_type' as column_name
union all
    select 'l_reserve_entity' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_reserve_entity' as table_name, 'primary_product_type' as column_name
union all
    select 'l_reserve_entity' as table_name, 'remark' as column_name
union all
    select 'l_reserve_entity' as table_name, 'update_schedule' as column_name
union all
    select 'l_rm_info_item_content' as table_name, 'information_item_id' as column_name
union all
    select 'l_rm_info_item_content' as table_name, 'info_item_type' as column_name
union all
    select 'l_rm_info_item_content' as table_name, 'content_obs_no' as column_name
union all
    select 'l_rm_info_item_content' as table_name, 'application_id' as column_name
union all
    select 'l_rm_info_item_content' as table_name, 'business_associate' as column_name
union all
    select 'l_rm_info_item_content' as table_name, 'contract_id' as column_name
union all
    select 'l_rm_info_item_content' as table_name, 'data_source' as column_name
union all
    select 'l_rm_info_item_content' as table_name, 'facility_id' as column_name
union all
    select 'l_rm_info_item_content' as table_name, 'facility_type' as column_name
union all
    select 'l_rm_info_item_content' as table_name, 'field_id' as column_name
union all
    select 'l_rm_info_item_content' as table_name, 'jurisdiction' as column_name
union all
    select 'l_rm_info_item_content' as table_name, 'land_right_id' as column_name
union all
    select 'l_rm_info_item_content' as table_name, 'land_right_type' as column_name
union all
    select 'l_rm_info_item_content' as table_name, 'land_sale_number' as column_name
union all
    select 'l_rm_info_item_content' as table_name, 'land_sale_offering_id' as column_name
union all
    select 'l_rm_info_item_content' as table_name, 'license_id' as column_name
union all
    select 'l_rm_info_item_content' as table_name, 'license_table' as column_name
union all
    select 'l_rm_info_item_content' as table_name, 'pden_id' as column_name
union all
    select 'l_rm_info_item_content' as table_name, 'pden_source' as column_name
union all
    select 'l_rm_info_item_content' as table_name, 'pden_type' as column_name
union all
    select 'l_rm_info_item_content' as table_name, 'pool_id' as column_name
union all
    select 'l_rm_info_item_content' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_rm_info_item_content' as table_name, 'remark' as column_name
union all
    select 'l_rm_info_item_content' as table_name, 'resent_id' as column_name
union all
    select 'l_rm_info_item_content' as table_name, 'reserve_class_id' as column_name
union all
    select 'l_rm_info_item_content' as table_name, 'seis_set_id' as column_name
union all
    select 'l_rm_info_item_content' as table_name, 'seis_set_type' as column_name
union all
    select 'l_rm_info_item_content' as table_name, 'strat_name_set_id' as column_name
union all
    select 'l_rm_info_item_content' as table_name, 'strat_unit_id' as column_name
union all
    select 'l_rm_info_item_content' as table_name, 'support_facility_id' as column_name
union all
    select 'l_rm_info_item_content' as table_name, 'support_facility_type' as column_name
union all
    select 'l_rm_info_item_content' as table_name, 'uwi' as column_name
union all
    select 'l_rm_info_item_desc' as table_name, 'information_item_id' as column_name
union all
    select 'l_rm_info_item_desc' as table_name, 'info_item_type' as column_name
union all
    select 'l_rm_info_item_desc' as table_name, 'description_id' as column_name
union all
    select 'l_rm_info_item_desc' as table_name, 'data_source' as column_name
union all
    select 'l_rm_info_item_desc' as table_name, 'description' as column_name
union all
    select 'l_rm_info_item_desc' as table_name, 'description_date' as column_name
union all
    select 'l_rm_info_item_desc' as table_name, 'description_type' as column_name
union all
    select 'l_rm_info_item_desc' as table_name, 'desc_value' as column_name
union all
    select 'l_rm_info_item_desc' as table_name, 'desc_value_uom' as column_name
union all
    select 'l_rm_info_item_desc' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_rm_info_item_desc' as table_name, 'remark' as column_name
union all
    select 'l_rm_information_item' as table_name, 'information_item_id' as column_name
union all
    select 'l_rm_information_item' as table_name, 'info_item_type' as column_name
union all
    select 'l_rm_information_item' as table_name, 'catalogue_date' as column_name
union all
    select 'l_rm_information_item' as table_name, 'catalogue_name' as column_name
union all
    select 'l_rm_information_item' as table_name, 'data_source' as column_name
union all
    select 'l_rm_information_item' as table_name, 'information_quality' as column_name
union all
    select 'l_rm_information_item' as table_name, 'item_category' as column_name
union all
    select 'l_rm_information_item' as table_name, 'item_sub_category' as column_name
union all
    select 'l_rm_information_item' as table_name, 'media_type' as column_name
union all
    select 'l_rm_information_item' as table_name, 'origin_date' as column_name
union all
    select 'l_rm_information_item' as table_name, 'physical_item_id' as column_name
union all
    select 'l_rm_information_item' as table_name, 'physical_item_status' as column_name
union all
    select 'l_rm_information_item' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_rm_information_item' as table_name, 'reference_num' as column_name
union all
    select 'l_rm_information_item' as table_name, 'remark' as column_name
union all
    select 'l_rm_information_item' as table_name, 'retention_period' as column_name
union all
    select 'l_rm_information_item' as table_name, 'store_id' as column_name
union all
    select 'l_rm_information_item' as table_name, 'title' as column_name
union all
    select 'l_seis_alias' as table_name, 'seis_set_id' as column_name
union all
    select 'l_seis_alias' as table_name, 'seis_set_type' as column_name
union all
    select 'l_seis_alias' as table_name, 'seis_alias_id' as column_name
union all
    select 'l_seis_alias' as table_name, 'alias_owner' as column_name
union all
    select 'l_seis_alias' as table_name, 'data_source' as column_name
union all
    select 'l_seis_alias' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_seis_alias' as table_name, 'preferred_ind' as column_name
union all
    select 'l_seis_alias' as table_name, 'remark' as column_name
union all
    select 'l_seis_alias' as table_name, 'seis_set_alias' as column_name
union all
    select 'l_seis_point' as table_name, 'seis_set_id' as column_name
union all
    select 'l_seis_point' as table_name, 'seis_set_type' as column_name
union all
    select 'l_seis_point' as table_name, 'seis_point_id' as column_name
union all
    select 'l_seis_point' as table_name, 'data_source' as column_name
union all
    select 'l_seis_point' as table_name, 'datum_elev' as column_name
union all
    select 'l_seis_point' as table_name, 'datum_elev_uom' as column_name
union all
    select 'l_seis_point' as table_name, 'elev' as column_name
union all
    select 'l_seis_point' as table_name, 'elev_ouom' as column_name
union all
    select 'l_seis_point' as table_name, 'end_bend_ind' as column_name
union all
    select 'l_seis_point' as table_name, 'measured_depth' as column_name
union all
    select 'l_seis_point' as table_name, 'measured_depth_uom' as column_name
union all
    select 'l_seis_point' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_seis_point' as table_name, 'reference_datum' as column_name
union all
    select 'l_seis_point' as table_name, 'remark' as column_name
union all
    select 'l_seis_point' as table_name, 'seis_point_label' as column_name
union all
    select 'l_seis_point' as table_name, 'seis_point_lat' as column_name
union all
    select 'l_seis_point' as table_name, 'seis_point_long' as column_name
union all
    select 'l_seis_point' as table_name, 'seis_point_no' as column_name
union all
    select 'l_seis_point' as table_name, 'seis_station_type' as column_name
union all
    select 'l_seis_point' as table_name, 'spatial_seq_no' as column_name
union all
    select 'l_seis_record' as table_name, 'seis_set_id' as column_name
union all
    select 'l_seis_record' as table_name, 'seis_set_type' as column_name
union all
    select 'l_seis_record' as table_name, 'record_id' as column_name
union all
    select 'l_seis_record' as table_name, 'data_source' as column_name
union all
    select 'l_seis_record' as table_name, 'field_file_number' as column_name
union all
    select 'l_seis_record' as table_name, 'information_item_id' as column_name
union all
    select 'l_seis_record' as table_name, 'info_item_type' as column_name
union all
    select 'l_seis_record' as table_name, 'patch_used_ind' as column_name
union all
    select 'l_seis_record' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_seis_record' as table_name, 'recording_remarks' as column_name
union all
    select 'l_seis_record' as table_name, 'record_number' as column_name
union all
    select 'l_seis_record' as table_name, 'record_quality' as column_name
union all
    select 'l_seis_record' as table_name, 'record_type' as column_name
union all
    select 'l_seis_record' as table_name, 'remark' as column_name
union all
    select 'l_seis_record' as table_name, 'seis_shot_point_id' as column_name
union all
    select 'l_seis_set' as table_name, 'seis_set_id' as column_name
union all
    select 'l_seis_set' as table_name, 'seis_set_type' as column_name
union all
    select 'l_seis_set' as table_name, 'acqtn_survey_name' as column_name
union all
    select 'l_seis_set' as table_name, 'completed_date' as column_name
union all
    select 'l_seis_set' as table_name, 'coord_acquisition_id' as column_name
union all
    select 'l_seis_set' as table_name, 'country' as column_name
union all
    select 'l_seis_set' as table_name, 'current_seis_status' as column_name
union all
    select 'l_seis_set' as table_name, 'data_source' as column_name
union all
    select 'l_seis_set' as table_name, 'finance_id' as column_name
union all
    select 'l_seis_set' as table_name, 'first_seis_point_id' as column_name
union all
    select 'l_seis_set' as table_name, 'first_seis_set_id' as column_name
union all
    select 'l_seis_set' as table_name, 'first_seis_set_type' as column_name
union all
    select 'l_seis_set' as table_name, 'jurisdiction' as column_name
union all
    select 'l_seis_set' as table_name, 'last_seis_point_id' as column_name
union all
    select 'l_seis_set' as table_name, 'last_seis_set_id' as column_name
union all
    select 'l_seis_set' as table_name, 'last_seis_set_type' as column_name
union all
    select 'l_seis_set' as table_name, 'line_length' as column_name
union all
    select 'l_seis_set' as table_name, 'line_length_uom' as column_name
union all
    select 'l_seis_set' as table_name, 'line_name' as column_name
union all
    select 'l_seis_set' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_seis_set' as table_name, 'province_state' as column_name
union all
    select 'l_seis_set' as table_name, 'refraction_reflection' as column_name
union all
    select 'l_seis_set' as table_name, 'reshoot_of_seis_set_type' as column_name
union all
    select 'l_seis_set' as table_name, 'reshoot_of_set_id' as column_name
union all
    select 'l_seis_set' as table_name, 'seis_3d_type' as column_name
union all
    select 'l_seis_set' as table_name, 'seis_dimension' as column_name
union all
    select 'l_seis_set' as table_name, 'seis_spectrum_type' as column_name
union all
    select 'l_seis_set' as table_name, 'seis_station_type' as column_name
union all
    select 'l_seis_set' as table_name, 'shot_for' as column_name
union all
    select 'l_seis_set' as table_name, 'start_date' as column_name
union all
    select 'l_seis_set' as table_name, 'status_type' as column_name
union all
    select 'l_seis_set' as table_name, 'test_experimental' as column_name
union all
    select 'l_sf_alias' as table_name, 'support_facility_id' as column_name
union all
    select 'l_sf_alias' as table_name, 'sf_type' as column_name
union all
    select 'l_sf_alias' as table_name, 'alias_id' as column_name
union all
    select 'l_sf_alias' as table_name, 'alias' as column_name
union all
    select 'l_sf_alias' as table_name, 'alias_type' as column_name
union all
    select 'l_sf_alias' as table_name, 'data_source' as column_name
union all
    select 'l_sf_alias' as table_name, 'owner_ba_id' as column_name
union all
    select 'l_sf_alias' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_sf_alias' as table_name, 'preferred_ind' as column_name
union all
    select 'l_sf_alias' as table_name, 'remark' as column_name
union all
    select 'l_sf_component' as table_name, 'support_facility_id' as column_name
union all
    select 'l_sf_component' as table_name, 'sf_type' as column_name
union all
    select 'l_sf_component' as table_name, 'use_id' as column_name
union all
    select 'l_sf_component' as table_name, 'area_id' as column_name
union all
    select 'l_sf_component' as table_name, 'area_type' as column_name
union all
    select 'l_sf_component' as table_name, 'business_associate' as column_name
union all
    select 'l_sf_component' as table_name, 'contract_id' as column_name
union all
    select 'l_sf_component' as table_name, 'data_source' as column_name
union all
    select 'l_sf_component' as table_name, 'facility_id' as column_name
union all
    select 'l_sf_component' as table_name, 'facility_type' as column_name
union all
    select 'l_sf_component' as table_name, 'field_id' as column_name
union all
    select 'l_sf_component' as table_name, 'finance_id' as column_name
union all
    select 'l_sf_component' as table_name, 'information_item_id' as column_name
union all
    select 'l_sf_component' as table_name, 'info_item_type' as column_name
union all
    select 'l_sf_component' as table_name, 'interest_set_id' as column_name
union all
    select 'l_sf_component' as table_name, 'land_right_id' as column_name
union all
    select 'l_sf_component' as table_name, 'land_right_type' as column_name
union all
    select 'l_sf_component' as table_name, 'land_sale_jurisdiction' as column_name
union all
    select 'l_sf_component' as table_name, 'land_sale_number' as column_name
union all
    select 'l_sf_component' as table_name, 'pden_id' as column_name
union all
    select 'l_sf_component' as table_name, 'pden_source' as column_name
union all
    select 'l_sf_component' as table_name, 'pden_type' as column_name
union all
    select 'l_sf_component' as table_name, 'pool_id' as column_name
union all
    select 'l_sf_component' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_sf_component' as table_name, 'project_id' as column_name
union all
    select 'l_sf_component' as table_name, 'remark' as column_name
union all
    select 'l_sf_component' as table_name, 'seis_set_id' as column_name
union all
    select 'l_sf_component' as table_name, 'seis_set_type' as column_name
union all
    select 'l_sf_component' as table_name, 'uwi' as column_name
union all
    select 'l_sf_description' as table_name, 'support_facility_id' as column_name
union all
    select 'l_sf_description' as table_name, 'sf_type' as column_name
union all
    select 'l_sf_description' as table_name, 'description_obs_no' as column_name
union all
    select 'l_sf_description' as table_name, 'data_source' as column_name
union all
    select 'l_sf_description' as table_name, 'description' as column_name
union all
    select 'l_sf_description' as table_name, 'desc_type' as column_name
union all
    select 'l_sf_description' as table_name, 'desc_value' as column_name
union all
    select 'l_sf_description' as table_name, 'desc_value_code' as column_name
union all
    select 'l_sf_description' as table_name, 'desc_value_uom' as column_name
union all
    select 'l_sf_description' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_sf_support_facility' as table_name, 'support_facility_id' as column_name
union all
    select 'l_sf_support_facility' as table_name, 'sf_type' as column_name
union all
    select 'l_sf_support_facility' as table_name, 'data_source' as column_name
union all
    select 'l_sf_support_facility' as table_name, 'facility_status' as column_name
union all
    select 'l_sf_support_facility' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_sf_support_facility' as table_name, 'remark' as column_name
union all
    select 'l_sf_support_facility' as table_name, 'status_type' as column_name
union all
    select 'l_sf_xref' as table_name, 'support_facility_id' as column_name
union all
    select 'l_sf_xref' as table_name, 'sf_type' as column_name
union all
    select 'l_sf_xref' as table_name, 'support_facility_id2' as column_name
union all
    select 'l_sf_xref' as table_name, 'sf_type2' as column_name
union all
    select 'l_sf_xref' as table_name, 'data_source' as column_name
union all
    select 'l_sf_xref' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_sf_xref' as table_name, 'remark' as column_name
union all
    select 'l_sf_xref' as table_name, 'xref_type' as column_name
union all
    select 'l_sp_boundary' as table_name, 'polygon_id' as column_name
union all
    select 'l_sp_boundary' as table_name, 'point_seq_no' as column_name
union all
    select 'l_sp_boundary' as table_name, 'data_source' as column_name
union all
    select 'l_sp_boundary' as table_name, 'latitude' as column_name
union all
    select 'l_sp_boundary' as table_name, 'longitude' as column_name
union all
    select 'l_sp_boundary' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_sp_boundary' as table_name, 'remark' as column_name
union all
    select 'l_sp_component' as table_name, 'spatial_description_id' as column_name
union all
    select 'l_sp_component' as table_name, 'spatial_obs_no' as column_name
union all
    select 'l_sp_component' as table_name, 'component_id' as column_name
union all
    select 'l_sp_component' as table_name, 'application_id' as column_name
union all
    select 'l_sp_component' as table_name, 'area_id' as column_name
union all
    select 'l_sp_component' as table_name, 'area_type' as column_name
union all
    select 'l_sp_component' as table_name, 'data_source' as column_name
union all
    select 'l_sp_component' as table_name, 'facility_id' as column_name
union all
    select 'l_sp_component' as table_name, 'facility_type' as column_name
union all
    select 'l_sp_component' as table_name, 'field_id' as column_name
union all
    select 'l_sp_component' as table_name, 'interest_set_id' as column_name
union all
    select 'l_sp_component' as table_name, 'jurisdiction' as column_name
union all
    select 'l_sp_component' as table_name, 'land_right_id' as column_name
union all
    select 'l_sp_component' as table_name, 'land_right_type' as column_name
union all
    select 'l_sp_component' as table_name, 'land_sale_number' as column_name
union all
    select 'l_sp_component' as table_name, 'land_sale_offering_id' as column_name
union all
    select 'l_sp_component' as table_name, 'license_id' as column_name
union all
    select 'l_sp_component' as table_name, 'license_table' as column_name
union all
    select 'l_sp_component' as table_name, 'pden_id' as column_name
union all
    select 'l_sp_component' as table_name, 'pden_source' as column_name
union all
    select 'l_sp_component' as table_name, 'pden_type' as column_name
union all
    select 'l_sp_component' as table_name, 'pool_id' as column_name
union all
    select 'l_sp_component' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_sp_component' as table_name, 'remark' as column_name
union all
    select 'l_sp_component' as table_name, 'resent_id' as column_name
union all
    select 'l_sp_component' as table_name, 'seis_set_id' as column_name
union all
    select 'l_sp_component' as table_name, 'seis_set_type' as column_name
union all
    select 'l_sp_component' as table_name, 'support_facility_id' as column_name
union all
    select 'l_sp_component' as table_name, 'support_facility_type' as column_name
union all
    select 'l_sp_component' as table_name, 'uwi' as column_name
union all
    select 'l_sp_geometry' as table_name, 'spatial_obs_no' as column_name
union all
    select 'l_sp_geometry' as table_name, 'spatial_description_id' as column_name
union all
    select 'l_sp_geometry' as table_name, 'geometry_format' as column_name
union all
    select 'l_sp_geometry' as table_name, 'geometry_id' as column_name
union all
    select 'l_sp_geometry' as table_name, 'geometry_obs_no' as column_name
union all
    select 'l_sp_geometry' as table_name, 'data_source' as column_name
union all
    select 'l_sp_geometry' as table_name, 'geometry_date' as column_name
union all
    select 'l_sp_geometry' as table_name, 'geometry_source' as column_name
union all
    select 'l_sp_geometry' as table_name, 'geometry_type' as column_name
union all
    select 'l_sp_geometry' as table_name, 'object_source' as column_name
union all
    select 'l_sp_geometry' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_sp_geometry' as table_name, 'remark' as column_name
union all
    select 'l_sp_line' as table_name, 'line_id' as column_name
union all
    select 'l_sp_line' as table_name, 'data_source' as column_name
union all
    select 'l_sp_line' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_sp_line' as table_name, 'remark' as column_name
union all
    select 'l_sp_line' as table_name, 'spatial_description_id' as column_name
union all
    select 'l_sp_line' as table_name, 'spatial_obs_no' as column_name
union all
    select 'l_sp_line_point' as table_name, 'line_id' as column_name
union all
    select 'l_sp_line_point' as table_name, 'point_seq_no' as column_name
union all
    select 'l_sp_line_point' as table_name, 'bend_ind' as column_name
union all
    select 'l_sp_line_point' as table_name, 'data_source' as column_name
union all
    select 'l_sp_line_point' as table_name, 'depth' as column_name
union all
    select 'l_sp_line_point' as table_name, 'elevation' as column_name
union all
    select 'l_sp_line_point' as table_name, 'first_point_ind' as column_name
union all
    select 'l_sp_line_point' as table_name, 'last_point_ind' as column_name
union all
    select 'l_sp_line_point' as table_name, 'latitude' as column_name
union all
    select 'l_sp_line_point' as table_name, 'longitude' as column_name
union all
    select 'l_sp_line_point' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_sp_line_point' as table_name, 'remark' as column_name
union all
    select 'l_sp_mineral_zone' as table_name, 'spatial_description_id' as column_name
union all
    select 'l_sp_mineral_zone' as table_name, 'spatial_obs_no' as column_name
union all
    select 'l_sp_mineral_zone' as table_name, 'mineral_zone_id' as column_name
union all
    select 'l_sp_mineral_zone' as table_name, 'data_source' as column_name
union all
    select 'l_sp_mineral_zone' as table_name, 'deep_right_reversion_ind' as column_name
union all
    select 'l_sp_mineral_zone' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_sp_mineral_zone' as table_name, 'remark' as column_name
union all
    select 'l_sp_mineral_zone' as table_name, 'zone_definition_id' as column_name
union all
    select 'l_sp_point' as table_name, 'point_id' as column_name
union all
    select 'l_sp_point' as table_name, 'data_source' as column_name
union all
    select 'l_sp_point' as table_name, 'latitude' as column_name
union all
    select 'l_sp_point' as table_name, 'longitude' as column_name
union all
    select 'l_sp_point' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_sp_point' as table_name, 'remark' as column_name
union all
    select 'l_sp_point' as table_name, 'spatial_description_id' as column_name
union all
    select 'l_sp_point' as table_name, 'spatial_obs_no' as column_name
union all
    select 'l_sp_polygon' as table_name, 'polygon_id' as column_name
union all
    select 'l_sp_polygon' as table_name, 'boundary_direction' as column_name
union all
    select 'l_sp_polygon' as table_name, 'contained_by_polygon_id' as column_name
union all
    select 'l_sp_polygon' as table_name, 'data_source' as column_name
union all
    select 'l_sp_polygon' as table_name, 'exclusion_ind' as column_name
union all
    select 'l_sp_polygon' as table_name, 'polygon_set_id' as column_name
union all
    select 'l_sp_polygon' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_sp_polygon' as table_name, 'remark' as column_name
union all
    select 'l_sp_polygon' as table_name, 'spatial_description_id' as column_name
union all
    select 'l_sp_polygon' as table_name, 'spatial_obs_no' as column_name
union all
    select 'l_sp_zone_substance' as table_name, 'spatial_description_id' as column_name
union all
    select 'l_sp_zone_substance' as table_name, 'spatial_obs_no' as column_name
union all
    select 'l_sp_zone_substance' as table_name, 'mineral_zone_id' as column_name
union all
    select 'l_sp_zone_substance' as table_name, 'substance' as column_name
union all
    select 'l_sp_zone_substance' as table_name, 'base_md' as column_name
union all
    select 'l_sp_zone_substance' as table_name, 'base_strat_unit_id' as column_name
union all
    select 'l_sp_zone_substance' as table_name, 'data_source' as column_name
union all
    select 'l_sp_zone_substance' as table_name, 'excluded_ind' as column_name
union all
    select 'l_sp_zone_substance' as table_name, 'included_ind' as column_name
union all
    select 'l_sp_zone_substance' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_sp_zone_substance' as table_name, 'remark' as column_name
union all
    select 'l_sp_zone_substance' as table_name, 'strat_name_set_id' as column_name
union all
    select 'l_sp_zone_substance' as table_name, 'top_md' as column_name
union all
    select 'l_sp_zone_substance' as table_name, 'top_strat_unit_id' as column_name
union all
    select 'l_spatial_description' as table_name, 'spatial_description_id' as column_name
union all
    select 'l_spatial_description' as table_name, 'spatial_obs_no' as column_name
union all
    select 'l_spatial_description' as table_name, 'coord_system_id' as column_name
union all
    select 'l_spatial_description' as table_name, 'data_source' as column_name
union all
    select 'l_spatial_description' as table_name, 'line_ind' as column_name
union all
    select 'l_spatial_description' as table_name, 'max_latitude' as column_name
union all
    select 'l_spatial_description' as table_name, 'max_longitude' as column_name
union all
    select 'l_spatial_description' as table_name, 'min_latitude' as column_name
union all
    select 'l_spatial_description' as table_name, 'min_longitude' as column_name
union all
    select 'l_spatial_description' as table_name, 'point_ind' as column_name
union all
    select 'l_spatial_description' as table_name, 'polygon_ind' as column_name
union all
    select 'l_spatial_description' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_spatial_description' as table_name, 'remark' as column_name
union all
    select 'l_spatial_description' as table_name, 'spatial_desc_text_ind' as column_name
union all
    select 'l_spatial_description' as table_name, 'spatial_desc_type' as column_name
union all
    select 'l_strat_name_set' as table_name, 'strat_name_set_id' as column_name
union all
    select 'l_strat_name_set' as table_name, 'business_associate' as column_name
union all
    select 'l_strat_name_set' as table_name, 'data_source' as column_name
union all
    select 'l_strat_name_set' as table_name, 'effective_date' as column_name
union all
    select 'l_strat_name_set' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_strat_name_set' as table_name, 'preferred_ind' as column_name
union all
    select 'l_strat_name_set' as table_name, 'remark' as column_name
union all
    select 'l_strat_unit' as table_name, 'strat_name_set_id' as column_name
union all
    select 'l_strat_unit' as table_name, 'strat_unit_id' as column_name
union all
    select 'l_strat_unit' as table_name, 'average_age' as column_name
union all
    select 'l_strat_unit' as table_name, 'business_associate' as column_name
union all
    select 'l_strat_unit' as table_name, 'data_source' as column_name
union all
    select 'l_strat_unit' as table_name, 'effective_date' as column_name
union all
    select 'l_strat_unit' as table_name, 'fault_type' as column_name
union all
    select 'l_strat_unit' as table_name, 'form_code' as column_name
union all
    select 'l_strat_unit' as table_name, 'long_name' as column_name
union all
    select 'l_strat_unit' as table_name, 'max_age' as column_name
union all
    select 'l_strat_unit' as table_name, 'min_age' as column_name
union all
    select 'l_strat_unit' as table_name, 'ordinal_age_code' as column_name
union all
    select 'l_strat_unit' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_strat_unit' as table_name, 'remark' as column_name
union all
    select 'l_strat_well_section' as table_name, 'uwi' as column_name
union all
    select 'l_strat_well_section' as table_name, 'strat_name_set_id' as column_name
union all
    select 'l_strat_well_section' as table_name, 'strat_unit_id' as column_name
union all
    select 'l_strat_well_section' as table_name, 'interp_id' as column_name
union all
    select 'l_strat_well_section' as table_name, 'data_source' as column_name
union all
    select 'l_strat_well_section' as table_name, 'interpreter' as column_name
union all
    select 'l_strat_well_section' as table_name, 'ordinal_seq_no' as column_name
union all
    select 'l_strat_well_section' as table_name, 'overturned_ind' as column_name
union all
    select 'l_strat_well_section' as table_name, 'pick_date' as column_name
union all
    select 'l_strat_well_section' as table_name, 'pick_tvd' as column_name
union all
    select 'l_strat_well_section' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_strat_well_section' as table_name, 'remark' as column_name
union all
    select 'l_strat_well_section' as table_name, 'strat_unit_age' as column_name
union all
    select 'l_well' as table_name, 'uwi' as column_name
union all
    select 'l_well' as table_name, 'alt_well_name' as column_name
union all
    select 'l_well' as table_name, 'aof_count' as column_name
union all
    select 'l_well' as table_name, 'assigned_field' as column_name
union all
    select 'l_well' as table_name, 'basin' as column_name
union all
    select 'l_well' as table_name, 'bottom_hole_latitude' as column_name
union all
    select 'l_well' as table_name, 'bottom_hole_loc_quality' as column_name
union all
    select 'l_well' as table_name, 'bottom_hole_longitude' as column_name
union all
    select 'l_well' as table_name, 'completion_date' as column_name
union all
    select 'l_well' as table_name, 'comp_count' as column_name
union all
    select 'l_well' as table_name, 'confidential_date' as column_name
union all
    select 'l_well' as table_name, 'core_count' as column_name
union all
    select 'l_well' as table_name, 'country' as column_name
union all
    select 'l_well' as table_name, 'current_class' as column_name
union all
    select 'l_well' as table_name, 'current_status' as column_name
union all
    select 'l_well' as table_name, 'current_status_date' as column_name
union all
    select 'l_well' as table_name, 'data_source' as column_name
union all
    select 'l_well' as table_name, 'datum' as column_name
union all
    select 'l_well' as table_name, 'dir_srvy_count' as column_name
union all
    select 'l_well' as table_name, 'drill_rig_num' as column_name
union all
    select 'l_well' as table_name, 'drill_td' as column_name
union all
    select 'l_well' as table_name, 'dst_count' as column_name
union all
    select 'l_well' as table_name, 'final_drill_date' as column_name
union all
    select 'l_well' as table_name, 'final_td' as column_name
union all
    select 'l_well' as table_name, 'ground_elev' as column_name
union all
    select 'l_well' as table_name, 'ipts_count' as column_name
union all
    select 'l_well' as table_name, 'kb_elev' as column_name
union all
    select 'l_well' as table_name, 'last_injection_date' as column_name
union all
    select 'l_well' as table_name, 'last_production_date' as column_name
union all
    select 'l_well' as table_name, 'lease' as column_name
union all
    select 'l_well' as table_name, 'licensee' as column_name
union all
    select 'l_well' as table_name, 'license_date' as column_name
union all
    select 'l_well' as table_name, 'license_number' as column_name
union all
    select 'l_well' as table_name, 'log_count' as column_name
union all
    select 'l_well' as table_name, 'max_tvd' as column_name
union all
    select 'l_well' as table_name, 'oldest_strat_age' as column_name
union all
    select 'l_well' as table_name, 'oldest_strat_unit_id' as column_name
union all
    select 'l_well' as table_name, 'on_injection_date' as column_name
union all
    select 'l_well' as table_name, 'on_production_date' as column_name
union all
    select 'l_well' as table_name, 'operator' as column_name
union all
    select 'l_well' as table_name, 'operator_abbreviation' as column_name
union all
    select 'l_well' as table_name, 'parent_relationship_type' as column_name
union all
    select 'l_well' as table_name, 'parent_uwi' as column_name
union all
    select 'l_well' as table_name, 'plot_symbol' as column_name
union all
    select 'l_well' as table_name, 'pool' as column_name
union all
    select 'l_well' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_well' as table_name, 'producing_horizon' as column_name
union all
    select 'l_well' as table_name, 'producing_status' as column_name
union all
    select 'l_well' as table_name, 'producing_strat_age' as column_name
union all
    select 'l_well' as table_name, 'profile_type' as column_name
union all
    select 'l_well' as table_name, 'prospect_name' as column_name
union all
    select 'l_well' as table_name, 'province_state' as column_name
union all
    select 'l_well' as table_name, 'region' as column_name
union all
    select 'l_well' as table_name, 'remark' as column_name
union all
    select 'l_well' as table_name, 'rig_release_date' as column_name
union all
    select 'l_well' as table_name, 'situation' as column_name
union all
    select 'l_well' as table_name, 'spud_date' as column_name
union all
    select 'l_well' as table_name, 'status_type' as column_name
union all
    select 'l_well' as table_name, 'surface_latitude' as column_name
union all
    select 'l_well' as table_name, 'surface_loc_quality' as column_name
union all
    select 'l_well' as table_name, 'surface_longitude' as column_name
union all
    select 'l_well' as table_name, 'surface_uwi' as column_name
union all
    select 'l_well' as table_name, 'survey_grid' as column_name
union all
    select 'l_well' as table_name, 'su_count' as column_name
union all
    select 'l_well' as table_name, 'td_formation' as column_name
union all
    select 'l_well' as table_name, 'td_strat_age' as column_name
union all
    select 'l_well' as table_name, 'td_strat_name_set_id' as column_name
union all
    select 'l_well' as table_name, 'td_strat_unit_id' as column_name
union all
    select 'l_well' as table_name, 'vel_srvy_count' as column_name
union all
    select 'l_well' as table_name, 'water_depth' as column_name
union all
    select 'l_well' as table_name, 'water_depth_datum' as column_name
union all
    select 'l_well' as table_name, 'well_name' as column_name
union all
    select 'l_well' as table_name, 'well_number' as column_name
union all
    select 'l_well' as table_name, 'well_numeric_id' as column_name
union all
    select 'l_well' as table_name, 'well_type' as column_name
union all
    select 'l_well' as table_name, 'row_changed_date' as column_name
union all
    select 'l_well_alias' as table_name, 'uwi' as column_name
union all
    select 'l_well_alias' as table_name, 'source' as column_name
union all
    select 'l_well_alias' as table_name, 'well_alias_id' as column_name
union all
    select 'l_well_alias' as table_name, 'alias_type' as column_name
union all
    select 'l_well_alias' as table_name, 'data_source' as column_name
union all
    select 'l_well_alias' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_well_alias' as table_name, 'preferred_ind' as column_name
union all
    select 'l_well_alias' as table_name, 'remark' as column_name
union all
    select 'l_well_alias' as table_name, 'well_alias' as column_name
union all
    select 'l_well_service' as table_name, 'uwi' as column_name
union all
    select 'l_well_service' as table_name, 'source' as column_name
union all
    select 'l_well_service' as table_name, 'service_table' as column_name
union all
    select 'l_well_service' as table_name, 'service_type' as column_name
union all
    select 'l_well_service' as table_name, 'service_number' as column_name
union all
    select 'l_well_service' as table_name, 'base_md' as column_name
union all
    select 'l_well_service' as table_name, 'base_strat_unit_age' as column_name
union all
    select 'l_well_service' as table_name, 'base_strat_unit_id' as column_name
union all
    select 'l_well_service' as table_name, 'data_source' as column_name
union all
    select 'l_well_service' as table_name, 'ppdm_guid' as column_name
union all
    select 'l_well_service' as table_name, 'primary_strat_unit_age' as column_name
union all
    select 'l_well_service' as table_name, 'primary_strat_unit_id' as column_name
union all
    select 'l_well_service' as table_name, 'remark' as column_name
union all
    select 'l_well_service' as table_name, 'service_date' as column_name
union all
    select 'l_well_service' as table_name, 'strat_name_set_id' as column_name
union all
    select 'l_well_service' as table_name, 'top_md' as column_name
union all
    select 'l_well_service' as table_name, 'top_strat_unit_age' as column_name
union all
    select 'l_well_service' as table_name, 'top_strat_unit_id' as column_name
)
select * from base
order by table_name, column_name
