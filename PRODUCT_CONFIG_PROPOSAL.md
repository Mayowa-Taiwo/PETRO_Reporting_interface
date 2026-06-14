# Product Configuration Proposal

**Repository:** PETRO Reporting Interface  
**Target artifact:** `/products/[product].config.ts` (proposed)  
**Purpose:** Isolate everything **unique to this product** from everything **reusable across Tanna modules**.  
**Basis:** Source inspection, TRD/spec docs, API definitions, portal routes, seed data.  
**Out of scope:** Generic UI components (`TannaKpiCard`, `TannaDataTable`, etc.), framework choices, Docker, JWT mechanics.

---

## 1. Product identity (→ `product.config.ts`)

| Field | Proposed value | Source / rationale |
|-------|----------------|-------------------|
| **Product name** | `PETRO Reporting Interface` | README, portal landing |
| **Product short name** | `PETRO` | Portal breadcrumb, landing eyebrow |
| **Product slug** | `petro-reporting` | Tanna module id; petroleum reporting domain |
| **Product domain** | `oil-and-gas-executive-intelligence` | TRD: Oil & Gas Executive BI Reporting Suite; PPDM Lite consumption |
| **Product tagline** | `Unified petroleum reporting & executive intelligence` | `portal/app/page.tsx` |
| **Workspace name** | `EDIP Workspace` | EDIP nav shell (`EdipNav.tsx`) |
| **Workspace acronym** | `EDIP` | Executive Decision Intelligence Platform (legacy EDIP web metadata) |
| **Reference standard** | `PPDM Lite 1.1 (PostgreSQL)` | Gold consumption contract across TRD, migrations, compliance |
| **Medallion model** | `Bronze → Silver → Gold (PPDM Lite) → Platinum (star marts)` | TRD Section 0, SQL init scripts |

### Submodule names (product vocabulary, not separate products in UI)

| Internal module | User-facing label | Role |
|-----------------|-------------------|------|
| EDIP stack | Executive Intelligence / Reporting | dbt marts, tenant-scoped EDIP API |
| Governance / TRD stack | TRD Warehouse, Governance | ppdm-edip API, ingest, Platinum production mart |
| LDV Platform Core | Platform Services | Python compliance/domain helpers (no standalone UI) |

---

## 2. Primary users (→ `product.config.ts`)

Derived from TRD primary users + seeded RBAC roles.

| Persona ID | Display name | Description | Typical decisions |
|------------|--------------|-------------|-------------------|
| `executive_viewer` | Executive Viewer | E&P leadership, COO/CEO office | Portfolio production performance, trends, YoY |
| `analyst` | Analyst | Production / asset analysts | Drill-down, rollups, CSV export |
| `finance_analyst` | Finance Analyst | Finance / IR | YTD volumes, operator breakdowns (future finance mart) |
| `geo_analyst` | Geo Analyst | Geoscience / spatial | Spatial asset layers, compliance map |
| `data_steward` | Data Steward | Metadata, DQ, lineage, exceptions | Certification, contract coverage, exception triage |
| `tenant_admin` | Tenant Administrator | Tenant + platform admin | User access, job stewardship |
| `warehouse_admin` | Warehouse Admin | Ingest / TRD ops | Run ingest jobs, monitor runs (governance `admin` role) |
| `api_client` | API Client | Programmatic consumers | Mart KPI API integration |

**Primary user summary (marketing):** Private E&P leadership and functional teams — Executive, Asset, Operations, Finance, Land/Legal, Geoscience, IR — plus Data Stewardship and Platform Ops (TRD §0).

---

## 3. Primary decisions (→ `product.config.ts`)

Decisions this product is built to support — not generic platform decisions.

| Decision ID | Decision question | Supported by |
|-------------|-------------------|--------------|
| `production_performance` | How is the company producing this month/quarter/year (oil, gas, BOE)? | Executive, Reporting KPIs |
| `asset_contribution` | Which PDENs, fields/pools, and operators drive production? | Production explorer, rollups, top-10 KPI |
| `production_trend` | Is production growing, flat, or declining? | YoY growth %, decline rate %, BOE trend |
| `well_utilization` | What share of wells are actively producing? | Utilization % KPI |
| `mart_trust` | Is the production mart certified and fit for executive use? | Coverage scoring, certification badge |
| `data_quality` | Which tables/columns fail stewardship rules? | DQ scores, exception monitor |
| `provenance` | Where did published Gold/mart data come from? | Lineage edges, ingest runs |
| `publish_readiness` | Is it safe to run ingest and publish to PPDM Lite? | TRD job run, mapping registry |
| `regulatory_visibility` | Where are spatial/regulatory assets on the map? | Compliance spatial explorer |
| `schema_conformance` | Does a client schema meet PPDM Lite governance expectations? | LDV compliance CLI (referenced in UI) |

---

## 4. Core entities (→ `product.config.ts`)

Product-domain entities — not generic `User` or `Tenant` (those are platform).

| Entity ID | Display name | Natural key | Primary tables / APIs | Notes |
|-----------|--------------|-------------|------------------------|-------|
| `pden` | PDEN (Production Entity) | `pden_id` + `pden_type` + `pden_source` | `l_pden`, `dim_pden`, `/v1/production/pdens` | Central reporting unit (well, facility, etc.) |
| `pden_volume` | PDEN Volume Summary | PDEN keys + `volume_date` + `volume_method` + `activity_type` | `l_pden_vol_summary`, `fact_production` | Production time series |
| `well` | Well | `uwi`, well ids | `l_well`, spatial `l_well_point` | Linked to PDEN via UWI |
| `field_pool` | Field / Pool | `pool_id`, `field_id` | `l_pool`, `dim_field_pool` | Rollup dimension |
| `operator` | Operator | `operator_id` | `dim_operator` | Attribution for production |
| `product` | Hydrocarbon Product | `product_code` | `dim_product` | Oil, gas, water, BOE |
| `ingest_source` | Ingest Source | `source_id` | `meta.ingest_source` | Upstream feed registry |
| `ingest_run` | Ingest Run | `run_id` | `meta.ingest_run` | Pipeline execution audit |
| `spatial_layer` | Spatial Layer | `layer_id` (`source_table_geom_type`) | `edip_feature_geom`, `/v1/spatial/layers` | GIS feature collections |
| `ppdm_table` | PPDM Contract Table | `table_name` | `l_ppdm_table` | Schema contract catalog |
| `ppdm_column` | PPDM Contract Column | `table_name` + `column_name` | `l_ppdm_column` | Column-level contract |
| `data_exception` | Data Exception | `exception_id` | `l_ppdm_exception`, `meta.data_exception` | Validation/stewardship finding |
| `lineage_edge` | Lineage Edge | source/target column + `run_id` | `l_ppdm_origin`, `meta.lineage_edge` | Column provenance |
| `mart` | Analytic Mart | `mart_id` | `meta.mart_registry`, `marts_*` | e.g. `production` |

**Drill-down path (product-specific navigation semantics):**

```text
Operator → Field/Pool → PDEN → Day
```

(REQ-R-002, Reporting page copy)

---

## 5. Core metrics (→ `product.config.ts`)

Atomic measures before KPI packaging.

| Metric ID | Display name | Unit family | Source columns |
|-----------|--------------|-------------|----------------|
| `oil_cum_volume` | Oil (cumulative) | volume | `fact_production`, `l_pden_vol_summary` |
| `gas_cum_volume` | Gas (cumulative) | volume | same |
| `water_cum_volume` | Water (cumulative) | volume | same |
| `boe_cum_volume` | BOE (cumulative) | volume | same |
| `essential_coverage_pct` | Essential coverage | percent | DQ / coverage APIs |
| `enhanced_coverage_pct` | Enhanced coverage | percent | same |
| `essential_points` | Essential points | points (0–60) | `/v1/marts/production/coverage` |
| `enhanced_points` | Enhanced points | points (0–40) | same |
| `total_coverage_points` | Total coverage | points (0–100) | same |
| `dq_score` | DQ score | score (0–100) | `meta.dq_table_score`, `fact_dq_score` |
| `pden_count` | PDEN count | count | Production KPI API |
| `oil_cum_total` | Oil cumulative total | volume | Gold rollup API |

**Volume methods / activity types (enumerations):** `volume_method` (e.g. measured, estimated), `activity_type` (e.g. production, injection) — per Mart Star Schema Pack.

---

## 6. KPI catalog (→ `product.config.ts`)

Product-specific **Patterns** — implemented in `KPI_DEFINITIONS` (governance API).

| KPI ID | Name | Formula (summary) | Unit |
|--------|------|-------------------|------|
| `total_oil_mtd` | Total Oil MTD | Sum oil for selected month | volume |
| `total_gas_mtd` | Total Gas MTD | Sum gas for selected month | volume |
| `boe_mtd` | BOE MTD | Sum BOE for selected month | volume |
| `total_oil_ytd` | Total Oil YTD | Sum oil for selected year | volume |
| `yoy_growth_pct_oil` | YoY Growth % Oil | (This year − Last year) / Last year × 100 | percent |
| `production_per_well` | Production per Well | BOE MTD / distinct PDEN count | volume |
| `top_10_pdens_oil` | Top 10 PDENs by Oil | Rank PDENs by oil volume | list |
| `decline_rate_pct` | Decline Rate % | (Prior − Current) / Prior × 100 | percent |
| `utilization_pct` | Utilization % | Producing wells / Total wells × 100 | percent |
| `forecast_vs_actual_pct` | Forecast vs Actual % | Actual / Forecast × 100 | percent |
| `production_by_field` | Production by Field | Sum by field/pool | breakdown |
| `production_by_operator` | Production by Operator | Sum by operator | breakdown |

**EDIP API variant metrics** (same product, alternate backend): `oil_mtd`, `gas_mtd`, `water_mtd`, `boe_mtd`, `oil_ytd`, `gas_ytd`, `boe_ytd` — should map to same KPI IDs in config with backend alias.

**Planned mart KPIs (spec-only, not implemented):** Well Performance, Reserves, Land & Contract, Financial, Facility, Spatial, Governance, JV, Regulatory — per `MART_STAR_SCHEMA_PACK.md` §2–§10.

---

## 7. Governance rules (→ `product.config.ts`)

Product-specific quality and certification semantics.

| Rule ID | Name | Definition |
|---------|------|------------|
| `coverage_60_40` | 60/40 coverage model | 60 points essential + 40 points enhanced from PPDM Lite column presence |
| `certification_production` | Production mart certification | Certified when essential ≥ 60 pts **and** total ≥ 80 pts (REQ-M-105) |
| `dq_score_60_40` | DQ score weighting | 60% essential column validity + 40% optional; essential cap at 59 if essential coverage < 90% |
| `gold_publish_only` | Gold publish-only | `ppdm_lite.*` is publish-only; no UI/API edits (REQ-P-010) |
| `production_mart_grain` | Production mart grain | One row per PDEN × volume_date × volume_method × activity_type |

**Registered mart (implemented):**

| mart_id | mart_name | schema_name | description |
|---------|-----------|-------------|-------------|
| `production` | Production Performance | `marts_production` | Production volumes by PDEN |

**Planned marts (config placeholders):** `well_performance`, `reserves`, `land_contract`, `finance`, `facility`, `spatial`, `governance`, `jv`, `regulatory`.

---

## 8. Data sources (→ `product.config.ts`)

Logical sources this product understands — not connection strings.

| Source ID | Display name | Layer | Status | Description |
|-----------|--------------|-------|--------|-------------|
| `demo_upstream` | Demo Upstream | ingest | **seeded** | `meta.ingest_source` seed (`Demo Upstream`) |
| `bronze_file_landing` | Bronze file landing | bronze | implemented | `bronze.ingest_file` append-only |
| `silver_pden_staging` | Silver PDEN staging | silver | implemented | `silver.pden_staging` |
| `silver_pden_vol_staging` | Silver volume staging | silver | implemented | `silver.pden_vol_staging` |
| `ppdm_lite_gold` | PPDM Lite 1.1 Gold | gold | implemented | Full `ppdm_lite` schema |
| `platinum_production_mart` | Production Performance Mart | platinum | implemented | `marts.fact_production` (governance) / `marts_production.*` (EDIP) |
| `ppdm_master` | PPDM master systems | upstream | specified | REQ-P-001 |
| `csv_feeds` | CSV file feeds | upstream | specified | REQ-P-001 |
| `scada` | SCADA / operations feeds | upstream | specified | REQ-P-001 |
| `regulatory_feeds` | Regulatory submissions | upstream | specified | REQ-P-001 |
| `partner_feeds` | Partner / JV feeds | upstream | specified | REQ-P-001 |
| `client_schema_json` | Client schema snapshot | compliance | partial | LDV compliance CLI input |

**Internal data planes (product wiring, not upstream sources):**

| Plane ID | API proxy | Database |
|----------|-----------|----------|
| `edip` | `/api/edip` | `edip_db` |
| `governance` | `/api/governance` | `ppdm_db` |

---

## 9. Connector types (→ `product.config.ts`)

Product-specific ingest connector taxonomy (from TRD / requirements).

| Connector type ID | Display name | Target layer | REQ reference |
|-------------------|--------------|--------------|---------------|
| `ppdm_master` | PPDM Master | bronze | REQ-P-001 |
| `csv` | CSV / flat file | bronze | REQ-P-001 |
| `scada` | SCADA | bronze | REQ-P-001 |
| `regulatory` | Regulatory feed | bronze | REQ-P-001 |
| `partner` | Partner / JV feed | bronze | REQ-P-001 |
| `silver_staging` | Silver conformed staging | silver | REQ-P-003 |
| `mapping_registry_publish` | Mapping registry publish | gold | REQ-P-008 |
| `dbt_transform` | dbt mart build | platinum | EDIP init pipeline |
| `client_schema` | Client schema compliance | compliance | LDV Platform |

**Ingest job modes (product):** `full_refresh`, `incremental`.

---

## 10. Navigation items (→ `product.config.ts`)

Current product navigation — **not** generic Tanna layer nav (that is platform).

### 10.1 Portal landing sections (`/`)

| nav_id | label | route | description |
|--------|-------|-------|-------------|
| `executive` | Executive Intelligence | `/edip/executive` | Executive BI, KPI tiles, trends, production dashboards |
| `production` | Production Intelligence | `/edip/production` | PDEN explorer, volumes, rollups |
| `reporting` | Reporting | `/edip/reporting` | Drill-downs, exports, performance dashboards |
| `governance` | Governance | `/edip/governance` | DQ certification, lineage, exceptions |
| `trd` | TRD Warehouse | `/edip/trd` | Ingest runs, contract catalog, stewardship jobs |
| `compliance` | Compliance | `/edip/compliance` | Spatial assets, schema compliance |
| `platform` | LDV Platform Core | `/platform` | Python core services (no separate web app) |

### 10.2 EDIP workspace nav (`EdipNav`)

| nav_id | label | route | exact |
|--------|-------|-------|-------|
| `overview` | Overview | `/edip` | yes |
| `executive` | Executive | `/edip/executive` | |
| `production` | Production | `/edip/production` | |
| `reporting` | Reporting | `/edip/reporting` | |
| `governance` | Governance | `/edip/governance` | |
| `trd` | TRD Warehouse | `/edip/trd` | |
| `compliance` | Compliance | `/edip/compliance` | |
| `data_products` | Data Products | `/edip/data-products` | |
| `platform_services` | Platform Services | `/edip/platform-services` | |

### 10.3 Auth route

| nav_id | label | route | gate |
|--------|-------|-------|------|
| `sign_in` | Sign in | `/edip/login` | Required for TRD job run |

### 10.4 Mapping to Tanna platform navigation (→ platform config, not product)

Product config should store **`tannaSection`** hints for migration only:

| Product nav_id | Tanna section |
|----------------|---------------|
| `overview` | Overview |
| `executive`, `reporting` | Decision Products |
| `production`, `data_products`, `compliance` (map) | Data Products |
| `governance` (lineage) | Traceability |
| `governance` (certification) | Illuminations |
| `trd` | Administration + Sources |
| `platform`, `platform_services` | Knowledge Assets |

---

## 11. Decision products (→ `product.config.ts`)

User-facing outputs that drive decisions — dashboards, workspaces, exports.

| ID | Name | Route | Primary API endpoints | Outputs |
|----|------|-------|----------------------|---------|
| `executive_dashboard` | Executive Intelligence | `/edip/executive` | `/v1/marts/production/kpis`, `/pdens`, `/timeseries` | KPI tiles, BOE trend, PDEN table |
| `production_explorer` | Production Intelligence | `/edip/production`, `/edip/production/[pdenId]` | `/v1/production/pdens`, `/kpis`, `/rollups`, `/volumes` | PDEN list, pool rollups, volume detail |
| `reporting_workspace` | Reporting Workspace | `/edip/reporting` | `/v1/marts/production/kpis`, `/coverage`, `/data`, `/export/csv` | KPI grid, certification, drill-down, CSV |
| `governance_console` | Governance | `/edip/governance` | `/v1/governance/dq-scores`, `/marts/governance/lineage`, `/metadata/exceptions`, `/admin/contract/tables` | DQ cards, lineage, exceptions, catalog |
| `trd_warehouse` | TRD Warehouse | `/edip/trd` | `/v1/jobs/runs`, `/admin/dq/scores`, `/admin/lineage`, `/admin/exceptions`, `POST /jobs/run` | Runs, DQ, lineage, job control |
| `compliance_spatial` | Compliance & Regulatory Intelligence | `/edip/compliance` | `/v1/spatial/layers`, `/layers/{id}/features` | Spatial map, CLI reference |
| `data_products_browser` | Data Products | `/edip/data-products` | `/v1/metadata/dictionary/tables` | Schema/table catalog |

**Export products:**

| ID | Name | Format | Trigger |
|----|------|--------|---------|
| `production_csv_export` | Production mart export | CSV | Reporting Export CSV button |

**Planned (spec only):** PDF/Excel investor report packs (TRD § Product C).

---

## 12. Knowledge assets (→ `product.config.ts`)

Institutional knowledge **about this product domain** — references and catalogs, not generic docs platform.

| Asset ID | Title | Location | Type |
|----------|-------|----------|------|
| `trd_bi_suite` | TRD Oil & Gas Executive BI Suite | `ppdm-edip/docs/TRD_OIL_GAS_EXECUTIVE_BI_SUITE.md` | specification |
| `bi_suite_product` | Oil & Gas Executive BI Suite | `ppdm-edip/docs/OIL_GAS_EXECUTIVE_BI_SUITE.md` | product doc |
| `requirements_matrix` | Requirements Matrix | `ppdm-edip/docs/REQUIREMENTS_MATRIX.md` | traceability |
| `mart_star_schema_pack` | Mart Star Schema Pack | `ppdm-edip/docs/MART_STAR_SCHEMA_PACK.md` | mart definitions |
| `spec_alignment` | Spec Alignment | `ppdm-edip/docs/SPEC_ALIGNMENT.md` | alignment |
| `ppdm_lite_ddl` | PPDM Lite 1.1 DDL | `ppdm-edip/scripts/init/ppdm_lite11_postgres_ddl.sql` | schema contract |
| `kpi_definitions_production` | Production KPI definitions | `ppdm-edip/apps/api/app/api/marts.py` `KPI_DEFINITIONS` | embedded catalog |
| `mart_contract_production` | Production mart contract items | `edip/scripts/seed/seed_roles_tenant_user.sql` | scoring map |
| `essential_policy` | Essential column policy | `ppdm-edip/infra/docker/migrations/init/07_essential_policy.sql` | policy |
| `mapping_registry` | Column mapping registry | `meta.mapping_registry` | transform map |
| `ppdm_contract_catalog` | PPDM contract tables/columns | `l_ppdm_table`, `l_ppdm_column` | live catalog |
| `ldv_compliance_cli` | LDV compliance CLI | `python -m ldv_platform.run_compliance` | operator reference |
| `project_context` | Project context inventory | `PROJECT_CONTEXT.md` | as-built inventory |

**In-UI knowledge surfaces:** Platform Services page, Compliance CLI block, Governance contract table, KPI definition footnotes on Reporting.

---

## 13. Business vocabulary (→ `product.config.ts`)

Domain glossary — product language, not UI labels.

| Term | Definition | Aliases |
|------|------------|---------|
| **PDEN** | Production Entity — reporting unit for volumes (well, facility, etc.) | Production Entity |
| **UWI** | Unique Well Identifier | |
| **BOE** | Barrels of oil equivalent | |
| **PPDM Lite** | Lightweight PPDM warehouse consumption model (Gold layer) | Gold |
| **Platinum mart** | Star-schema analytic mart built on Gold | Modular BI data mart |
| **Bronze / Silver / Gold** | Medallion layers: raw → conformed → publish | |
| **TRD** | Technical Requirements Document alignment for warehouse core | |
| **EDIP** | Executive Decision Intelligence Platform workspace | |
| **Coverage (essential / enhanced)** | 60/40 point model for PPDM column presence | 60–40 scoring |
| **Certified** | Mart meets essential ≥60 and total ≥80 coverage rule | Certification |
| **DQ score** | Weighted quality score (60% essential + 40% optional columns) | |
| **Lineage** | Column-level provenance from source to Gold/mart | `L_PPDM_ORIGIN` |
| **Exception** | Validation or stewardship finding logged to exception table | |
| **Ingest run** | Single pipeline execution from source through publish | |
| **Volume method** | How volume was determined (measured, estimated, …) | |
| **Activity type** | Production activity (production, injection, …) | |
| **Operator** | Company operating the asset | |
| **Field / Pool** | Geological field or pool grouping for rollups | Field-Pool |
| **Spatial layer** | GIS feature set (wells, land polygons) | |
| **Contract catalog** | `L_PPDM_TABLE` / `L_PPDM_COLUMN` schema registry | PPDM contract |
| **LDV Platform** | Shared Python core for compliance and domain logic | |
| **KPI Explain** | Panel showing definition, lineage, DQ, refresh for a KPI | REQ-R-004 |

---

## 14. Brand language (→ `product.config.ts`)

Product-specific voice, naming, and visual identity tokens — not generic design system.

### 14.1 Naming hierarchy

| Level | String |
|-------|--------|
| Company / suite | PETRO Reporting Interface |
| Short | PETRO |
| Workspace | EDIP Workspace |
| Backend labels | EDIP API, Governance API, LDV Platform Core |
| Standard cite | PPDM Lite 1.1, TRD-aligned warehouse |

### 14.2 Voice & copy patterns

| Context | Example copy |
|---------|--------------|
| Landing eyebrow | `PETRO REPORTING INTERFACE` (uppercase tracking) |
| Hero | `Unified petroleum reporting & executive intelligence` |
| Workspace intro | `Primary executive intelligence and reporting workspace` |
| Governance | `EDIP Governance Layer — DQ certification, lineage, exceptions, and PPDM contract catalog` |
| TRD | `TRD-aligned warehouse core — ingest runs, DQ scoring, lineage, exceptions, and stewardship jobs` |
| Compliance | `Spatial asset visibility and schema compliance workflows` |
| Open browse | `Browsing is open. Starting jobs requires admin sign-in` |
| Certification positive | `Certified` (emerald) |
| Certification negative | `Not certified` (amber) |
| Empty mart | `No rows. Adjust filters or ensure Platinum mart is populated.` |

### 14.3 Product theme tokens (not generic `@tanna/ui`)

| Token | Value | Usage |
|-------|-------|-------|
| `accent` | emerald (`emerald-400` / `emerald-600`) | CTA, active nav, export button |
| `shellDark` | slate-950 / slate-900 | Portal landing, EDIP header |
| `workspaceLight` | slate-50 background, white panels | EDIP workspace pages |
| `certified` | emerald-100 / emerald-800 | Status badge |
| `uncertified` | amber-100 / amber-800 | Status badge |

---

## 15. What belongs in `/products/petro-reporting.config.ts`

**Include** everything in sections 1–14 above: identity, personas, decisions, entities, metrics, KPIs, governance rules, sources, connectors, nav, decision products, knowledge asset refs, glossary, brand.

**Also include (product wiring):**

```typescript
// Illustrative — not generated code, proposal only
export const petroReportingConfig = {
  id: "petro-reporting",
  api: {
    edip: { proxyPath: "/api/edip", defaultBase: "http://127.0.0.1:8000" },
    governance: { proxyPath: "/api/governance", defaultBase: "http://127.0.0.1:8007" },
  },
  auth: {
    tokenKey: "edip_token", // product-chosen key today; may move to platform
    adminGateActions: ["jobs.run"],
    demoCredentials: {
      governance: { username: "admin", password: "change-me" },
      edip: { email: "admin@demo.edip.local", password: "demo123" },
    },
  },
  schemas: {
    gold: "ppdm_lite",
    platinum: "marts",
    edipMarts: "marts_production",
  },
  // ...sections 4–14 as structured arrays
};
```

---

## 16. What belongs elsewhere (NOT product config)

Clear separation from reusable platform / design system.

| Belongs in | Examples from this repo |
|-----------|-------------------------|
| **`@tanna/ui` / design system** | KPI card layout, data tables, lineage table, map component, filter bar, sign-in form layout, loading/empty states |
| **`@tanna/platform` / shell** | Tanna nav layers (Overview, Sources, Signals, …), module router, JWT library, `apiFetch` helper, tenant model |
| **`@tanna/connectors` (generic)** | Connector runtime, file landing engine, dbt runner, job scheduler |
| **Infrastructure** | Docker compose, PostgreSQL, Redis, Alembic, Next.js, FastAPI, PostGIS, Leaflet, Recharts |
| **Cross-product standards** | PPDM Lite DDL file *could* be shared if multiple petroleum products exist — this product **references** it via `knowledgeAssets.ppdmLiteVersion` |
| **Generic RBAC** | JWT creation, `HTTPBearer`, password hashing |
| **Legacy app duplication** | Separate `ClientNav` link sets for deprecated frontends |

**Rule of thumb:** If another Tanna module (e.g. finance, healthcare) could reuse it unchanged, it is **not** product config.

---

## 17. Uniqueness summary — what makes this product distinct

1. **PPDM Lite 1.1 as the Gold contract** — petroleum warehouse consumption model with built-in governance tables (`L_PPDM_*`).
2. **Medallion + Platinum mart architecture** — Bronze/Silver/Gold/Platinum with **60/40 coverage certification** unique to this suite.
3. **PDEN-centric production intelligence** — KPIs, drill-down, and rollups anchored on Production Entities, not generic facts.
4. **Dual-plane implementation** — EDIP (tenant dbt marts) + Governance/TRD (ingest + Platinum) unified under one portal.
5. **Oil & gas KPI catalog** — 12+ production KPIs (MTD/YTD/YoY/decline/utilization/top PDEN) with Mart Star Schema Pack formulas.
6. **TRD warehouse stewardship** — ingest runs, mapping registry, column lineage, exception monitor as first-class workflows.
7. **Spatial + schema compliance** — PostGIS asset explorer plus PPDM Lite schema compliance CLI narrative.
8. **E&P persona model** — executive, analyst, geo, steward, warehouse admin roles tied to E&P decisions.
9. **Brand: PETRO / EDIP** — petroleum executive intelligence positioning, emerald accent, unified workspace shell.

---

## 18. Proposed config file location

```text
/products/
  petro-reporting.config.ts    ← all section 15 content
  index.ts                     ← registry of product configs (platform)
```

Legacy repo folders (`edip/`, `ppdm-edip/`, `portal/`) remain **implementations**; the config file is the **declarative product definition** for Tanna module loading.

---

*Document generated from project analysis. No code was modified.*
