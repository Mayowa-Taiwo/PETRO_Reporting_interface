"""
Product 3: Contracts & Licensing.

Tables: L_CONTRACT, L_LICENSE, L_LAND_RIGHT, L_LAND_SALE, L_FINANCE (link),
L_INT_SET_PARTNER, L_CONTRACT_COMPONENT, L_CONT_ALIAS, L_CONT_EXTENSION,
L_LAND_SALE_OFFERING, L_LAND_ALIAS, L_LAND_XREF, L_INTEREST_SET, L_INT_SET_COMPONENT.

Use cases: license expiry predictor, contract exposure dashboard,
interest partner allocation risk, land sale analytics.
"""

from ldv_platform.domain_products import get_domain_tables

PRODUCT_ID = "3_contracts_licensing"
TABLES = get_domain_tables(PRODUCT_ID)

PRIMARY_ENTITIES = [
    "l_contract",
    "l_license",
    "l_land_right",
    "l_land_sale",
    "l_int_set_partner",
]
