# Requirements Matrix — Oil & Gas Executive BI Reporting Suite

| REQ-ID | Requirement summary | Priority | Owner | Acceptance test |
|--------|----------------------|----------|--------|------------------|
| **Platform — Bronze / Silver / Gold** |
| REQ-P-001 | Bronze layer: raw ingestion from PPDM master, CSV, SCADA, regulatory, partner feeds into append-only storage | Must | Data Engineering | Run ingestion job; verify rows in bronze schema; file registry and ingest logs populated |
| REQ-P-002 | Bronze: file registry stores path, checksum, load time | Must | Data Engineering | Query registry; assert one row per landed file with non-null checksum and load time |
| REQ-P-003 | Silver: canonical staging with typed columns, dedupe by business key, reference value harmonization | Must | Data Engineering | Silver table has expected types; duplicate business keys removed; reference codes mapped |
| REQ-P-004 | Silver: unit normalization (oil/gas/water/BOE) via UOM dimension and conversion table | Must | Data Engineering | Volume columns in standard UOM; conversion table used in transform |
| REQ-P-005 | Silver: multi-currency to reporting currency via FX rate table | Must | Data Engineering | Finance/cost amounts in reporting currency; FX table joined in transform |
| REQ-P-006 | Silver: standard time zone (UTC or tenant default) for all dates | Must | Data Engineering | All date/timestamp columns in target time zone |
| REQ-P-007 | Silver: validation failures logged to exception table (table, column, rule, message, severity, run_id) | Must | Data Engineering | Invalid row triggers insert into exception table with run_id |
| REQ-P-008 | Gold: ELT from Silver using mapping_registry (source_table/column → target_table/column) | Must | Data Engineering | Publish job uses mapping_registry; target PPDM Lite tables populated |
| REQ-P-009 | Gold: L_PPDM_DATA_SOURCE populated; row-level DATA_SOURCE set consistently | Must | Data Stewardship | Query Gold; DATA_SOURCE non-null and matches ingest source |
| REQ-P-010 | Gold: no UI edits; PPDM Lite is publish-only | Must | Platform | No API or UI allows INSERT/UPDATE/DELETE on ppdm_lite.* |
| **Marts — Production (4.1)** |
| REQ-M-101 | Production mart: star schema with fact_production (≥20 cols) and dims (dim_pden, dim_date, dim_product, dim_operator, dim_field_pool) | Must | Data Engineering | fact_production has ≥20 columns; each dim has ≥10 columns; FK relationships valid |
| REQ-M-102 | Production mart: grain = one row per PDEN per volume_date per volume_method per activity_type | Must | Data Engineering | Count distinct (pden_key, date_key, volume_method, activity_type) = count(*) on fact |
| REQ-M-103 | Production mart: 12+ KPIs defined and exposed via API | Must | Product | GET /v1/marts/production/kpis returns ≥12 KPI definitions/values |
| REQ-M-104 | Production mart: 100-point coverage scoring (60 essential / 40 enhanced) implemented and auditable | Must | Data Stewardship | Coverage score computed from L_PDEN + L_PDEN_VOL_SUMMARY columns; 60/40 split documented |
| REQ-M-105 | Production mart: certified when essential coverage ≥60 pts and total ≥80 (or equivalent rule) | Must | Data Stewardship | Certification flag set per TRD rule; API returns certification status |
| **Marts — Wells (4.2) through Regulatory (4.10)** |
| REQ-M-201 | Well Performance mart: star schema, grain, 12+ KPIs, 60–40 coverage | Must | Data Engineering | Schema and KPIs per Mart Star Schema Pack §2 |
| REQ-M-202 | Reserves mart: star schema, grain, 12+ KPIs, 60–40 coverage | Must | Data Engineering | Schema and KPIs per Mart Star Schema Pack §3 |
| REQ-M-203 | Land & Contract mart: star schema, grain, 12+ KPIs, 60–40 coverage | Must | Data Engineering | Schema and KPIs per Mart Star Schema Pack §4 |
| REQ-M-204 | Financial & Cost mart: star schema, grain, 12+ KPIs, 60–40 coverage | Must | Data Engineering | Schema and KPIs per Mart Star Schema Pack §5 |
| REQ-M-205 | Facility Utilization mart: star schema, grain, 12+ KPIs, 60–40 coverage | Must | Data Engineering | Schema and KPIs per Mart Star Schema Pack §6 |
| REQ-M-206 | Spatial Intelligence mart: star schema, grain, 12+ KPIs, 60–40 coverage | Must | Data Engineering | Schema and KPIs per Mart Star Schema Pack §7 |
| REQ-M-207 | Governance & DQ mart: star schema, grain, 12+ KPIs, 60–40 coverage | Must | Data Engineering | Schema and KPIs per Mart Star Schema Pack §8 |
| REQ-M-208 | Partner/JV Entitlements mart: star schema, grain, 12+ KPIs, 60–40 coverage | Must | Data Engineering | Schema and KPIs per Mart Star Schema Pack §9 |
| REQ-M-209 | Regulatory/Compliance mart: star schema, grain, 12+ KPIs, 60–40 coverage | Must | Data Engineering | Schema and KPIs per Mart Star Schema Pack §10 |
| **Conformed dimensions** |
| REQ-D-001 | Shared dim_date, dim_operator, dim_asset, dim_location, dim_product, dim_contract, dim_facility, dim_project | Must | Data Engineering | All 8 dimensions exist; referenced by ≥2 marts; SCD strategy as specified |
| REQ-D-002 | Conformed dimensions built from PPDM Lite sources per TRD Section 5 mapping | Must | Data Engineering | Lineage/documentation shows dim columns sourced from L_* tables |
| **Reporting app (first-party)** |
| REQ-R-001 | React/Next.js reporting portal with KPI tiles, trends, pivots, maps | Must | Frontend | Log in; view dashboard with tiles and at least one trend and one map |
| REQ-R-002 | Drill-down path: Operator → Asset/Field/Pool → Well/PDEN → Day/Month | Must | Frontend | Navigate from operator to PDEN to daily data without error |
| REQ-R-003 | Report Builder: save views, schedule exports | Should | Frontend | Save a view; schedule export; export runs and delivers file |
| REQ-R-004 | KPI Explain panel: definition + lineage + DQ score + last refresh | Should | Frontend | Click KPI; panel shows definition, lineage, DQ score, refresh time |
| REQ-R-005 | Admin screens: exceptions, certification status, metadata dictionary | Must | Frontend | Data steward can view exception list, certification status, and table/column list |
| REQ-R-006 | Export: CSV/Excel and PDF packs (investor-ready) | Must | Backend | API or UI generates CSV, Excel, and PDF pack from Platinum data |
| **Security & governance** |
| REQ-S-001 | RBAC roles: admin, analyst, viewer, finance_analyst, geo_analyst, data_steward, api_client | Must | Backend | Each role exists; permission matrix enforced on API and UI |
| REQ-S-002 | Tenant isolation via RLS (or schema-per-tenant / db-per-tenant per tier) | Must | Backend | Two tenants cannot see each other’s data in shared DB + RLS |
| REQ-S-003 | JWT for API authentication | Must | Backend | Unauthenticated request returns 401; valid token returns 200 for allowed resource |
| REQ-S-004 | RLS on Platinum (and optionally Gold) for multi-tenant and JV/partner | Must | Backend | RLS policies applied; partner sees only entitled rows |
| REQ-S-005 | Audit logs: exports, KPI definition changes, certification approvals | Should | Backend | Log table or service contains export and approval events |
| REQ-S-006 | Certification status driven by 100-point scoring; approval workflow for KPI definitions | Should | Product | Certification badge reflects score; KPI change requires approval in workflow |
| **Metadata & catalog** |
| REQ-MD-001 | Data dictionary from L_PPDM_TABLE, L_PPDM_COLUMN + information_schema | Must | Backend | API returns table/column list with types and comments |
| REQ-MD-002 | Lineage from L_PPDM_ORIGIN (and platform logs): source→target, impact analysis | Must | Backend | Lineage API returns graph; impact analysis returns downstream objects for a source |
| REQ-MD-003 | Exception monitor: aggregate L_PPDM_EXCEPTION by table/column/run/date; trends | Must | Backend | Dashboard or API returns exception counts and trend by table/run |
| REQ-MD-004 | Per-mart YAML/JSON metadata export (tables, columns, definitions, KPIs, lineage) | Should | Backend | Export produces valid YAML/JSON per TRD Section 6 example |
| **API & commercial** |
| REQ-A-001 | REST API: /v1/marts/production/kpis, /v1/marts/contracts/exposure, /v1/marts/governance/lineage, /v1/marts/jv/entitlements | Must | Backend | Each endpoint returns 200 and expected structure for authorized caller |
| REQ-A-002 | Licensing tiers: Core (Production + 2 marts), Advanced (10 marts + API), Enterprise (white-label + SLA) | Should | Product | Feature flags or tenant config enforce mart access by tier |
| REQ-A-003 | Per-mart activation (modular subscription) | Should | Backend | Tenant config enables subset of marts; API returns only enabled marts |
| REQ-A-004 | White-label: per-tenant theme (logo, colors, typography) | Could | Frontend | Tenant A and B see different logo/theme when logging in |
| **Non-functional** |
| REQ-N-001 | Performance: P95 < 3s for uncached module pages | Should | Backend | Load test; 95th percentile response time < 3s for key module page |
| REQ-N-002 | Caching for heavy KPIs (Redis or equivalent) | Should | Backend | KPI endpoint response time improves on second call (cache hit) |
| REQ-N-003 | Idempotent job runs; run tracking; rollback strategy | Must | Data Engineering | Re-run same job; no duplicate keys; run history queryable; rollback procedure documented |
| REQ-N-004 | Observability: logs, run metrics, error tracing | Must | Platform | Logs and metrics available; errors traceable to run_id and step |
| REQ-N-005 | Scalability: partitioning, caching, isolation support tenant growth | Should | Platform | Design doc describes partitioning and isolation approach for N tenants |
| **Acceptance — MVP** |
| REQ-ACC-MVP-1 | Bronze→Silver pipeline operational | Must | Data Engineering | End-to-end test: land file → Silver table populated |
| REQ-ACC-MVP-2 | Gold (PPDM Lite) publish job runs successfully | Must | Data Engineering | Publish job completes; target L_* tables updated; lineage written |
| REQ-ACC-MVP-3 | Production mart (4.1) star schema, KPI endpoints, coverage scoring + certification | Must | Data Engineering | fact_production + dims deployed; /v1/marts/production/kpis works; score and certification returned |
| REQ-ACC-MVP-4 | Web portal: KPI tiles, drilldown to PDEN/day, CSV export | Must | Frontend | User sees tiles, drills to PDEN/day, exports CSV successfully |
| REQ-ACC-MVP-5 | RBAC + tenant isolation functional | Must | Backend | Two roles and two tenants; access restricted per role and tenant |
| **Acceptance — V1** |
| REQ-ACC-V1-1 | ≥10 marts fully implemented | Must | Data Engineering | All 10 marts in Mart Star Schema Pack deployed and queryable |
| REQ-ACC-V1-2 | Conformed dimensions shared across marts | Must | Data Engineering | Same dim_date/dim_operator etc. used by ≥2 marts |
| REQ-ACC-V1-3 | Governance mart with lineage + exceptions dashboards | Must | Frontend | Governance module shows lineage and exception trends |
| REQ-ACC-V1-4 | Orchestration (Airflow or equivalent) in place | Must | Data Engineering | DAG runs ingestion → Silver → Gold → Platinum; run history visible |
| REQ-ACC-V1-5 | Report Builder + scheduled packs | Should | Frontend | User can build report, save, and schedule pack delivery |
| **Acceptance — V2** |
| REQ-ACC-V2-1 | White-label tiering implemented | Could | Product | Enterprise tenant has custom branding |
| REQ-ACC-V2-2 | Predictive/risk add-ons integrated | Could | Data Engineering | At least one mart has predictive or risk KPI using model output |
| REQ-ACC-V2-3 | Compliance mart expanded; full metadata catalog and certification workflows | Could | Product | Compliance mart enhanced; catalog and certification workflow documented and used |

**Priority legend:** Must = P0, Should = P1, Could = P2.  
**Owner:** Data Engineering, Frontend, Backend, Platform, Data Stewardship, Product as assigned.
