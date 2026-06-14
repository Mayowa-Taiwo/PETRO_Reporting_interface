# Tanna Canonical Information Architecture

**Product:** PETRO Reporting Interface (EDIP + PPDM-EDIP unified portal)  
**Document purpose:** Identify what information objects exist in this product and map them into the Tanna Intelligence Operating System hierarchy.  
**Scope:** Repository as inspected in source (`PROJECT_CONTEXT.md`, SQL migrations, APIs, portal UI, dbt models, specification docs).  
**Out of scope:** Implementation design, code changes, or deployment instructions.

---

## 1. Executive summary

The PETRO Reporting Interface is a petroleum executive BI and governance workspace. Information flows from **upstream petroleum sources** through **medallion layers** (Bronze → Silver → Gold/PPDM Lite → Platinum marts) into **KPI signals**, **aggregated patterns**, and **decision-facing dashboards and exports**. Institutional definitions live in **contract catalogs, policy tables, and specification documents**.

The product currently runs as **two logical data planes** behind one portal:

| Plane | Database | Primary role |
|-------|----------|--------------|
| **EDIP stack** | `edip_db` | dbt marts (`marts_*`), tenant-scoped governance metadata, Alembic-managed `meta` / `security` |
| **Governance / TRD stack** | `ppdm_db` | SQL-init medallion (`bronze`, `silver`, `ppdm_lite`, `conformed`, `marts`), ingest jobs, Platinum production mart, spatial features |

Both planes expose overlapping concepts (production KPIs, lineage, DQ, PDEN entities). A Tanna module should treat them as **one petroleum intelligence domain** with **two source-system backends** until unified.

### Tanna intelligence hierarchy (mapping lens)

```text
Sources
  → Data Products
    → Signals
      → Patterns
        → Illuminations
          → Decision Products
            → Knowledge Assets
```

| Tanna layer | What it means for this product |
|-------------|--------------------------------|
| **Sources** | Upstream systems, file drops, PPDM master references, ingest source registry |
| **Data Products** | Published schemas: Bronze/Silver/Gold tables, Platinum star schemas, dbt mart tables, spatial layers |
| **Signals** | Point measurements: volume facts, DQ scores, coverage points, exception records, KPI computed values |
| **Patterns** | Rollups and comparative structures: MTD/YTD aggregates, YoY/decline trends, top-N rankings, operator/field breakdowns, lineage graphs |
| **Illuminations** | Interpreted status: certification flags, essential vs enhanced coverage interpretation, KPI explain context, compliance findings |
| **Decision Products** | Dashboards, drill-down workspaces, CSV exports, admin job consoles that support operational and executive decisions |
| **Knowledge Assets** | PPDM contract catalog, mart definitions, essential policy, mapping registry, TRD/BI specification documents, role/tenant definitions |

---

## 2. Module identity in Tanna

| Attribute | Value |
|-----------|--------|
| **Proposed Tanna module name** | `petro-reporting` (Petroleum Executive Reporting & Governance) |
| **Domain** | Oil & gas production intelligence, PPDM Lite stewardship, executive BI |
| **Primary user surface** | Portal at `/` and `/edip/*` (`portal/`) |
| **API surfaces** | `/api/edip/v1/*` (EDIP), `/api/governance/v1/*` (ppdm-edip) |
| **Recommended Tanna root namespace** | `tanna.modules.petro-reporting` |

---

## 3. Information object catalog

Each subsection lists discovered objects with:

- **Current location** — where the object lives today  
- **Current purpose** — why it exists  
- **Tanna category** — primary layer in the intelligence hierarchy (secondary layers noted where relevant)  
- **Recommended future location** — canonical Tanna registry path (logical, not a code path)

---

## 4. Sources

Sources are upstream origins and ingest entry points — not yet curated data products.

| Object | Current location | Current purpose | Tanna category | Recommended future location |
|--------|------------------|-----------------|----------------|----------------------------|
| **Ingest source registry** | `meta.ingest_source` (`ppdm-edip/infra/docker/migrations/init/02_meta.sql`) | Registers named upstream feeds (name, type, connection ref, owner, enabled flag) | Source | `tanna.sources.registry.ingest_source` |
| **Demo / seed ingest sources** | SQL seeds under `ppdm-edip/scripts/seed/` | Bootstrap source IDs for MVP job runs | Source | `tanna.sources.registry.ingest_source` (seed profile) |
| **Bronze file landing** | `bronze.ingest_file` (`05_bronze_silver_landing.sql`) | Append-only record of landed files (name, path, row count, run) | Source | `tanna.sources.landing.bronze_file` |
| **Silver PDEN staging feed** | `silver.pden_staging` | Conformed PDEN rows awaiting publish to Gold | Source → Data Product (staging) | `tanna.sources.staging.pden` |
| **Silver volume staging feed** | `silver.pden_vol_staging` | Conformed volume rows awaiting publish | Source → Data Product (staging) | `tanna.sources.staging.pden_volume` |
| **PPDM Lite DDL upstream schema** | `ppdm-edip/scripts/init/ppdm_lite11_postgres_ddl.sql`, `edip/scripts/ddl/` (README reference) | Authoritative PPDM Lite 1.1 table definitions used to instantiate Gold | Source (schema contract) | `tanna.sources.contracts.ppdm_lite_11` |
| **External feed types (specified, not wired)** | `ppdm-edip/docs/REQUIREMENTS_MATRIX.md` REQ-P-001 (PPDM master, CSV, SCADA, regulatory, partner) | Documented upstream categories for future ingestion | Source (planned) | `tanna.sources.types.petroleum_feed` |
| **Object storage landing (specified)** | `ppdm-edip/docs/TRD_OIL_GAS_EXECUTIVE_BI_SUITE.md` | Bronze file landing via S3/MinIO | Source (planned) | `tanna.sources.landing.object_storage` |
| **Client schema JSON (compliance input)** | `ldv_platform/examples/sample_client_schema.json` (referenced); `--schema` CLI arg | External client schema snapshot for compliance checking | Source | `tanna.sources.compliance.client_schema` |
| **dbt source declarations** | `edip/dbt/edip_dbt/models/staging/ppdm_lite/*.sql` (`source('ppdm_lite', ...)`) | Declares `ppdm_lite` tables as dbt upstream sources | Source reference | `tanna.sources.registry.dbt_source` |

---

## 5. Datasets

Datasets are persisted collections at Bronze, Silver, Gold, staging, or conformed layers — before or alongside analytic marts.

| Object | Current location | Current purpose | Tanna category | Recommended future location |
|--------|------------------|-----------------|----------------|----------------------------|
| **Bronze schema** | PostgreSQL schema `bronze` (`01_schemas.sql`) | Raw landing zone namespace | Data Product (raw tier) | `tanna.data_products.layers.bronze` |
| **Silver schema** | PostgreSQL schema `silver` | Canonical staging namespace | Data Product (staging tier) | `tanna.data_products.layers.silver` |
| **PPDM Lite Gold schema** | PostgreSQL schema `ppdm_lite` (`03_ppdm_lite_full_ddl.sql` + column patches) | Publish-only consumption layer (~50+ `l_*` entity tables) | Data Product (gold tier) | `tanna.data_products.layers.ppdm_lite` |
| **Conformed schema** | PostgreSQL schema `conformed` (`08_platinum_production_mart.sql`) | Shared dimensions (`dim_date`, `dim_product`, `dim_operator`, `dim_field_pool`) | Data Product (conformed tier) | `tanna.data_products.conformed.shared_dimensions` |
| **Meta operational schema** | PostgreSQL schema `meta` (both stacks, differing tables) | Ingest, mapping, DQ, mart registry, lineage | Data Product (platform metadata) | `tanna.data_products.platform.meta` |
| **Security schema (EDIP)** | `security.*` (`edip/apps/api/alembic/`) | Tenants, users, roles | Data Product (access metadata) | `tanna.data_products.platform.security` |
| **dbt staging views** | `edip/dbt/edip_dbt/models/staging/ppdm_lite/` (~80 models) | Typed views over Gold tables for transform | Data Product (staging views) | `tanna.data_products.staging.ppdm_lite.*` |
| **Core production Gold entities** | `ppdm_lite.l_pden`, `l_pden_vol_summary`, `l_well`, `l_pool`, `l_ppdm_data_source` | Petroleum asset and volume facts at Gold grain | Data Product | `tanna.data_products.entities.production.*` |
| **Governance Gold entities** | `ppdm_lite.l_ppdm_table`, `l_ppdm_column`, `l_ppdm_origin`, `l_ppdm_exception` | Contract catalog, lineage, exceptions at Gold | Data Product | `tanna.data_products.entities.governance.*` |
| **Spatial Gold dataset** | `ppdm_lite.edip_feature_geom` | PostGIS features (wells, land polygons) | Data Product | `tanna.data_products.entities.spatial.feature_geom` |
| **Land / reserves / seismic Gold tables** | `ppdm_lite.l_land_*`, `l_resent_*`, `l_seis_*`, etc. (full DDL) | Domain entity tables present in schema; limited API/UI exposure | Data Product (latent) | `tanna.data_products.entities.{land,reserves,seismic}.*` |
| **EDIP mart schemas (declared)** | `dbt_project.yml`: `marts_production`, `marts_shared`, `marts_asset`, `marts_reserves`, `marts_contract`, `marts_finance`, `marts_facility`, `marts_spatial`, `marts_governance`, `marts_jv`, `marts_regulatory` | Target analytic product namespaces | Data Product (mart tier) | `tanna.data_products.marts.{domain}` |
| **EDIP mart tables (materialized today)** | `marts_production.fact_production`, `dim_pden`; `marts_shared.dim_date`, `dim_product`, `dim_operator` | Production star schema subset built by dbt | Data Product | `tanna.data_products.marts.production` |
| **EDIP governance fact (Alembic)** | `marts_governance.fact_dq_score` | Tenant-scoped DQ score history | Data Product | `tanna.data_products.marts.governance.fact_dq_score` |

---

## 6. Marts

Marts are decision-ready star schemas and analytic products built for BI consumption.

| Object | Current location | Current purpose | Tanna category | Recommended future location |
|--------|------------------|-----------------|----------------|----------------------------|
| **Platinum Production Performance Mart** | Views/tables in schema `marts`: `fact_production`, `dim_pden` (`08_platinum_production_mart.sql`) | Star schema for executive production KPIs and drill-down (ppdm-edip) | Data Product → Patterns (when aggregated) | `tanna.data_products.marts.production_performance` |
| **Platinum conformed dimensions** | `conformed.dim_date`, `dim_product`, `dim_operator`, `dim_field_pool` | Shared conformed dims feeding Platinum mart | Data Product | `tanna.data_products.marts.production_performance.dimensions.*` |
| **EDIP Production Mart** | `marts_production.*` (dbt) | Tenant-isolated production mart (EDIP API) | Data Product | `tanna.data_products.marts.production_performance` (tenant slice) |
| **EDIP Shared Dimensions Mart** | `marts_shared.*` (dbt) | Cross-mart date/product/operator dims | Data Product | `tanna.data_products.marts.shared_dimensions` |
| **Production mart registry entry** | `meta.mart_registry` row `mart_id='production'` (`edip/scripts/seed/seed_roles_tenant_user.sql`) | Registers Production Performance mart and schema binding | Knowledge Asset → Data Product registry | `tanna.data_products.registry.marts.production` |
| **Mart contract scoring items** | `meta.mart_contract_item` | 60/40 point map from Gold columns to production mart certification | Knowledge Asset → Governance | `tanna.knowledge_assets.mart_contracts.production` |
| **Specified marts (docs only, not built)** | `ppdm-edip/docs/MART_STAR_SCHEMA_PACK.md` §2–§10: Well Performance, Reserves, Land & Contract, Financial, Facility, Spatial, Governance, JV, Regulatory | Target mart catalog for full BI suite | Knowledge Asset (planned Data Products) | `tanna.data_products.marts.{well_performance,reserves,land_contract,finance,facility,spatial,governance,jv,regulatory}` |

---

## 7. Entities

Business entities are identifiable objects referenced across layers, APIs, and UI.

| Entity | Current location | Current purpose | Tanna category | Recommended future location |
|--------|------------------|-----------------|----------------|----------------------------|
| **PDEN** (Production Entity) | `ppdm_lite.l_pden`, `marts.dim_pden`, `marts_production.dim_pden`; APIs `/v1/production/pdens`, `/v1/marts/production/pdens` | Core production reporting unit (well, facility, etc.) | Data Product (entity) | `tanna.data_products.entities.pden` |
| **PDEN volume summary** | `ppdm_lite.l_pden_vol_summary`, `marts.fact_production` | Time-series production volumes by method/activity | Data Product (entity) | `tanna.data_products.entities.pden_volume` |
| **Well** | `ppdm_lite.l_well`, spatial layer `l_well_point` | Well master and map features | Data Product (entity) | `tanna.data_products.entities.well` |
| **Pool / Field-Pool** | `ppdm_lite.l_pool`, `conformed.dim_field_pool` | Field/pool hierarchy for rollups | Data Product (entity) | `tanna.data_products.entities.field_pool` |
| **Operator** | `conformed.dim_operator`, `marts_shared.dim_operator` | Operator dimension for production attribution | Data Product (entity) | `tanna.data_products.entities.operator` |
| **Product** | `conformed.dim_product`, `marts_shared.dim_product` | Hydrocarbon product type (oil, gas, etc.) | Data Product (entity) | `tanna.data_products.entities.product` |
| **Date** | `conformed.dim_date`, `marts_shared.dim_date` | Calendar dimension for time analysis | Data Product (entity) | `tanna.data_products.entities.date` |
| **Ingest run** | `meta.ingest_run` | ETL/publish execution instance | Data Product (operational entity) | `tanna.data_products.entities.ingest_run` |
| **Data exception** | `ppdm_lite.l_ppdm_exception`, `meta.data_exception` (EDIP) | Validation/stewardship exception records | Signal → Governance entity | `tanna.signals.exceptions.data_exception` |
| **Spatial layer** | API `/v1/spatial/layers`; `ppdm_lite.edip_feature_geom` | Map layer catalog and GeoJSON features | Data Product | `tanna.data_products.entities.spatial_layer` |
| **Tenant** | `security.tenants` (EDIP) | Multi-tenant isolation boundary | Data Product (platform entity) | `tanna.data_products.platform.tenant` |
| **User / Role** | `security.users`, `security.roles`, `security.user_roles` | Access control principals | Data Product (platform entity) | `tanna.data_products.platform.identity` |
| **Contract table/column** | `ppdm_lite.l_ppdm_table`, `l_ppdm_column` | PPDM schema contract metadata | Knowledge Asset → Data Product catalog | `tanna.knowledge_assets.contracts.ppdm_lite.{table,column}` |

---

## 8. Metrics

Metrics are atomic or column-level measurements before executive KPI packaging.

| Metric | Current location | Current purpose | Tanna category | Recommended future location |
|--------|------------------|-----------------|----------------|----------------------------|
| **Oil cumulative volume** | `l_pden_vol_summary.oil_cum_volume`, `marts.fact_production.oil_cum_volume` | Raw oil production measure | Signal | `tanna.signals.production.oil_cum_volume` |
| **Gas cumulative volume** | Same tables, `gas_cum_volume` | Raw gas production measure | Signal | `tanna.signals.production.gas_cum_volume` |
| **Water cumulative volume** | Same tables, `water_cum_volume` | Raw water production measure | Signal | `tanna.signals.production.water_cum_volume` |
| **BOE cumulative volume** | Same tables, `boe_cum_volume` | Barrels-of-oil-equivalent measure | Signal | `tanna.signals.production.boe_cum_volume` |
| **Essential coverage points** | `meta.dq_table_score.essential_*`, production coverage API (`/production/coverage`) | Count-based essential column presence (60-point scale) | Signal | `tanna.signals.governance.essential_coverage` |
| **Enhanced coverage points** | Production coverage API; `mart_contract_item.points` | Non-essential column presence (40-point scale) | Signal | `tanna.signals.governance.enhanced_coverage` |
| **DQ score (table-level)** | `meta.dq_table_score.dq_score`, `marts_governance.fact_dq_score.dq_score` | Weighted 60/40 quality score | Signal | `tanna.signals.governance.dq_score` |
| **Distinct PDEN count (period)** | Computed in KPI SQL over `marts.fact_production` | Well/PDEN count for utilization KPI | Signal | `tanna.signals.production.pden_count` |
| **Producing vs total wells** | KPI SQL in `ppdm-edip/apps/api/app/api/marts.py` | Inputs to utilization percentage | Signal | `tanna.signals.production.well_counts` |
| **Compliance score** | `ldv_platform.run_compliance` output (`report.score`) | Schema conformance score vs PPDM Lite (CLI; core module missing in repo) | Signal (planned) | `tanna.signals.compliance.schema_score` |
| **Mart refresh timestamp** | `marts.fact_production.refreshed_at` | Freshness indicator | Signal | `tanna.signals.platform.refresh_timestamp` |

---

## 9. KPIs

KPIs are named, defined executive indicators — usually aggregated metrics with business definitions.

### 9.1 Governance Platinum mart KPI catalog (`KPI_DEFINITIONS`)

**Current location:** `ppdm-edip/apps/api/app/api/marts.py` — exposed via `GET /v1/marts/production/kpis`  
**Current purpose:** TRD-aligned Production Performance mart (REQ-M-103, ≥12 KPIs)

| KPI ID | Name | Tanna category | Recommended future location |
|--------|------|----------------|----------------------------|
| `total_oil_mtd` | Total Oil MTD | Pattern (period aggregate) | `tanna.patterns.production.total_oil_mtd` |
| `total_gas_mtd` | Total Gas MTD | Pattern | `tanna.patterns.production.total_gas_mtd` |
| `boe_mtd` | BOE MTD | Pattern | `tanna.patterns.production.boe_mtd` |
| `total_oil_ytd` | Total Oil YTD | Pattern | `tanna.patterns.production.total_oil_ytd` |
| `yoy_growth_pct_oil` | YoY Growth % Oil | Pattern (comparative) | `tanna.patterns.production.yoy_growth_oil` |
| `production_per_well` | Production per Well | Pattern | `tanna.patterns.production.production_per_well` |
| `top_10_pdens_oil` | Top 10 PDENs by Oil | Pattern (ranking) | `tanna.patterns.production.top_pdens_oil` |
| `decline_rate_pct` | Decline Rate % | Pattern (comparative) | `tanna.patterns.production.decline_rate` |
| `utilization_pct` | Utilization % | Pattern | `tanna.patterns.production.utilization` |
| `forecast_vs_actual_pct` | Forecast vs Actual % | Pattern (placeholder; value always null today) | `tanna.patterns.production.forecast_vs_actual` |
| `production_by_field` | Production by Field | Pattern (dimensional breakdown) | `tanna.patterns.production.by_field` |
| `production_by_operator` | Production by Operator | Pattern (dimensional breakdown) | `tanna.patterns.production.by_operator` |

### 9.2 EDIP mart KPI response fields

**Current location:** `edip/apps/api/app/api/marts.py` — `GET /v1/marts/production/kpis` (auth required)  
**Current purpose:** Tenant-scoped production KPIs from `marts_production.fact_production`

| Field | Tanna category | Recommended future location |
|-------|----------------|----------------------------|
| `oil_mtd`, `gas_mtd`, `water_mtd`, `boe_mtd` | Pattern | `tanna.patterns.production.{metric}_mtd` |
| `oil_ytd`, `gas_ytd`, `boe_ytd` | Pattern | `tanna.patterns.production.{metric}_ytd` |
| `yoy_growth_pct`, `decline_rate_pct` | Pattern (often null in EDIP path today) | `tanna.patterns.production.{yoy,decline}` |
| `production_per_well` | Pattern | `tanna.patterns.production.production_per_well` |
| `top_pden_by_oil`, `production_by_operator` | Pattern (often empty in EDIP path today) | `tanna.patterns.production.{top_pdens,by_operator}` |

### 9.3 KPI definitions as knowledge

| Object | Current location | Current purpose | Tanna category | Recommended future location |
|--------|------------------|-----------------|----------------|----------------------------|
| **KPI definition metadata** | `definitions` array in governance KPI API response; UI "KPI Explain" copy on `/edip/executive` | Name, definition, unit for each KPI | Knowledge Asset | `tanna.knowledge_assets.kpi_definitions.production_performance` |
| **Specified KPIs for other marts** | `MART_STAR_SCHEMA_PACK.md` §2–§10 | 12+ KPIs per future mart | Knowledge Asset (planned) | `tanna.knowledge_assets.kpi_definitions.{mart_name}` |

---

## 10. Alerts

**Finding:** No alert, notification, threshold breach, or subscription objects are implemented in application source, database DDL, or portal UI. Requirements and TRD docs describe operational monitoring concepts but not persisted alert entities.

| Object | Current location | Current purpose | Tanna category | Recommended future location |
|--------|------------------|-----------------|----------------|----------------------------|
| **Alerts (none implemented)** | — | — | Signal / Decision Product (planned) | `tanna.signals.alerts.*` (future) |
| **DQ certification threshold (rule, not alert)** | DQ SQL in `jobs.py`, `compute_dq_scores.sql`; essential cap & ≥80 certification rule | Governance rule producing `certified_ind` boolean | Illumination (rule) | `tanna.illuminations.governance.certification_rule` |
| **Exception records (not push alerts)** | `l_ppdm_exception`, APIs `/v1/admin/exceptions`, `/v1/metadata/exceptions` | Stewardship queue data; no notification channel | Signal | `tanna.signals.exceptions.*` |

---

## 11. Workflows

Workflows are repeatable operational processes that move or validate information.

| Workflow | Current location | Current purpose | Tanna category | Recommended future location |
|----------|------------------|-----------------|----------------|----------------------------|
| **Ingest + publish job** | `POST /v1/jobs/run` (`ppdm-edip/apps/api/app/api/jobs.py`); TRD page `/edip/trd` | Creates `meta.ingest_run`, copies silver→Gold, writes lineage, computes DQ | Source → Data Product pipeline | `tanna.workflows.ingest_publish` |
| **EDIP platform bootstrap** | `edip/scripts/init/entrypoint.sh` (migrations, seeds, optional generator, dbt build) | Initializes EDIP DB schemas and marts | Data Product build | `tanna.workflows.platform_init` |
| **PPDM DB SQL init** | `ppdm-edip/infra/docker/migrations/init/*.sql` | Creates medallion schemas on first container start | Data Product build | `tanna.workflows.schema_init` |
| **dbt transform build** | `edip/dbt/edip_dbt/`; `RUN_DBT` env in entrypoint | Builds staging views and mart tables | Data Product build | `tanna.workflows.dbt_build` |
| **Contract catalog sync** | `06_contract_seed.sql` (information_schema → `l_ppdm_table`/`l_ppdm_column`) | Populates PPDM contract from live schema | Governance workflow | `tanna.workflows.contract_catalog_sync` |
| **Production CSV export** | `GET /v1/marts/production/export/csv` (`marts.py`); Reporting UI `/edip/reporting` | Download fact rows for offline analysis | Decision Product output | `tanna.workflows.report_export.csv` |
| **Compliance check CLI** | `ldv_platform/run_compliance.py` | Schema compliance scoring; optional MD/SQL outputs | Governance workflow (incomplete — missing `ldv_platform.core`) | `tanna.workflows.compliance.schema_check` |
| **Admin authentication for jobs** | `ppdm-edip/apps/api/app/auth.py`; `/edip/login` | Gates job execution to admin role | Platform workflow | `tanna.workflows.access.admin_job_gate` |
| **Scheduled report packs (specified)** | TRD § PDF/Excel packs | Planned batch reporting | Decision Product workflow (planned) | `tanna.workflows.report_pack.scheduled` |

---

## 12. Governance objects

Governance objects control quality, certification, mapping, and stewardship.

| Object | Current location | Current purpose | Tanna category | Recommended future location |
|--------|------------------|-----------------|----------------|----------------------------|
| **Essential policy** | `meta.essential_policy` (`07_essential_policy.sql`) | Column-level essential flags and reasons | Knowledge Asset → Governance | `tanna.knowledge_assets.policy.essential_columns` |
| **Mapping registry** | `meta.mapping_registry` | Source→target column maps with transform rules | Knowledge Asset → Governance | `tanna.knowledge_assets.registry.mapping` |
| **DQ table score** | `meta.dq_table_score` | Per-run, per-table DQ and certification | Signal → Illumination | `tanna.signals.governance.dq_table_score` |
| **Mart registry** | `meta.mart_registry` (EDIP) | Catalog of analytic marts | Knowledge Asset | `tanna.knowledge_assets.registry.marts` |
| **Mart contract item** | `meta.mart_contract_item` (EDIP) | Scoring contract linking Gold columns to marts | Knowledge Asset | `tanna.knowledge_assets.mart_contracts.items` |
| **Production mart certification** | `certified_ind` on DQ scores; `/v1/marts/production/coverage` | Boolean certification from 60/40 rules | Illumination | `tanna.illuminations.governance.mart_certification` |
| **Coverage breakdown (essential/enhanced/total)** | `/v1/marts/production/coverage` response | Interpreted coverage status for production mart | Illumination | `tanna.illuminations.governance.coverage_status` |
| **Data exceptions** | `l_ppdm_exception`, `meta.data_exception` | Stewardship findings tied to runs/tables | Signal | `tanna.signals.exceptions.stewardship` |
| **Ingest run audit trail** | `meta.ingest_run` + admin APIs `/v1/admin/runs` | Operational audit of pipeline executions | Data Product (audit) | `tanna.data_products.audit.ingest_run` |
| **Gold publish-only policy** | REQ-P-010 in requirements matrix | Rule: no UI/API edits to `ppdm_lite.*` | Knowledge Asset (policy) | `tanna.knowledge_assets.policy.gold_publish_only` |
| **Role-based access** | `security.roles` (tenant_admin, data_steward, executive_viewer, etc.) | Governance and viewing permissions | Knowledge Asset → Platform | `tanna.knowledge_assets.policy.roles` |

---

## 13. Metadata objects

Metadata describes structure, meaning, and catalog entries for data products.

| Object | Current location | Current purpose | Tanna category | Recommended future location |
|--------|------------------|-----------------|----------------|----------------------------|
| **PPDM contract table catalog** | `ppdm_lite.l_ppdm_table`; API `/v1/admin/contract/tables` | Registered Gold tables with comments | Knowledge Asset | `tanna.knowledge_assets.catalog.ppdm_tables` |
| **PPDM contract column catalog** | `ppdm_lite.l_ppdm_column`; API `/v1/admin/contract/tables/{name}/columns` | Column order and comments per table | Knowledge Asset | `tanna.knowledge_assets.catalog.ppdm_columns` |
| **Information schema dictionary** | EDIP `/v1/metadata/dictionary/tables`, `/columns`; portal `/edip/data-products` | Live schema/table/column discovery | Knowledge Asset | `tanna.knowledge_assets.catalog.live_dictionary` |
| **Schema manifest staging** | `stg_ppdm_lite__schema_manifest.sql` (dbt) | Generated manifest of expected PPDM columns | Knowledge Asset | `tanna.knowledge_assets.catalog.schema_manifest` |
| **Ingest source metadata** | `meta.ingest_source` fields (type, owner, connection_ref) | Source system descriptive metadata | Knowledge Asset → Source registry | `tanna.knowledge_assets.catalog.ingest_sources` |
| **Mart descriptions** | `meta.mart_registry.description`; dbt model docs (minimal) | Human-readable mart purpose | Knowledge Asset | `tanna.knowledge_assets.catalog.mart_descriptions` |
| **API-exposed table lists by schema** | Dictionary API schema filter: `ppdm_lite`, `marts_shared`, `marts_production`, `meta` | Scoped metadata views for stewards | Knowledge Asset | `tanna.knowledge_assets.catalog.schema_index` |

---

## 14. Lineage objects

Lineage objects record provenance from source columns to published targets.

| Object | Current location | Current purpose | Tanna category | Recommended future location |
|--------|------------------|-----------------|----------------|----------------------------|
| **Gold lineage edges** | `ppdm_lite.l_ppdm_origin` (source/target table+column, run_id) | Column-level publish lineage | Pattern (structural) → Knowledge Asset | `tanna.knowledge_assets.lineage.ppdm_origin` |
| **Meta lineage edges (EDIP)** | `meta.lineage_edge` (Alembic) | Alternate lineage store when Gold table unavailable | Knowledge Asset | `tanna.knowledge_assets.lineage.meta_edge` |
| **Job-written lineage (MVP)** | Created in `jobs.py` for `pden_staging` → `l_pden` columns | Demonstrates ingest lineage capture | Knowledge Asset | `tanna.knowledge_assets.lineage.ingest_mvp` |
| **Governance lineage API** | `GET /v1/marts/governance/lineage` (ppdm-edip) | Filterable edge list for governance UI | Pattern (graph access) | `tanna.patterns.lineage.governance_graph` |
| **Metadata lineage API** | `GET /v1/metadata/lineage` (both stacks) | Dictionary-adjacent lineage query | Pattern | `tanna.patterns.lineage.metadata_graph` |
| **Admin lineage API** | `GET /v1/admin/lineage` (ppdm-edip) | TRD warehouse console lineage panel | Pattern | `tanna.patterns.lineage.admin_graph` |
| **dbt lineage (implicit)** | dbt manifest in `edip/dbt/edip_dbt/target/` after build | Transform-level lineage (not exposed via portal API) | Knowledge Asset | `tanna.knowledge_assets.lineage.dbt_manifest` |

---

## 15. Reports

Reports are packaged or exportable information outputs (distinct from interactive dashboards).

| Object | Current location | Current purpose | Tanna category | Recommended future location |
|--------|------------------|-----------------|----------------|----------------------------|
| **Production mart CSV export** | `GET /v1/marts/production/export/csv`; triggered from `/edip/reporting` | Tabular export of fact rows for period/filters | Decision Product | `tanna.decision_products.reports.production_csv` |
| **Production drill-down fact extract** | `GET /v1/marts/production/facts` (drill-down rows) | Operator → Field → PDEN → Day fact detail | Decision Product (tabular) | `tanna.decision_products.reports.production_drilldown` |
| **Compliance markdown report** | `ldv_platform.run_compliance --report` (optional file output) | Human-readable schema compliance findings | Decision Product (planned) | `tanna.decision_products.reports.compliance_md` |
| **Compliance migration stub** | `run_compliance --migration` | SQL stub from compliance findings | Decision Product artifact (planned) | `tanna.decision_products.reports.compliance_migration_stub` |
| **PDF / Excel report packs (specified)** | `TRD_OIL_GAS_EXECUTIVE_BI_SUITE.md`, REQ matrix | Investor/monthly deck exports from Platinum marts | Decision Product (planned) | `tanna.decision_products.reports.executive_pack` |
| **PROJECT_CONTEXT.md** | Repo root | Factual system inventory (this analysis input) | Knowledge Asset | `tanna.knowledge_assets.documentation.project_context` |

---

## 16. Dashboards

Dashboards are interactive decision surfaces in the portal (primary) and legacy UIs.

| Dashboard | Current location | Current purpose | Data consumed | Tanna category | Recommended future location |
|-----------|------------------|-----------------|---------------|----------------|----------------------------|
| **Portal landing** | `portal/app/page.tsx` (`/`) | Module navigation hub | Static links | Decision Product (navigator) | `tanna.decision_products.dashboards.portal_home` |
| **Platform overview** | `portal/app/platform/page.tsx` | Architecture/services summary | Static | Decision Product | `tanna.decision_products.dashboards.platform_overview` |
| **EDIP workspace hub** | `portal/app/edip/page.tsx` | EDIP module index | Static | Decision Product | `tanna.decision_products.dashboards.edip_hub` |
| **Executive Intelligence** | `portal/app/edip/executive/page.tsx` | KPI tiles, trends, KPI Explain | `/api/edip/v1/marts/production/*` | Decision Product | `tanna.decision_products.dashboards.executive` |
| **Production explorer** | `portal/app/edip/production/page.tsx`, `[pdenId]/page.tsx` | PDEN search, volumes, detail | `/api/governance/v1/production/*` | Decision Product | `tanna.decision_products.dashboards.production_explorer` |
| **Reporting workspace** | `portal/app/edip/reporting/page.tsx` | KPI tiles, coverage, drill-down, CSV export | Governance marts API | Decision Product | `tanna.decision_products.dashboards.reporting` |
| **Governance console** | `portal/app/edip/governance/page.tsx` | DQ scores, certification, lineage, exceptions, contract catalog | Both APIs | Decision Product | `tanna.decision_products.dashboards.governance` |
| **TRD Warehouse console** | `portal/app/edip/trd/page.tsx` | Ingest runs, DQ, lineage, exceptions, job trigger | Governance admin API | Decision Product | `tanna.decision_products.dashboards.trd_warehouse` |
| **Compliance map** | `portal/app/edip/compliance/page.tsx`; `portal/components/Map.tsx` | Spatial asset visibility | `/api/governance/v1/spatial/*` | Decision Product | `tanna.decision_products.dashboards.compliance_spatial` |
| **Data Products browser** | `portal/app/edip/data-products/page.tsx` | Metadata dictionary tables | `/api/edip/v1/metadata/dictionary/*` | Decision Product | `tanna.decision_products.dashboards.data_products` |
| **Platform Services** | `portal/app/edip/platform-services/page.tsx` | Service/integration reference | Static | Decision Product | `tanna.decision_products.dashboards.platform_services` |
| **Login** | `portal/app/edip/login/page.tsx` | Admin token for job runs | Auth API | Decision Product (access gate) | `tanna.decision_products.dashboards.login` |
| **Legacy EDIP dashboard** | `edip/apps/web/src/app/dashboard/page.tsx` | Pre-portal executive view | Direct EDIP API | Decision Product (legacy) | `tanna.decision_products.dashboards.legacy_edip` |
| **Legacy warehouse UI** | `ppdm-edip/apps/web/app/warehouse/page.tsx` | Pre-portal TRD console | Direct governance API | Decision Product (legacy) | `tanna.decision_products.dashboards.legacy_warehouse` |
| **Legacy reporting UI** | `ppdm-edip/apps/web/app/reporting/page.tsx` | Pre-portal reporting | Direct governance API | Decision Product (legacy) | `tanna.decision_products.dashboards.legacy_reporting` |

---

## 17. Knowledge assets (cross-cutting)

Specification and institutional knowledge that outlive individual signal values.

| Asset | Current location | Current purpose | Tanna category | Recommended future location |
|-------|------------------|-----------------|----------------|----------------------------|
| **TRD Oil & Gas Executive BI Suite** | `ppdm-edip/docs/TRD_OIL_GAS_EXECUTIVE_BI_SUITE.md` | Target architecture, mart catalog, phased delivery | Knowledge Asset | `tanna.knowledge_assets.specifications.trd_bi_suite` |
| **Oil & Gas Executive BI Suite (product doc)** | `ppdm-edip/docs/OIL_GAS_EXECUTIVE_BI_SUITE.md` | Product/module narrative and scope | Knowledge Asset | `tanna.knowledge_assets.specifications.bi_suite` |
| **Requirements matrix** | `ppdm-edip/docs/REQUIREMENTS_MATRIX.md` | REQ-ID traceability (REQ-P, REQ-M, REQ-A, etc.) | Knowledge Asset | `tanna.knowledge_assets.specifications.requirements_matrix` |
| **Mart Star Schema Pack** | `ppdm-edip/docs/MART_STAR_SCHEMA_PACK.md` | Fact/dim columns, KPI formulas, 60/40 maps | Knowledge Asset | `tanna.knowledge_assets.specifications.mart_star_schema_pack` |
| **Spec alignment** | `ppdm-edip/docs/SPEC_ALIGNMENT.md` | Maps implementation to specifications | Knowledge Asset | `tanna.knowledge_assets.specifications.alignment` |
| **README / architecture narrative** | `README.md`, `ppdm-edip/README.md` | Operator-facing product description | Knowledge Asset | `tanna.knowledge_assets.documentation.readme` |
| **DQ scoring algorithm (embedded knowledge)** | `ppdm-edip/scripts/dq/compute_dq_scores.sql`, `_DQ_SQL` in `jobs.py` | 60/40 + essential cap rules | Knowledge Asset | `tanna.knowledge_assets.algorithms.dq_scoring` |
| **KPI formulas (embedded)** | `MART_STAR_SCHEMA_PACK.md` §1.3; inline SQL comments in `marts.py` | Business definitions for KPIs | Knowledge Asset | `tanna.knowledge_assets.kpi_definitions.*` |
| **PPDM Lite 1.1 DDL** | `ppdm-edip/scripts/init/ppdm_lite11_postgres_ddl.sql` | Canonical physical model | Knowledge Asset | `tanna.knowledge_assets.contracts.ppdm_lite_ddl` |

---

## 18. Dual-stack overlap and Tanna normalization

Several information objects exist in **both** EDIP and governance stacks with similar names but different storage:

| Concept | EDIP (`edip_db`) | Governance (`ppdm_db`) | Tanna normalization recommendation |
|---------|------------------|------------------------|-----------------------------------|
| Production KPIs | `marts_production.fact_production`; simpler API response | `marts.fact_production`; full 12 KPI catalog | Single **Pattern** namespace; tag with `backend=edip|governance` until unified |
| Lineage | `meta.lineage_edge` fallback | `ppdm_lite.l_ppdm_origin` primary | Single **Knowledge Asset** graph; merge edges by run_id |
| DQ scores | `marts_governance.fact_dq_score` | `meta.dq_table_score` | Single **Signal** type with `scope=mart|table` |
| PDEN entities | `marts_production.dim_pden` | `ppdm_lite.l_pden`, `marts.dim_pden` | Single **Entity** registry with layer tags |
| Metadata dictionary | information_schema via EDIP API | Contract catalog via admin API | Unified **Knowledge Asset** catalog federating live schema + PPDM contract |

---

## 19. Implementation vs specification gap (information-only)

These objects are **defined in knowledge assets** but **not present as runnable information** in the current codebase:

| Specified object | Documented in | Status |
|------------------|---------------|--------|
| 9 additional analytic marts (Well, Reserves, Land, Finance, Facility, Spatial, Governance, JV, Regulatory) | MART_STAR_SCHEMA_PACK, REQ-M-201–209 | Schemas declared in dbt_project; SQL models not materialized (except partial production/shared/governance) |
| PDF/Excel scheduled report packs | TRD | Not implemented |
| Alert / notification entities | — | Not implemented |
| SCADA / regulatory / partner feeds | REQ-P-001 | Not implemented |
| Full `ldv_platform.core` compliance engine | `run_compliance.py` imports | Missing module; CLI non-functional |
| EDIP DDL file for generator | `edip/scripts/ddl/` | README only; file not in repo |
| Root compose ppdm DB auto-init | Root `docker-compose.yml` | ppdm migrations may not run unless standalone compose used |

Gap items remain **Knowledge Assets (planned)** or **future Sources/Data Products** in Tanna — not current runtime information.

---

## 20. Master mapping summary

| Category | Count (approx.) | Primary Tanna layer | Notes |
|----------|-------------------|---------------------|-------|
| Sources | 10+ registered/planned types | Sources | MVP focuses on silver staging + ingest registry |
| Datasets | 6 layers + ~50 Gold tables + dbt staging | Data Products | Full PPDM Lite DDL is largest dataset |
| Marts | 1 Platinum + 1 EDIP production mart built; 10 specified | Data Products | Most mart domains exist only in specs |
| Entities | 15+ core business entities | Data Products | PDEN/volume/operator dominate APIs |
| Metrics | 10+ atomic measures | Signals | Volume and DQ dominate |
| KPIs | 12 defined (governance); 10+ fields (EDIP) | Patterns | Forecast KPI placeholder null |
| Alerts | 0 implemented | — | Certification rules exist; no alert channel |
| Workflows | 8 operational flows | Cross-layer | Ingest job is central |
| Governance objects | 11+ persisted types | Knowledge Assets + Illuminations | 60/40 DQ is core pattern |
| Metadata objects | 7 catalog types | Knowledge Assets | Contract + dictionary dual view |
| Lineage objects | 3 stores + 3 APIs | Knowledge Assets + Patterns | Column-level provenance |
| Reports | 2 live exports + 3 planned | Decision Products | CSV is primary today |
| Dashboards | 12 portal + 3 legacy pages | Decision Products | Portal is canonical UX |

---

## 21. Answer: what information exists in this system?

At a glance, the PETRO Reporting Interface contains:

1. **Upstream and landing information** — ingest source registry, bronze file records, silver staging tables, and referenced PPDM Lite schema contracts.  
2. **Published petroleum data** — a full PPDM Lite Gold entity model (production, land, reserves, seismic, spatial, governance tables), conformed dimensions, and one operational Production Performance mart (Platinum in ppdm-edip; dbt marts in EDIP).  
3. **Measurement and quality signals** — volume facts, DQ scores, coverage points, exceptions, and computed KPI values.  
4. **Aggregated patterns** — MTD/YTD totals, YoY and decline comparisons, top-N PDEN rankings, operator/field breakdowns, and lineage edge graphs.  
5. **Interpreted illuminations** — mart certification status, essential/enhanced coverage interpretation, and KPI explain metadata (partial in UI).  
6. **Decision surfaces** — portal dashboards for executive, production, reporting, governance, TRD, compliance, and metadata browsing; CSV export reports.  
7. **Institutional knowledge** — PPDM contract catalogs, mapping/essential policy, mart registry, TRD/requirements/star-schema specifications, and embedded DQ/KPI algorithms.

That corpus is what a **Tanna `petro-reporting` module** would register, federate across the dual backends, and expose through the intelligence hierarchy — without yet prescribing how to implement the merge.

---

*Document generated from repository inspection. No code was modified.*
