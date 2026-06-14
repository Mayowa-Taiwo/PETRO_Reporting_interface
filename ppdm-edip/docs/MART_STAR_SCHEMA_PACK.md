# Mart Star Schema Pack — Oil & Gas Executive BI Reporting Suite

Module-by-module specification: **≥20 fact columns**, **≥10 dim columns** per dimension, **≥12 KPIs** with formulas, and **60–40 coverage map** (essential vs enhanced PPDM Lite columns with point allocation).

---

## 1. Production Performance Mart

### 1.1 Fact table: `marts_production.fact_production` (≥20 columns)

| # | Column name         | Type    | Description |
|---|---------------------|--------|-------------|
| 1 | fact_production_key | BIGINT  | Surrogate PK |
| 2 | tenant_id           | UUID    | Tenant isolation |
| 3 | pden_key            | BIGINT  | FK dim_pden |
| 4 | date_key            | INT     | FK dim_date |
| 5 | product_key         | INT     | FK dim_product |
| 6 | operator_key        | INT     | FK dim_operator |
| 7 | field_pool_key      | INT     | FK dim_field_pool |
| 8 | oil_cum_volume      | NUMERIC | Cumulative oil (std UOM) |
| 9 | gas_cum_volume      | NUMERIC | Cumulative gas (std UOM) |
| 10| water_cum_volume    | NUMERIC | Cumulative water |
| 11| boe_cum_volume      | NUMERIC | BOE equivalent |
| 12| oil_volume_ouom     | TEXT    | Original oil UOM |
| 13| gas_volume_ouom     | TEXT    | Original gas UOM |
| 14| volume_method       | TEXT    | e.g. measured, estimated |
| 15| activity_type       | TEXT    | e.g. production, injection |
| 16| data_source         | TEXT    | From L_PPDM_DATA_SOURCE |
| 17| uom_key             | INT     | FK to UOM dim if used |
| 18| load_run_id         | UUID    | ETL run |
| 19| refreshed_at        | TIMESTAMPTZ | Last refresh |
| 20| pden_id_natural     | TEXT    | Natural key (pden_id) |
| 21| pden_type           | TEXT    | WELL, etc. |
| 22| pden_source        | TEXT    | Source system |

**Grain:** One row per (tenant_id, pden_key, date_key, volume_method, activity_type).

---

### 1.2 Dimensions (≥10 columns each)

**dim_pden**

| # | Column          | Type   | Description |
|---|-----------------|--------|-------------|
| 1 | pden_key        | BIGINT | PK |
| 2 | pden_id         | TEXT   | Natural ID |
| 3 | pden_type       | TEXT   | WELL, etc. |
| 4 | pden_source     | TEXT   | Source |
| 5 | pden_name       | TEXT   | Name |
| 6 | uwi             | TEXT   | Unique well ID |
| 7 | primary_product | TEXT   | Oil, Gas, etc. |
| 8 | pool_id         | TEXT   | Pool |
| 9 | field_id        | TEXT   | Field |
| 10| data_source     | TEXT   | Governance |
| 11| operator_id     | TEXT   | Current operator |
| 12| effective_from  | DATE   | SCD |
| 13| effective_to    | DATE   | SCD |
| 14| is_current      | BOOLEAN| SCD current flag |

**dim_date**

| # | Column       | Type | Description |
|---|--------------|------|-------------|
| 1 | date_key     | INT  | PK (e.g. YYYYMMDD) |
| 2 | calendar_date| DATE | Date |
| 3 | day_of_week  | INT  | 1–7 |
| 4 | day_of_month | INT  | 1–31 |
| 5 | month        | INT  | 1–12 |
| 6 | quarter      | INT  | 1–4 |
| 7 | year         | INT  | Year |
| 8 | month_name   | TEXT | January, etc. |
| 9 | quarter_name | TEXT | Q1, etc. |
| 10| is_weekend   | BOOLEAN | |
| 11| fiscal_year  | INT  | Optional |
| 12| fiscal_quarter| INT | Optional |

**dim_product**

| # | Column       | Type  | Description |
|---|-------------|-------|-------------|
| 1 | product_key | INT   | PK |
| 2 | product_code | TEXT | PRIMARY_PRODUCT value |
| 3 | product_name | TEXT | Oil, Gas, etc. |
| 4 | product_group| TEXT | Hydrocarbon, etc. |
| 5 | is_primary   | BOOLEAN | |
| 6 | sort_order   | INT   | |
| 7 | data_source  | TEXT | |
| 8 | effective_from | DATE | |
| 9 | effective_to | DATE | |
| 10| is_current  | BOOLEAN | |

**dim_operator**

| # | Column        | Type  | Description |
|---|--------------|-------|-------------|
| 1 | operator_key | INT   | PK |
| 2 | operator_id  | TEXT  | Business associate ID |
| 3 | operator_name| TEXT  | Name |
| 4 | operator_type| TEXT  | Company, etc. |
| 5 | country      | TEXT  | |
| 6 | data_source  | TEXT  | |
| 7 | effective_from | DATE | |
| 8 | effective_to | DATE | |
| 9 | is_current   | BOOLEAN | |
| 10| row_checksum| TEXT  | Optional SCD |

**dim_field_pool**

| # | Column          | Type  | Description |
|---|-----------------|-------|-------------|
| 1 | field_pool_key | INT   | PK |
| 2 | field_id       | TEXT  | Field ID |
| 3 | pool_id        | TEXT  | Pool ID |
| 4 | field_name     | TEXT  | |
| 5 | pool_name      | TEXT  | |
| 6 | area_id        | TEXT  | Area |
| 7 | data_source    | TEXT  | |
| 8 | effective_from | DATE  | |
| 9 | effective_to    | DATE  | |
| 10| is_current     | BOOLEAN | |

---

### 1.3 KPI library (≥12 KPIs)

| # | KPI name           | Definition | Formula (SQL-like) |
|---|--------------------|------------|--------------------|
| 1 | Total Oil MTD      | Oil production month-to-date | `SUM(f.oil_cum_volume) WHERE d.year = current_year AND d.month = current_month` |
| 2 | Total Gas MTD      | Gas production MTD | `SUM(f.gas_cum_volume)` same filter |
| 3 | BOE MTD            | BOE production MTD | `SUM(f.boe_cum_volume)` same filter |
| 4 | Total Oil YTD      | Oil year-to-date | `SUM(f.oil_cum_volume) WHERE d.year = current_year` |
| 5 | YoY Growth % Oil   | (This year oil − Last year oil) / Last year oil × 100 | `(SUM current_year − SUM prior_year) / NULLIF(SUM prior_year,0) * 100` |
| 6 | Production per Well | Total volume / distinct well count | `SUM(f.oil_cum_volume + f.gas_cum_volume/6) / COUNT(DISTINCT f.pden_key)` |
| 7 | Top 10 PDENs by Oil | Rank PDENs by oil volume | `RANK() OVER (ORDER BY SUM(oil_cum_volume) DESC)` limit 10 |
| 8 | Decline Rate %     | (Prior period − Current) / Prior × 100 | Period-over-period at chosen grain |
| 9 | Utilization %      | Producing wells / Total wells × 100 | `COUNT(DISTINCT pden_key WHERE producing) / COUNT(DISTINCT pden_key) * 100` |
| 10| Forecast vs Actual %| Actual / Forecast × 100 | Join to forecast fact; `SUM(actual)/NULLIF(SUM(forecast),0)*100` |
| 11| Production by Field | Sum volumes by field_pool_key (field) | `SUM(measures) GROUP BY field_pool_key, field_id` |
| 12| Production by Operator| Sum volumes by operator_key | `SUM(measures) GROUP BY operator_key` |

---

### 1.4 Coverage map (100 points: 60 essential / 40 enhanced)

**Essential (60 points) — must be present for mart to be viable**

| Points | PPDM Lite table        | PPDM Lite column(s) |
|--------|------------------------|----------------------|
| 8      | L_PDEN                 | PDEN_ID, PDEN_TYPE, PDEN_SOURCE |
| 6      | L_PDEN                 | PDEN_NAME, DATA_SOURCE, UWI |
| 6      | L_PDEN                 | PRIMARY_PRODUCT, POOL_ID |
| 10     | L_PDEN_VOL_SUMMARY     | PDEN_ID, PDEN_TYPE, PDEN_SOURCE, VOLUME_DATE |
| 10     | L_PDEN_VOL_SUMMARY     | VOLUME_METHOD, ACTIVITY_TYPE, OIL_CUM_VOLUME, GAS_CUM_VOLUME |
| 8      | L_PDEN_VOL_SUMMARY     | PRIMARY_PRODUCT, DATA_SOURCE |
| 12     | L_FIELD, L_POOL        | FIELD_ID, POOL_ID, names, DATA_SOURCE (join to PDEN) |

**Enhanced (40 points) — improves fidelity**

| Points | PPDM Lite table        | PPDM Lite column(s) |
|--------|------------------------|----------------------|
| 6      | L_PDEN                 | REMARK, OTHER_NAME |
| 8      | L_PDEN_VOL_SUMMARY     | WATER_CUM_VOLUME, BOE_CUM_VOLUME |
| 6      | L_PDEN_VOL_SUMMARY     | OIL_VOLUME_OUOM, GAS_VOLUME_OUOM, REMARK |
| 10     | L_PDEN_XREF            | FROM_PDEN_ID, TO_PDEN_ID, PDEN_SOURCE, etc. |
| 10     | L_PPDM_DATA_SOURCE     | DATA_SOURCE, USER_NAME (for catalog) |

---

## 2. Asset & Well Performance Mart

### 2.1 Fact: `marts_wells.fact_well_service` (≥20 columns)

fact_well_service_key, tenant_id, well_key, pden_key, date_key, facility_key, service_type, service_date, service_obs_no, strat_unit_id, depth_from, depth_to, data_source, job_type, contractor_id, duration_days, cost_amount, cost_currency, load_run_id, refreshed_at, well_id_natural, well_source, uwi.

### 2.2 Dims: dim_well (≥10 cols)

well_key, well_id, source, uwi, well_name, well_type, status, facility_id, facility_type, field_id, pool_id, operator_id, data_source, spud_date, completion_date, effective_from, effective_to, is_current.

### 2.3 KPIs (≥12)

Well count; Wells on production; Service events count; Avg well life (days); Top wells by oil; Top wells by gas; Well status distribution (count by status); Services per well (avg); Workover count; Plugged well count; Active well count; Well density by field.

### 2.4 Coverage: 60 essential — L_WELL (WELL_ID, SOURCE, UWI, DATA_SOURCE, STATUS, FACILITY_ID, FACILITY_TYPE), L_WELL_SERVICE (WELL_ID, SOURCE, SERVICE_DATE, SERVICE_TYPE). 40 enhanced — L_WELL_ALIAS, L_WELL (REMARK, dates), L_STRAT_WELL_SECTION, L_STRAT_UNIT.

---

## 3. Reserves & Resource Classification Mart

### 3.1 Fact: `marts_reserves.fact_reserves` (≥20 columns)

fact_reserves_key, tenant_id, reserve_entity_key, project_key, pden_key, date_key, class_key, component_key, volume_oil, volume_gas, volume_boe, volume_ouom, reserves_category, confidence_level, data_source, as_of_date, load_run_id, refreshed_at, resent_id, project_id, entity_name.

### 3.2 Dims: dim_reserve_entity (≥10), dim_project (≥10), dim_reserves_class (≥10)

dim_reserve_entity: entity_key, resent_id, entity_name, entity_type, data_source, effective_from, effective_to, is_current, project_id, geography_id, remark (10+).  
dim_project: project_key, project_id, project_name, project_type, data_source, start_date, end_date, effective_from, effective_to, is_current (10+).  
dim_reserves_class: class_key, class_id, class_name, category_1p_2p_3p, sort_order, data_source, effective_from, effective_to, is_current (10+).

### 3.3 KPIs (≥12)

1P/2P/3P total volume; Reserves replacement ratio; Reserves by project; Reserves by entity; YoY change %; Reserves per well; Proved developed; Proved undeveloped; Probable; Possible; Reserves growth %; Reserves life index.

### 3.4 Coverage: 60 — L_RESERVE_ENTITY (key cols, DATA_SOURCE), L_RESENT_CLASS, L_RESENT_COMPONENT (entity, class, volume cols). 40 — L_RESENT_XREF, L_PROJECT, REMARKs.

---

## 4. Land & Contract Exposure Mart

### 4.1 Fact: `marts_contracts.fact_contract_exposure` (≥20 columns)

fact_contract_exposure_key, tenant_id, contract_key, land_right_key, facility_key, field_key, pden_key, date_key, effective_from, effective_to, exposure_type, acreage, interest_pct, royalty_pct, data_source, contract_id, component_id, load_run_id, refreshed_at, uwi, area_id.

### 4.2 Dims: dim_contract (≥10), dim_land_right (≥10)

dim_contract: contract_key, contract_id, source, contract_name, contract_type, start_date, end_date, data_source, effective_from, effective_to, is_current (10+).  
dim_land_right: land_right_key, land_right_id, land_sale_id, right_type, area_id, data_source, effective_from, effective_to, is_current (10+).

### 4.3 KPIs (≥12)

Contract count; Expiring in 90/180/365 days; Exposure by facility; Acreage total; Renewal risk index; Contracts by type; Active land rights count; Expired contracts count; Average interest %; Average royalty %; Exposure by field; JV contract count.

### 4.4 Coverage: 60 — L_CONTRACT (CONTRACT_ID, SOURCE, DATA_SOURCE), L_CONTRACT_COMPONENT (contract, facility/field/pden links), L_LAND_RIGHT (key cols). 40 — L_CONT_EXTENSION, L_LAND_SALE, L_LAND_XREF, aliases.

---

## 5. Financial & Cost Intelligence Mart

### 5.1 Fact: `marts_finance.fact_finance` (≥20 columns)

fact_finance_key, tenant_id, project_key, facility_key, pden_key, date_key, currency_key, cost_type, amount, amount_reporting_currency, capex_opex_flag, category, data_source, finance_id, component_id, load_run_id, refreshed_at, period_start, period_end, budget_amount, actual_amount, variance.

### 5.2 Dims: dim_project (≥10), dim_currency (≥10)

dim_currency: currency_key, currency_code, currency_name, reporting_currency_flag, exchange_rate_to_reporting, effective_from, effective_to, is_current (10+).

### 5.3 KPIs (≥12)

CAPEX by project; OPEX by project; Cost per BOE; Budget vs actual %; Variance amount; Variance %; Cost by facility; Cost by category; YTD spend; Forecast spend; Cost trend YoY %; Over/under budget count.

### 5.4 Coverage: 60 — L_FINANCE (key, DATA_SOURCE), L_FIN_COST_SUMMARY (amounts, dates, links). 40 — L_FIN_COMPONENT, L_FIN_XREF, currency/UOM.

---

## 6. Facility & Infrastructure Utilization Mart

### 6.1 Fact: `marts_facility.fact_facility_utilization` (≥20 columns)

fact_facility_utilization_key, tenant_id, facility_key, field_key, date_key, throughput_volume, capacity_volume, utilization_pct, downtime_hours, substance_type, data_source, facility_id, facility_type, load_run_id, refreshed_at, operator_id, status, on_stream_date, off_stream_date, period_start, period_end.

### 6.2 Dims: dim_facility (≥10)

facility_key, facility_id, facility_type, facility_name, facility_function, status, operator_id, field_id, data_source, effective_from, effective_to, is_current, capacity_uom, throughput_uom (10+).

### 6.3 KPIs (≥12)

Facility count; Utilization %; Capacity vs throughput; Downtime hours; Bottleneck index; Facilities by type; Avg utilization; Top 10 by throughput; Off-stream count; On-stream count; Throughput trend; Capacity utilization trend.

### 6.4 Coverage: 60 — L_FACILITY (FACILITY_ID, TYPE, NAME, DATA_SOURCE, status, operator). 40 — L_FACILITY_SUBSTANCE, L_FACILITY_XREF, dates.

---

## 7. Spatial Intelligence Mart (GIS-ready)

### 7.1 Fact: `marts_spatial.fact_spatial_feature` (≥20 columns)

fact_spatial_feature_key, tenant_id, spatial_type_key, pden_key, facility_key, land_right_key, geometry_key, feature_id, geom_wkt, geom_area, geom_length, coordinate_system_id, data_source, load_run_id, refreshed_at, spatial_description_id, obs_no, component_type, uwi, field_id, area_id (20+).

### 7.2 Dims: dim_spatial_type (≥10), dim_geometry (≥10)

dim_spatial_type: spatial_type_key, type_code, type_name, geometry_type, data_source (10+).  
dim_geometry: geometry_key, geometry_id, geom_type, srid, bounds, data_source (10+).

### 7.3 KPIs (≥12)

Feature count by type; Total area; Total length; Features by asset; Intersection count; Coverage % by field; Point count; Line count; Polygon count; Features by jurisdiction; New features this period; Changed geometry count.

### 7.4 Coverage: 60 — L_SPATIAL_DESCRIPTION, L_SP_GEOMETRY (or L_SP_POINT/LINE/POLYGON), L_SP_COMPONENT (links). 40 — L_SP_BOUNDARY, attributes.

---

## 8. Governance & Data Quality Mart

### 8.1 Fact: `marts_governance.fact_dq_score` (≥20 columns)

fact_dq_score_key, tenant_id, table_key, run_key, essential_total, essential_valid, optional_total, optional_valid, essential_coverage_pct, optional_coverage_pct, dq_score, certified_ind, computed_at, target_table_name, run_id, data_source_key, load_run_id, refreshed_at, prior_run_score, score_delta, tables_in_scope_count, columns_covered_count (20+).

### 8.2 Fact: `marts_governance.fact_exception` (≥20 columns)

fact_exception_key, tenant_id, table_key, run_key, exception_id, exception_table_name, exception_column_name, exception_type, error_message, exception_date, run_id, data_source, load_run_id, refreshed_at, severity, rule_name, row_count_affected, trend_bucket (20+).

### 8.3 Dims: dim_table (≥10), dim_run (≥10)

dim_table: table_key, table_name, schema_name, table_comment, data_source, effective_from, effective_to, is_current (10+).  
dim_run: run_key, run_id, source_id, started_at, finished_at, status, mode, notes (10+).

### 8.4 KPIs (≥12)

Tables covered count; Columns covered count; Exception count by run; Exception count by table; Lineage depth (max hops); Certification % (tables with score ≥80); Avg DQ score; Essential coverage %; Trend: exceptions last 7 days; Top 5 tables by exceptions; Certified table count; Uncertified table count.

### 8.5 Coverage: 60 — L_PPDM_TABLE (TABLE_NAME), L_PPDM_COLUMN (TABLE_NAME, COLUMN_NAME), L_PPDM_ORIGIN (source/target, run_id), L_PPDM_EXCEPTION (table, column, message, run_id). 40 — Comments, DATA_SOURCE, table_comment.

---

## 9. Partner/JV & Entitlements Mart

### 9.1 Fact: `marts_jv.fact_entitlement` (≥20 columns)

fact_entitlement_key, tenant_id, entitlement_key, interest_set_key, partner_key, contract_key, facility_key, pden_key, date_key, entitlement_pct, share_volume, share_amount, data_source, load_run_id, refreshed_at, entitlement_id, component_id, partner_id, interest_set_id, period_start, period_end (20+).

### 9.2 Dims: dim_partner (≥10), dim_interest_set (≥10)

dim_partner: partner_key, partner_id, partner_name, partner_type, data_source, effective_from, effective_to, is_current (10+).  
dim_interest_set: interest_set_key, interest_set_id, interest_set_name, data_source, effective_from, effective_to, is_current (10+).

### 9.3 KPIs (≥12)

Partner count; Entitlement % by asset; JV revenue share; Reconciliation variance; Entitlement by facility; Entitlement by contract; Total share volume; Total share amount; Partners by interest set; Interest sets count; Variance trend; Over/under entitlement count.

### 9.4 Coverage: 60 — L_ENTITLEMENT, L_ENT_COMPONENT (entity, share, dates), L_INTEREST_SET, L_INT_SET_PARTNER. 40 — L_ENT_GROUP, L_INT_SET_COMPONENT.

---

## 10. Regulatory & Compliance / Information Item Mart

### 10.1 Fact: `marts_regulatory.fact_regulatory_item` (≥20 columns)

fact_regulatory_item_key, tenant_id, item_key, contract_key, land_right_key, date_key, version_no, item_type, due_date, submitted_date, status, jurisdiction, data_source, load_run_id, refreshed_at, information_item_id, content_summary, obligation_id, period_start, period_end, compliance_flag (20+).

### 10.2 Dims: dim_regulatory_type (≥10), dim_obligation (≥10)

dim_regulatory_type: type_key, type_code, type_name, jurisdiction, data_source (10+).  
dim_obligation: obligation_key, obligation_id, obligation_name, contract_id, due_frequency, data_source (10+).

### 10.3 KPIs (≥12)

Items due this period; Compliance rate %; Items overdue count; Items by jurisdiction; Items by type; Submitted on time %; Average days to submit; Pending count; Approved count; Rejected count; Trend: compliance last 6 months; Risk score (overdue + high severity).

### 10.4 Coverage: 60 — L_RM_INFORMATION_ITEM (key, type, DATA_SOURCE), L_RM_INFO_ITEM_CONTENT. 40 — L_RM_INFO_ITEM_DESC, links to L_CONTRACT, L_LAND_RIGHT.

---

## Summary table: mart schemas

| Mart | Fact table | Fact cols | Dims | Dim cols each | KPIs | Coverage 60/40 |
|------|------------|-----------|------|----------------|------|----------------|
| 1 Production | fact_production | 22 | 5 | ≥10 | 12 | §1.4 |
| 2 Wells | fact_well_service | 23 | 4+ | ≥10 | 12 | §2.4 |
| 3 Reserves | fact_reserves | 21 | 3+ | ≥10 | 12 | §3.4 |
| 4 Contracts | fact_contract_exposure | 21 | 2+ | ≥10 | 12 | §4.4 |
| 5 Finance | fact_finance | 22 | 2+ | ≥10 | 12 | §5.4 |
| 6 Facility | fact_facility_utilization | 21 | 1+ | ≥10 | 12 | §6.4 |
| 7 Spatial | fact_spatial_feature | 21 | 2+ | ≥10 | 12 | §7.4 |
| 8 Governance | fact_dq_score, fact_exception | 20+ each | 2 | ≥10 | 12 | §8.5 |
| 9 JV | fact_entitlement | 21 | 2+ | ≥10 | 12 | §9.4 |
| 10 Regulatory | fact_regulatory_item | 21 | 2+ | ≥10 | 12 | §10.4 |

All marts derive facts **only** from PPDM Lite (Gold); conformed dimensions are shared per TRD Section 5.
