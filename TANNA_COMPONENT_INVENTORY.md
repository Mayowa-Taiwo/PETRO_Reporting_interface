# Tanna Component Inventory

**Product:** PETRO Reporting Interface  
**Document purpose:** Identify reusable UI patterns across all frontends and propose shared building blocks for a future Tanna design system.  
**Scope:** `portal/`, `edip/apps/web/`, `ppdm-edip/apps/web/` (36 TSX files inspected).  
**Out of scope:** Code changes, implementation of a component library.

---

## 1. Executive summary

There is **no shared component library** today. Only **three extracted components** exist (`EdipNav`, `Map`, `ClientNav`). Everything else is **inline JSX + Tailwind** duplicated across pages — often **copy-pasted verbatim** between portal and legacy ppdm-edip (especially Reporting).

**Highest-value extractions for Tanna design system:**

| Pattern | Occurrences | Candidate name |
|---------|-------------|----------------|
| KPI metric tile | 4 pages | `TannaKpiCard` |
| Mart / DQ score card | 3 pages | `TannaSignalCard` |
| Generic data table | 20+ instances | `TannaDataTable` |
| Lineage edge table | 6 pages | `TannaLineageTable` |
| Certification badge | 3 pages | `TannaStatusBadge` |
| Reporting filter bar | 2 pages (duplicate) | `TannaFilterBar` |
| Ingest job form | 2 pages | `TannaJobRunForm` |
| Leaflet map | 2 files (duplicate) | `TannaGeoMap` |
| Module nav shell | 3 nav components | `TannaModuleNav` |

### Reusability score rubric

| Score | Meaning |
|-------|---------|
| **5** | Already a shared file **or** near-identical in 3+ places — extract immediately |
| **4** | Duplicated 2+ times with minor prop differences — strong shared candidate |
| **3** | Repeated pattern with moderate variation — abstract with configurable columns/slots |
| **2** | Single use but generic shape — extract when design system matures |
| **1** | Page-specific layout or marketing content — low priority |

---

## 2. Extracted components (existing shared files)

### 2.1 `EdipNav` — Module navigation shell

| Field | Value |
|-------|--------|
| **File location** | `portal/components/EdipNav.tsx` |
| **Purpose** | EDIP workspace header: PETRO breadcrumb, workspace title, primary nav links, sign-in/out |
| **Inputs** | `pathname` (via `usePathname`); token presence via `getToken()` |
| **Outputs** | Rendered header + nav; `removeToken()` on sign out; links to 9 workspace routes |
| **Reusability score** | **4** |
| **Candidate shared component name** | `TannaModuleNav` |

**Notes:** Active-link logic (`isActive`) is reusable. Nav items are hard-coded — future version should accept `navItems[]` from Tanna module config.

---

### 2.2 `ClientNav` — Legacy compact nav (×2)

| Field | EDIP legacy | ppdm-edip legacy |
|-------|-------------|------------------|
| **File location** | `edip/apps/web/src/components/ClientNav.tsx` | `ppdm-edip/apps/web/components/ClientNav.tsx` |
| **Purpose** | Horizontal nav + login/logout in legacy app headers | Same |
| **Inputs** | Token in `localStorage` | Same |
| **Outputs** | Links (different per app); logout → `/login` | Same |
| **Reusability score** | **4** (merge into one parameterized nav) |
| **Candidate shared component name** | `TannaModuleNav` (legacy variant) |

---

### 2.3 `Map` — Leaflet GeoJSON map (×2)

| Field | Portal | ppdm-edip |
|-------|--------|-----------|
| **File location** | `portal/components/Map.tsx` | `ppdm-edip/apps/web/components/Map.tsx` |
| **Purpose** | Render OpenStreetMap + point markers from GeoJSON FeatureCollection | Same |
| **Inputs** | `geojson: MapFeatureCollection \| null` | Same |
| **Outputs** | Full-size map div; marker popups with `source_pk` | Same |
| **Reusability score** | **5** (duplicate files ~95% identical) |
| **Candidate shared component name** | `TannaGeoMap` |

**Gap:** Points only; no polygon rendering despite API supporting polygon layers.

---

## 3. Cards

### 3.1 Production KPI Card (click-to-explain)

| Field | Value |
|-------|--------|
| **File locations** | `portal/app/edip/executive/page.tsx` (lines ~64–80); `edip/apps/web/src/app/dashboard/page.tsx` (~67–83); `portal/app/edip/reporting/page.tsx` (~207–225); `ppdm-edip/apps/web/app/reporting/page.tsx` (~207–225) |
| **Purpose** | Display one KPI label + formatted value; optional expand for definition/explain |
| **Inputs** | `id`, `label`, `value` (number \| string \| null); optional `definition`, `unit`; `onExplainToggle` |
| **Outputs** | Click toggles inline explain panel (Executive/Dashboard); Reporting shows definition always |
| **Reusability score** | **5** |
| **Candidate shared component name** | `TannaKpiCard` |

**Maps from:** Production KPI Card → **Shared KPI Card**

---

### 3.2 Reporting KPI Card (definition always visible)

| Field | Value |
|-------|--------|
| **File locations** | `portal/app/edip/reporting/page.tsx`; `ppdm-edip/apps/web/app/reporting/page.tsx` |
| **Purpose** | KPI tile with name, computed value (per `def.id` switch), and definition footnote |
| **Inputs** | `definition: { id, name, definition, unit }`, `values: Record<string, unknown>`, `year`, `month` |
| **Outputs** | Static card; no click interaction |
| **Reusability score** | **5** (merge with `TannaKpiCard` via `variant="detailed"`) |
| **Candidate shared component name** | `TannaKpiCard` |

---

### 3.3 DQ Score / Mart Certification Card

| Field | Value |
|-------|--------|
| **File locations** | `portal/app/edip/governance/page.tsx` (~48–64); `edip/apps/web/src/app/governance/page.tsx` (~34–50) |
| **Purpose** | Mart-level DQ summary: mart id, certification badge, essential/enhanced/DQ percentages |
| **Inputs** | `{ mart_id, essential_coverage_pct, enhanced_coverage_pct, dq_score, certified_ind, computed_at? }` |
| **Outputs** | Visual card; no actions |
| **Reusability score** | **5** |
| **Candidate shared component name** | `TannaSignalCard` |

**Maps from:** DQ Score Card → **Shared Signal Card**

---

### 3.4 Production summary stat card

| Field | Value |
|-------|--------|
| **File locations** | `portal/app/edip/production/page.tsx` (~35–48); `ppdm-edip/apps/web/app/production/page.tsx` (~33–46) |
| **Purpose** | Large number + caption (PDEN count, oil total, gas total) |
| **Inputs** | `value: number`, `label: string` |
| **Outputs** | Static stat display |
| **Reusability score** | **4** |
| **Candidate shared component name** | `TannaStatCard` |

---

### 3.5 Module area link card

| Field | Value |
|-------|--------|
| **File locations** | `portal/app/page.tsx` (~66–75); `portal/app/edip/page.tsx` (~24–33) |
| **Purpose** | Navigable card with title + blurb linking to workspace area |
| **Inputs** | `href`, `title`, `description` |
| **Outputs** | Next.js `Link` navigation |
| **Reusability score** | **4** |
| **Candidate shared component name** | `TannaAreaCard` |

**Variants:** Dark theme (landing `/`) vs light theme (`/edip`).

---

### 3.6 Platform / service info card

| Field | Value |
|-------|--------|
| **File locations** | `portal/app/platform/page.tsx` (~17–38); `portal/app/edip/platform-services/page.tsx` (~13–24); `portal/app/edip/compliance/page.tsx` (~43–54) |
| **Purpose** | Bordered content block for static documentation (service description, CLI instructions) |
| **Inputs** | `title`, `children` (prose, code, links) |
| **Outputs** | Static display; optional link |
| **Reusability score** | **3** |
| **Candidate shared component name** | `TannaInfoCard` |

---

### 3.7 Entity attribute card (definition list)

| Field | Value |
|-------|--------|
| **File locations** | `portal/app/edip/production/[pdenId]/page.tsx` (~59–70); `ppdm-edip/apps/web/app/production/[pdenId]/page.tsx` (~51–58) |
| **Purpose** | Two-column `<dl>` of PDEN metadata fields |
| **Inputs** | `fields: { label, value }[]` or entity record |
| **Outputs** | Read-only attribute panel |
| **Reusability score** | **4** |
| **Candidate shared component name** | `TannaEntityDetailCard` |

---

## 4. Tables

All tables share the same **visual recipe**: `border table-auto w-full text-sm`, header row `bg-slate-100`, cells `p-2`, optional `font-mono text-xs`. None use a table library (@tanstack/react-table is only in node_modules, unused).

### 4.1 Generic data table (configurable columns)

| Field | Value |
|-------|--------|
| **File locations** | Used on 15+ pages (Production, Reporting, Governance, TRD, Warehouse, Admin, Metadata, Data Products) |
| **Purpose** | Tabular display of API rows with sticky header variant on scrollable catalogs |
| **Inputs** | `columns: { key, header, align?, render? }[]`, `rows: Record<string, unknown>[]`, `maxHeight?`, `emptyMessage?` |
| **Outputs** | HTML table; optional row links |
| **Reusability score** | **5** |
| **Candidate shared component name** | `TannaDataTable` |

---

### 4.2 PDEN list table

| Field | Value |
|-------|--------|
| **File locations** | `portal/app/edip/executive/page.tsx`; `portal/app/edip/production/page.tsx`; `edip/apps/web/src/app/dashboard/page.tsx`; `ppdm-edip/apps/web/app/production/page.tsx` |
| **Purpose** | List PDEN entities with id, type, name, product, UWI; Production adds "Volumes" link column |
| **Inputs** | `pdens[]`, `showLinkColumn?: boolean`, `linkBasePath?` |
| **Outputs** | Table rows; link to `/production/[pdenId]` |
| **Reusability score** | **5** |
| **Candidate shared component name** | `TannaPdenTable` (extends `TannaDataTable`) |

---

### 4.3 Volume / fact data table

| Field | Value |
|-------|--------|
| **File locations** | `portal/app/edip/production/[pdenId]/page.tsx`; `portal/app/edip/reporting/page.tsx` (drill-down); `ppdm-edip/apps/web/app/production/[pdenId]/page.tsx`; `ppdm-edip/apps/web/app/reporting/page.tsx` |
| **Purpose** | Time-series volumes or mart fact rows with numeric formatting |
| **Inputs** | Volume rows or `DataRow[]` with date, volumes, method, activity |
| **Outputs** | Table; Reporting links PDEN id to detail route |
| **Reusability score** | **4** |
| **Candidate shared component name** | `TannaFactTable` |

---

### 4.4 Rollup / breakdown table

| Field | Value |
|-------|--------|
| **File locations** | `portal/app/edip/production/page.tsx` (by pool); `portal/app/edip/reporting/page.tsx` (by operator, top-10 PDENs); ppdm equivalents |
| **Purpose** | Aggregated metrics by dimension |
| **Inputs** | `groupKey`, numeric totals, dimension labels |
| **Outputs** | Static summary table |
| **Reusability score** | **4** |
| **Candidate shared component name** | `TannaBreakdownTable` |

---

### 4.5 Ingest runs table

| Field | Value |
|-------|--------|
| **File locations** | `portal/app/edip/trd/page.tsx`; `ppdm-edip/apps/web/app/warehouse/page.tsx` |
| **Purpose** | Show run_id (truncated), status, started_at |
| **Inputs** | `{ run_id, status, started_at }[]` |
| **Outputs** | Read-only audit table |
| **Reusability score** | **5** |
| **Candidate shared component name** | `TannaRunTable` |

---

### 4.6 DQ scores table (table-level)

| Field | Value |
|-------|--------|
| **File locations** | `portal/app/edip/trd/page.tsx`; `ppdm-edip/apps/web/app/warehouse/page.tsx` |
| **Purpose** | Latest DQ score per target table with certified Yes/No |
| **Inputs** | `{ target_table, dq_score, certified_ind }[]` (deduped by `latestDqPerTable`) |
| **Outputs** | Read-only table |
| **Reusability score** | **5** |
| **Candidate shared component name** | `TannaDqScoreTable` |

---

### 4.7 Sources registry table

| Field | Value |
|-------|--------|
| **File locations** | `ppdm-edip/apps/web/app/admin/page.tsx` (~96–113) |
| **Purpose** | List ingest sources: name, type, truncated id |
| **Inputs** | `{ source_id, source_name, source_type }[]` |
| **Outputs** | Read-only table |
| **Reusability score** | **4** |
| **Candidate shared component name** | `TannaSourceTable` |

---

## 5. Charts

### 5.1 BOE trend line chart

| Field | Value |
|-------|--------|
| **File locations** | `portal/app/edip/executive/page.tsx` (~84–98); `edip/apps/web/src/app/dashboard/page.tsx` (~87–101) |
| **Purpose** | Time-series line chart of BOE production |
| **Inputs** | `timeseries: { date, oil?, gas?, boe }[]`, `dataKey?` (default `boe`), `title?` |
| **Outputs** | Recharts `LineChart` inside fixed-height container |
| **Dependencies** | `recharts` (portal + edip web only; not in ppdm-edip web) |
| **Reusability score** | **4** |
| **Candidate shared component name** | `TannaTrendChart` |

**Gap:** Only one chart type in the entire codebase; Reporting has no charts.

---

## 6. Maps

### 6.1 Spatial layer selector + map layout

| Field | Value |
|-------|--------|
| **File locations** | `portal/app/edip/compliance/page.tsx` (~56–77); `ppdm-edip/apps/web/app/spatial/page.tsx` (~37–55) |
| **Purpose** | Radio list of layers + map viewport |
| **Inputs** | `layers[]`, `selectedLayerId`, `onLayerChange`, `geojson` → `Map` |
| **Outputs** | Layer selection state; renders `TannaGeoMap` |
| **Reusability score** | **4** |
| **Candidate shared component name** | `TannaSpatialExplorer` |

**Composition:** Layer panel (inline) + `Map` component.

---

## 7. Forms

### 7.1 Sign-in form (governance — username)

| Field | Value |
|-------|--------|
| **File locations** | `portal/app/edip/login/page.tsx`; `ppdm-edip/apps/web/app/login/page.tsx` |
| **Purpose** | Username/password login; JWT stored in `localStorage` |
| **Inputs** | User credentials; `POST /v1/auth/login` |
| **Outputs** | Token via `setToken()`; redirect to `/edip/trd` or `/` |
| **Reusability score** | **4** |
| **Candidate shared component name** | `TannaSignInForm` |

---

### 7.2 Sign-in form (EDIP — email)

| Field | Value |
|-------|--------|
| **File locations** | `edip/apps/web/src/app/login/page.tsx` |
| **Purpose** | Email/password login to EDIP API |
| **Inputs** | `{ email, password }` |
| **Outputs** | Token; redirect to `/dashboard` |
| **Reusability score** | **4** (merge with `TannaSignInForm` via `authMode: "email" \| "username"`) |
| **Candidate shared component name** | `TannaSignInForm` |

---

### 7.3 Ingest job run form

| Field | Value |
|-------|--------|
| **File locations** | `portal/app/edip/trd/page.tsx` (~97–131); `ppdm-edip/apps/web/app/admin/page.tsx` (~60–92) |
| **Purpose** | Select source + mode; trigger `POST /v1/jobs/run` |
| **Inputs** | `sources[]`, `runBody: { source_id, mode }`, auth token |
| **Outputs** | `runResult` message string; optional run_id feedback |
| **Reusability score** | **5** |
| **Candidate shared component name** | `TannaJobRunForm` |

---

## 8. Filters

### 8.1 Reporting period selector (year / month)

| Field | Value |
|-------|--------|
| **File locations** | `portal/app/edip/reporting/page.tsx` (~171–202); `ppdm-edip/apps/web/app/reporting/page.tsx` |
| **Purpose** | Filter KPI API by calendar period |
| **Inputs** | `year`, `month`, `onYearChange`, `onMonthChange`, `onRefresh` |
| **Outputs** | Triggers KPI reload |
| **Reusability score** | **5** |
| **Candidate shared component name** | `TannaPeriodFilter` |

---

### 8.2 Mart drill-down filter bar

| Field | Value |
|-------|--------|
| **File locations** | `portal/app/edip/reporting/page.tsx` (~235–297); `ppdm-edip/apps/web/app/reporting/page.tsx` |
| **Purpose** | Filter fact rows: operator_key, field_pool_key, pden_id, from/to date |
| **Inputs** | Filter state object; `onApply`, `onExportCsv` |
| **Outputs** | Updates fact table query; CSV download |
| **Reusability score** | **5** (duplicate files) |
| **Candidate shared component name** | `TannaFilterBar` |

---

### 8.3 Spatial layer filter (radio group)

| Field | Value |
|-------|--------|
| **File locations** | Compliance + Spatial pages (see §6.1) |
| **Purpose** | Single-select layer id |
| **Inputs** | `layers[]`, `selected`, `onChange` |
| **Outputs** | Fetches GeoJSON for selected layer |
| **Reusability score** | **3** |
| **Candidate shared component name** | `TannaLayerSelector` |

---

## 9. Search panels

**Finding:** No dedicated search panel component exists in any frontend. The production API supports `?q=` search (`/v1/production/pdens`), but **no UI exposes a search input**.

| Field | Value |
|-------|--------|
| **File locations** | — (not implemented) |
| **Purpose** | Would filter PDEN list by id, name, or UWI |
| **Inputs** | (planned) `query`, `onSearch`, debounce |
| **Outputs** | (planned) Filtered entity list |
| **Reusability score** | **2** (needed for Tanna Data Products explorer) |
| **Candidate shared component name** | `TannaSearchPanel` |

**Recommendation:** Introduce as net-new shared component when consolidating Production pages.

---

## 10. Status indicators

### 10.1 Certification badge

| Field | Value |
|-------|--------|
| **File locations** | `portal/app/edip/reporting/page.tsx` (~156–166); `portal/app/edip/governance/page.tsx` (~52–56); `edip/apps/web/src/app/governance/page.tsx` (~37–41) |
| **Purpose** | Visual certified / not certified state |
| **Inputs** | `certified: boolean`, optional `label?` |
| **Outputs** | Pill badge (`bg-emerald-100` vs `bg-amber-100`) |
| **Reusability score** | **5** |
| **Candidate shared component name** | `TannaStatusBadge` |

**Variants:** Text "Certified" / "Not certified" (Reporting, Governance cards) vs "Yes" / "No" (DQ table cells in TRD/Warehouse).

---

### 10.2 Coverage points summary

| Field | Value |
|-------|--------|
| **File locations** | `portal/app/edip/reporting/page.tsx` (~158–160) |
| **Purpose** | Inline text: total / essential / enhanced coverage points |
| **Inputs** | `{ essential_points, enhanced_points, total_points }` |
| **Outputs** | Text next to certification badge |
| **Reusability score** | **3** |
| **Candidate shared component name** | `TannaCoverageSummary` |

---

### 10.3 Run / job result message

| Field | Value |
|-------|--------|
| **File locations** | `portal/app/edip/trd/page.tsx` (~131); `ppdm-edip/apps/web/app/admin/page.tsx` (~92) |
| **Purpose** | Feedback after job submit or auth failure |
| **Inputs** | `message: string \| null`, `variant?: "success" \| "error" \| "info"` |
| **Outputs** | Inline `<p>` text |
| **Reusability score** | **3** |
| **Candidate shared component name** | `TannaAlertInline` |

---

### 10.4 Loading state

| Field | Value |
|-------|--------|
| **File locations** | All data-fetching pages (15+) |
| **Purpose** | Plain-text loading placeholder |
| **Inputs** | `message?: string` |
| **Outputs** | `<p>Loading…</p>` variants |
| **Reusability score** | **5** |
| **Candidate shared component name** | `TannaLoadingState` |

---

### 10.5 Empty state

| Field | Value |
|-------|--------|
| **File locations** | Reporting (no rows), Governance (no DQ), Data Products (no tables), Warehouse (no lineage), etc. |
| **Purpose** | Explain absence of data |
| **Inputs** | `message: string`, optional `action?` |
| **Outputs** | Muted text paragraph |
| **Reusability score** | **4** |
| **Candidate shared component name** | `TannaEmptyState` |

---

## 11. Lineage views

### 11.1 Lineage edge table (3-column)

| Field | Value |
|-------|--------|
| **File locations** | `portal/app/edip/governance/page.tsx` (~69–94); `portal/app/edip/trd/page.tsx` (~182–201); `ppdm-edip/apps/web/app/warehouse/page.tsx` (~112–131) |
| **Purpose** | Column-level provenance: source → target + run id |
| **Inputs** | `edges: { source_table(_name), source_column(_name), target_table(_name), target_column(_name), run_id? }[]`, `limit?` |
| **Outputs** | Read-only table; monospace column paths |
| **Reusability score** | **5** |
| **Candidate shared component name** | `TannaLineageTable` |

**Maps from:** Lineage Table → **Shared Traceability Component**

---

### 11.2 Lineage edge table (4-column, metadata)

| Field | Value |
|-------|--------|
| **File locations** | `edip/apps/web/src/app/metadata/page.tsx` (~54–77) |
| **Purpose** | Separate columns for source/target table and column (no run id column) |
| **Inputs** | Same edge shape without run emphasis |
| **Outputs** | Scrollable table |
| **Reusability score** | **5** (same component, column config) |
| **Candidate shared component name** | `TannaLineageTable` |

---

## 12. Metadata views

### 12.1 Schema dictionary table

| Field | Value |
|-------|--------|
| **File locations** | `portal/app/edip/data-products/page.tsx`; `edip/apps/web/src/app/metadata/page.tsx` |
| **Purpose** | Browse tables by schema + table name from information_schema API |
| **Inputs** | `{ schema, table }[]` |
| **Outputs** | Scrollable sticky-header table |
| **Reusability score** | **5** |
| **Candidate shared component name** | `TannaMetadataDictionary` |

---

### 12.2 PPDM contract catalog table

| Field | Value |
|-------|--------|
| **File locations** | `portal/app/edip/governance/page.tsx` (~121–144); `ppdm-edip/apps/web/app/admin/page.tsx` (~115–132) |
| **Purpose** | List `l_ppdm_table` entries with comments |
| **Inputs** | `{ table_name, table_comment }[]` |
| **Outputs** | Scrollable table |
| **Reusability score** | **5** |
| **Candidate shared component name** | `TannaContractCatalog` |

---

### 12.3 Exception monitor table

| Field | Value |
|-------|--------|
| **File locations** | `portal/app/edip/governance/page.tsx` (~97–118); `portal/app/edip/trd/page.tsx` (~204–225); `ppdm-edip/apps/web/app/warehouse/page.tsx` (~134–155) |
| **Purpose** | Stewardship exceptions: table, type, message, optional date |
| **Inputs** | Exception records from API |
| **Outputs** | Truncated message column |
| **Reusability score** | **5** |
| **Candidate shared component name** | `TannaExceptionTable` |

---

## 13. Navigation components

### 13.1 Product landing CTA

| Field | Value |
|-------|--------|
| **File locations** | `portal/app/page.tsx` (~57–62) |
| **Purpose** | Primary emerald button into EDIP workspace |
| **Inputs** | `href`, `label` |
| **Outputs** | Navigation |
| **Reusability score** | **2** |
| **Candidate shared component name** | `TannaPrimaryButton` |

---

### 13.2 Breadcrumb / back link

| Field | Value |
|-------|--------|
| **File locations** | `EdipNav` (PETRO / EDIP); `portal/app/platform/page.tsx`; PDEN detail `← Production`; Reporting → Production links |
| **Purpose** | Hierarchical orientation and upward navigation |
| **Inputs** | `segments[]` or `href` + label |
| **Outputs** | Link navigation |
| **Reusability score** | **4** |
| **Candidate shared component name** | `TannaBreadcrumb` / `TannaBackLink` |

---

### 13.3 Legacy app header shell

| Field | Value |
|-------|--------|
| **File locations** | `edip/apps/web/src/app/layout.tsx`; `ppdm-edip/apps/web/app/layout.tsx` |
| **Purpose** | Dark header with logo + `ClientNav` |
| **Inputs** | `children` |
| **Outputs** | Page layout wrapper |
| **Reusability score** | **4** |
| **Candidate shared component name** | `TannaAppShell` |

---

### 13.4 EDIP workspace layout shell

| Field | Value |
|-------|--------|
| **File locations** | `portal/app/edip/layout.tsx` |
| **Purpose** | Wraps all `/edip/*` pages with `EdipNav` + constrained main |
| **Inputs** | `children` |
| **Outputs** | Layout |
| **Reusability score** | **4** |
| **Candidate shared component name** | `TannaModuleLayout` |

---

## 14. Admin components

### 14.1 Job run panel (composed)

| Field | Value |
|-------|--------|
| **File locations** | `portal/app/edip/trd/page.tsx` (section ~97–132); merges form + auth hint + result |
| **Purpose** | Bordered admin section for ingest stewardship |
| **Inputs** | Composes `TannaJobRunForm`, sign-in link, `TannaAlertInline` |
| **Outputs** | Job execution workflow |
| **Reusability score** | **4** |
| **Candidate shared component name** | `TannaAdminJobPanel` |

---

### 14.2 Warehouse monitoring dashboard (composed)

| Field | Value |
|-------|--------|
| **File locations** | `portal/app/edip/trd/page.tsx`; `ppdm-edip/apps/web/app/warehouse/page.tsx` |
| **Purpose** | Stack of runs + DQ + lineage + exceptions tables |
| **Inputs** | Multiple admin API responses |
| **Outputs** | Read-only operational dashboard |
| **Reusability score** | **5** |
| **Candidate shared component name** | `TannaWarehouseMonitor` |

---

### 14.3 Auth token utilities (non-UI but paired with admin)

| Field | Value |
|-------|--------|
| **File locations** | `portal/lib/api.ts`; `edip/apps/web/src/lib/api.ts`; `ppdm-edip/apps/web/lib/api.ts` |
| **Purpose** | `getToken`, `setToken`, `apiFetch` / `edipFetch` / `governanceFetch` with Bearer header |
| **Inputs** | path, RequestInit |
| **Outputs** | fetch Response |
| **Reusability score** | **5** (3 parallel implementations) |
| **Candidate shared component name** | `tanna-api-client` (hook/module, not visual) |

---

## 15. Page-level patterns (layout primitives)

These repeat on almost every page and should become layout primitives in the design system.

| Pattern | Typical markup | Occurrences | Candidate name | Score |
|---------|----------------|-------------|----------------|-------|
| **Page header** | `h1` + `p.text-slate-600` subtitle | 20+ | `TannaPageHeader` | 5 |
| **Section header** | `h2.text-lg.font-semibold.mb-2/3` | 30+ | `TannaSectionHeader` | 5 |
| **Section container** | `section` + `space-y-*` | 20+ | `TannaSection` | 4 |
| **Panel wrapper** | `rounded-lg border bg-white p-4` | 10+ | `TannaPanel` | 4 |
| **CLI code block** | `pre` dark background + command | 2 | `TannaCodeBlock` | 4 |
| **Inline code** | `` `code` `` in prose | 5+ | (typography token) | 3 |

---

## 16. Duplication matrix (extract priority)

| Component candidate | Portal | EDIP web | ppdm web | Priority |
|--------------------|--------|----------|----------|----------|
| `TannaKpiCard` | ✓ Executive, Reporting | ✓ Dashboard | ✓ Reporting | P0 |
| `TannaLineageTable` | ✓ Governance, TRD | ✓ Metadata | ✓ Warehouse | P0 |
| `TannaDataTable` | ✓ all | ✓ all | ✓ all | P0 |
| `TannaFilterBar` + `TannaPeriodFilter` | ✓ Reporting | — | ✓ Reporting | P0 |
| `TannaGeoMap` | ✓ | — | ✓ | P0 |
| `TannaJobRunForm` | ✓ TRD | — | ✓ Admin | P0 |
| `TannaSignalCard` | ✓ Governance | ✓ Governance | — | P1 |
| `TannaStatusBadge` | ✓ Reporting, Governance | ✓ Governance | — | P1 |
| `TannaMetadataDictionary` | ✓ Data Products | ✓ Metadata | — | P1 |
| `TannaModuleNav` | ✓ EdipNav | ✓ ClientNav | ✓ ClientNav | P1 |
| `TannaTrendChart` | ✓ Executive | ✓ Dashboard | — | P2 |
| `TannaSearchPanel` | — | — | — | P2 (new) |

---

## 17. Proposed Tanna design system package structure

Illustrative organization for a future shared package (not implemented):

```text
@tanna/ui
├── navigation/
│   TannaModuleNav.tsx
│   TannaModuleLayout.tsx
│   TannaBreadcrumb.tsx
├── cards/
│   TannaKpiCard.tsx
│   TannaSignalCard.tsx
│   TannaStatCard.tsx
│   TannaAreaCard.tsx
│   TannaEntityDetailCard.tsx
├── data/
│   TannaDataTable.tsx
│   TannaLineageTable.tsx      ← Traceability
│   TannaMetadataDictionary.tsx
│   TannaContractCatalog.tsx
│   TannaExceptionTable.tsx
├── charts/
│   TannaTrendChart.tsx
├── maps/
│   TannaGeoMap.tsx
│   TannaSpatialExplorer.tsx
├── filters/
│   TannaFilterBar.tsx
│   TannaPeriodFilter.tsx
│   TannaSearchPanel.tsx       ← net-new
├── forms/
│   TannaSignInForm.tsx
│   TannaJobRunForm.tsx
├── feedback/
│   TannaStatusBadge.tsx
│   TannaLoadingState.tsx
│   TannaEmptyState.tsx
│   TannaAlertInline.tsx
└── layout/
    TannaPageHeader.tsx
    TannaSection.tsx
    TannaPanel.tsx
```

---

## 18. Example mappings (requested format)

### Production KPI Card → Shared KPI Card

**Current:** Inline tile in Executive / Dashboard — `border rounded-lg p-4`, label, bold value, optional explain expand.  
**Candidate:** `TannaKpiCard`  
**Reason:** Same visual and interaction in 4 places; central to Patterns and Decision Products layers.

---

### DQ Score Card → Shared Signal Card

**Current:** Governance mart card with essential/enhanced/DQ metrics + certification badge.  
**Candidate:** `TannaSignalCard`  
**Reason:** Encapsulates signal-quality readings (DQ score, coverage %) with illumination status.

---

### Lineage Table → Shared Traceability Component

**Current:** 3-column source/target/run tables on Governance, TRD, Warehouse.  
**Candidate:** `TannaLineageTable`  
**Reason:** Identical column semantics; core Traceability UI building block.

---

### Reporting filter row → Shared Filter Bar

**Current:** Operator key, field pool key, PDEN id, date range inputs + Apply + Export CSV.  
**Candidate:** `TannaFilterBar`  
**Reason:** Duplicated verbatim in portal and ppdm reporting pages.

---

### Leaflet map → Shared Geo Map

**Current:** Duplicate `Map.tsx` in portal and ppdm-edip.  
**Candidate:** `TannaGeoMap`  
**Reason:** Already extracted once per app; should be one package component.

---

## 19. Summary

| Category | Distinct patterns found | Extracted today | Top candidate |
|----------|-------------------------|-----------------|---------------|
| Cards | 7 | 0 | `TannaKpiCard`, `TannaSignalCard` |
| Tables | 7 | 0 | `TannaDataTable` |
| Charts | 1 | 0 | `TannaTrendChart` |
| Maps | 2 (map + explorer) | 1 (`Map`) | `TannaGeoMap` |
| Forms | 3 | 0 | `TannaSignInForm`, `TannaJobRunForm` |
| Filters | 3 | 0 | `TannaFilterBar` |
| Search panels | 0 | 0 | `TannaSearchPanel` (gap) |
| Status indicators | 5 | 0 | `TannaStatusBadge` |
| Lineage views | 2 (column configs) | 0 | `TannaLineageTable` |
| Metadata views | 3 | 0 | `TannaMetadataDictionary` |
| Navigation | 4 | 2 (`EdipNav`, `ClientNav`) | `TannaModuleNav` |
| Admin | 3 | 0 | `TannaJobRunForm`, `TannaWarehouseMonitor` |

The future Tanna design system should **consolidate ~35 inline patterns into ~20 shared components**, prioritizing tables, KPI/signal cards, lineage, filters, and the duplicated Reporting workspace.

---

*Document generated from frontend source inspection. No code was modified.*
