"""
Product 5: Master Data Governance.

Tables: L_PPDM_DATA_SOURCE, L_PPDM_TABLE, L_PPDM_COLUMN, L_BUSINESS_ASSOCIATE,
L_AREA, L_APPLICATION, L_PROJECT, L_ENTITLEMENT, L_FACILITY, RM info items,
SF (support facility), STRAT_WELL_SECTION, etc.

Use cases: data source catalog, schema compliance, business associate master,
area/project master.
"""

from ldv_platform.domain_products import get_domain_tables

PRODUCT_ID = "5_master_governance"
TABLES = get_domain_tables(PRODUCT_ID)

PRIMARY_ENTITIES = [
    "l_ppdm_data_source",
    "l_ppdm_table",
    "l_business_associate",
    "l_area",
    "l_project",
]
