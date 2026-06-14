# Tanna Navigation Analysis

**Product:** PETRO Reporting Interface  
**Document purpose:** Inventory every user-facing page, workflow, and navigation path in the current frontends, and map each to the future Tanna module navigation model.  
**Scope:** `portal/` (primary), `edip/apps/web/` (legacy EDIP), `ppdm-edip/apps/web/` (legacy governance).  
**Out of scope:** Code changes, implementation design.

---

## 1. Executive summary

The product exposes **three Next.js frontends** with **26 user-facing routes** total. Only **`portal/`** is the canonical product entry (`http://localhost:3003` in root Docker). Legacy apps remain in the repo under Docker profile `dev-legacy-ui`.

Current navigation is **domain-oriented** (Executive, Production, Reporting, Governance, TRD, Compliance) rather than **intelligence-layer-oriented**. Most pages are **Decision Products** (dashboards and workspaces) that **pull across layers** — KPI tiles draw from Patterns, certification badges from Illuminations, lineage tables from Traceability, and catalog tables from Knowledge Assets / Data Products.

### Tanna navigation model (target)

| Tanna section | Intended purpose in module |
|---------------|----------------------------|
| **Overview** | Module home, cross-area summary, entry points |
| **Sources** | Ingest sources, landing zones, upstream feed registry |
| **Data Products** | Published schemas, marts, entity explorers, spatial layers |
| **Signals** | Raw measures, DQ scores, exceptions, point-in-time values |
| **Patterns** | KPIs, rollups, trends, rankings, comparative analytics |
| **Illuminations** | Certification status, coverage interpretation, KPI explain, compliance findings |
| **Decision Products** | Dashboards, drill-down workspaces, exports |
| **Knowledge Assets** | Contract catalog, specifications, platform docs, policies |
| **Traceability** | Lineage graphs, ingest run audit, provenance |
| **Administration** | Auth, job execution, tenant/user stewardship |

### Access model today

| Frontend | Default access | Auth gate |
|----------|----------------|-----------|
| **Portal** | Open browse on all `/edip/*` pages | Admin JWT only for `POST /v1/jobs/run` on TRD page; sign-in at `/edip/login` |
| **Legacy EDIP web** | Home public | Dashboard, Governance, Metadata redirect to `/login` without EDIP JWT |
| **Legacy ppdm-edip web** | All pages public browse | Job run on Admin page requires governance JWT (`admin` role) |

**Role vocabulary (from backend seeds):**

- **EDIP API:** `tenant_admin`, `executive_viewer`, `analyst`, `finance_analyst`, `geo_analyst`, `data_steward`, `api_client` (demo user: `admin@demo.edip.local`)
- **Governance API:** `admin`, `viewer` (demo: `admin` / `change-me`, `viewer` / `viewer`)

Portal does not enforce EDIP roles in the UI; governance admin is the only gated action surfaced in the primary app.

---

## 2. Frontend applications

| App | Path | Status | Entry URL (typical) |
|-----|------|--------|---------------------|
| **Portal** | `portal/` | Primary product shell | `http://localhost:3003` |
| **Legacy EDIP web** | `edip/apps/web/` | Alternate; not in default root compose | `http://localhost:3001` (standalone EDIP compose) |
| **Legacy ppdm-edip web** | `ppdm-edip/apps/web/` | Alternate; profile `dev-legacy-ui` | `http://localhost:3007` (standalone ppdm compose) |

---

## 3. Current navigation structures

### 3.1 Portal — root (no persistent nav bar)

```text
/  ──→  /platform
     ──→  /edip  ──→  (EDIP workspace nav)
```

### 3.2 Portal — EDIP workspace nav (`EdipNav.tsx`)

```text
PETRO / EDIP Workspace
├── Overview          /edip
├── Executive         /edip/executive
├── Production        /edip/production  ──→  /edip/production/[pdenId]
├── Reporting         /edip/reporting
├── Governance        /edip/governance
├── TRD Warehouse     /edip/trd
├── Compliance        /edip/compliance
├── Data Products     /edip/data-products
├── Platform Services /edip/platform-services
└── Sign in / out     /edip/login
```

Breadcrumb: `PETRO` → `/` | `EDIP Workspace` → `/edip`

### 3.3 Legacy EDIP web nav (`ClientNav.tsx`)

```text
EDIP
├── Production   /dashboard
├── Governance   /governance
├── Metadata     /metadata
└── Login        /login
Home: /
```

### 3.4 Legacy ppdm-edip web nav (`ClientNav.tsx`)

```text
EDIP
├── Warehouse Core  /warehouse
├── Spatial Explorer /spatial
├── Production      /production  ──→  /production/[pdenId]
├── Reporting       /reporting
├── Admin           /admin
└── Login           /login
Home: /
```

---

## 4. User workflows (cross-page)

Workflows describe repeatable user journeys, including in-page actions that behave like sub-workflows.

| Workflow ID | Steps | Primary pages | Auth |
|-------------|-------|---------------|------|
| **W1 — Product entry** | Land on `/` → Enter EDIP Workspace → pick area card | `/` → `/edip` → area | Open |
| **W2 — Executive review** | Open Executive → scan KPI tiles → optional KPI Explain click → view BOE trend → scan PDEN table | `/edip/executive` | Open (EDIP API calls may 401 without token; UI shows empty/zero) |
| **W3 — Production drill-down** | Production list → click Volumes → PDEN detail volume table → back | `/edip/production` → `/edip/production/[pdenId]` | Open |
| **W4 — Reporting analysis** | Set year/month → refresh KPIs → read certification badge → filter drill-down grid → Export CSV → optional link to PDEN | `/edip/reporting` | Open |
| **W5 — Governance stewardship** | Review mart DQ cards → scan lineage → scan exceptions → browse contract catalog → link to TRD | `/edip/governance` | Open (EDIP DQ API may 401 without token) |
| **W6 — TRD job stewardship** | Review runs/DQ/lineage/exceptions → Sign in → select source/mode → Run job | `/edip/login` → `/edip/trd` | Browse open; **Run requires admin JWT** |
| **W7 — Compliance & spatial** | Read CLI instructions → select map layer → view GeoJSON on map → optional link to Platform | `/edip/compliance`, `/platform` | Open |
| **W8 — Data catalog browse** | Open Data Products → scroll schema/table list | `/edip/data-products` | Open (EDIP dictionary API requires JWT; list may be empty) |
| **W9 — Platform discovery** | Root or Compliance → Platform overview → Platform Services in EDIP | `/platform`, `/edip/platform-services` | Open |
| **W10 — Legacy EDIP authenticated** | Login (email) → Dashboard / Governance / Metadata | `/login` → `/dashboard`, `/governance`, `/metadata` | **EDIP JWT required** for protected pages |
| **W11 — Legacy governance ops** | Warehouse monitoring **or** Admin job run + contract browse | `/warehouse`, `/admin` | Open browse; **admin JWT for job run** |
| **W12 — Legacy spatial-only** | Pick layer → map features | `/spatial` | Open |
| **W13 — Reporting → Production cross-link** | From reporting fact row or top-10 table → PDEN detail | `/edip/reporting` → `/edip/production/[pdenId]` | Open |

---

## 5. Page catalog — Portal (primary)

### 5.1 PETRO Landing

| Field | Value |
|-------|--------|
| **Current route** | `/` |
| **Current purpose** | Product marketing landing; module area cards; primary CTA into EDIP Workspace |
| **Data used** | Static content only (no API) |
| **User role** | All visitors (anonymous) |
| **Recommended Tanna destination** | **Overview** |
| **Reason** | Module entry and orientation — the Tanna module home that routes users into intelligence layers. |

**Also maps to:** Overview → links preview Decision Products (Executive, Production, Reporting) and Knowledge Assets (LDV Platform via `/platform`).

---

### 5.2 LDV Platform Core (root)

| Field | Value |
|-------|--------|
| **Current route** | `/platform` |
| **Current purpose** | Static documentation for LDV Platform Python services and compliance CLI |
| **Data used** | Static copy; references `ldv_platform/` paths |
| **User role** | All visitors |
| **Recommended Tanna destination** | **Knowledge Assets** |
| **Reason** | Describes institutional platform capabilities and CLI — reference material, not live analytics. |

**Secondary:** Administration (compliance CLI operator reference).

---

### 5.3 EDIP Workspace Overview

| Field | Value |
|-------|--------|
| **Current route** | `/edip` |
| **Current purpose** | EDIP workspace hub; card grid to six functional areas |
| **Data used** | Static links only |
| **User role** | All visitors |
| **Recommended Tanna destination** | **Overview** |
| **Reason** | In-module dashboard index — equivalent to Tanna module Overview inside `petro-reporting`. |

---

### 5.4 Executive Intelligence

| Field | Value |
|-------|--------|
| **Current route** | `/edip/executive` |
| **Current purpose** | Executive BI dashboard: KPI tiles, BOE trend chart, PDEN explorer table, KPI Explain panel (placeholder text) |
| **Data used** | `GET /api/edip/v1/marts/production/kpis`, `/pdens`, `/timeseries` |
| **User role** | Intended: `executive_viewer`, `analyst`, `tenant_admin` (EDIP JWT); UI allows anonymous browse |
| **Recommended Tanna destination** | **Decision Products** (primary) |
| **Reason** | Executive KPI summaries and trends support operational and strategic decisions. |

**Secondary mappings:**

| Layer | Content on page |
|-------|-----------------|
| **Patterns** | KPI tile values (MTD/YTD/YoY/decline/production per well) |
| **Illuminations** | KPI Explain expand (definition/formula/lineage/DQ — stub copy) |
| **Data Products** | PDEN explorer table (entity preview) |

---

### 5.5 Production Intelligence (list)

| Field | Value |
|-------|--------|
| **Current route** | `/edip/production` |
| **Current purpose** | PDEN search/list, summary KPI strip (count, oil/gas totals), rollups by pool, link to volume detail |
| **Data used** | `GET /api/governance/v1/production/pdens`, `/kpis`, `/rollups?group_by=pool` |
| **User role** | All visitors (open) |
| **Recommended Tanna destination** | **Data Products** (primary) |
| **Reason** | Entity-centric explorer over Gold/Platinum production data — browsing published petroleum objects. |

**Secondary:**

| Layer | Content |
|-------|---------|
| **Patterns** | Rollups by pool; summary KPI strip |
| **Decision Products** | Operational production monitoring workspace |

---

### 5.6 Production Intelligence (PDEN detail)

| Field | Value |
|-------|--------|
| **Current route** | `/edip/production/[pdenId]` |
| **Current purpose** | Single PDEN profile and cumulative volume time series |
| **Data used** | `GET /api/governance/v1/production/pdens/by-id/{id}`, `/pdens/{id}/volumes?pden_type&pden_source` |
| **User role** | All visitors |
| **Recommended Tanna destination** | **Data Products** |
| **Reason** | Detail view of one production entity and its volume signal history. |

**Secondary:** **Signals** (volume rows), **Decision Products** (asset-level investigation).

---

### 5.7 Reporting Workspace

| Field | Value |
|-------|--------|
| **Current route** | `/edip/reporting` |
| **Current purpose** | Full production mart reporting: 12 KPI tiles with definitions, certification badge, drill-down fact grid (Operator → Field → PDEN → Day), CSV export, operator/top-10 tables |
| **Data used** | `GET /api/governance/v1/marts/production/kpis`, `/coverage`, `/data`; `GET .../export/csv` |
| **User role** | All visitors |
| **Recommended Tanna destination** | **Decision Products** (primary) |
| **Reason** | Primary analytic workspace for performance reporting, drill-down, and export — classic decision support UI. |

**Secondary:**

| Layer | Content |
|-------|---------|
| **Patterns** | KPI tiles, YoY/decline/utilization, top-10, by-operator/field |
| **Illuminations** | Certified / Not certified badge; coverage points display |
| **Knowledge Assets** | KPI definition text per tile |
| **Traceability** | Implicit via drill-down to fact grain (not lineage UI) |

---

### 5.8 Governance

| Field | Value |
|-------|--------|
| **Current route** | `/edip/governance` |
| **Current purpose** | Unified governance console: mart DQ/certification, lineage edges, exception monitor, PPDM contract catalog |
| **Data used** | `GET /api/edip/v1/governance/dq-scores`; `GET /api/governance/v1/marts/governance/lineage`, `/metadata/exceptions`, `/admin/contract/tables` |
| **User role** | Intended: `data_steward`, `tenant_admin`; UI open browse |
| **Recommended Tanna destination** | **Traceability** + **Illuminations** (split by section) |

**Section-level mapping:**

| Section | Tanna destination | Reason |
|---------|-------------------|--------|
| Mart certification & DQ scores | **Illuminations** | Certification status and interpreted quality posture |
| Lineage table | **Traceability** | Source → target provenance |
| Exception monitor | **Signals** | Point exception records |
| PPDM contract catalog | **Knowledge Assets** | Schema contract reference |

**Page-level primary:** **Traceability** — the page’s narrative center is stewardship of data provenance and quality.

---

### 5.9 TRD Warehouse

| Field | Value |
|-------|--------|
| **Current route** | `/edip/trd` |
| **Current purpose** | Warehouse operations: ingest job runner, recent runs, DQ scores, lineage, exceptions, ingest source selector |
| **Data used** | `GET /api/governance/v1/jobs/runs`, `/admin/dq/scores`, `/admin/lineage`, `/admin/exceptions`, `/admin/sources`; `POST /v1/jobs/run` |
| **User role** | Browse: all; **Run job: `admin`** (governance JWT via `/edip/login`) |
| **Recommended Tanna destination** | **Administration** (primary) |
| **Reason** | Pipeline execution and warehouse stewardship — operational control plane. |

**Secondary:**

| Layer | Content |
|-------|---------|
| **Sources** | Ingest source dropdown |
| **Traceability** | Runs, lineage, exceptions panels |
| **Signals** | DQ score table |
| **Illuminations** | Certified column in DQ table |

---

### 5.10 Compliance & Regulatory Intelligence

| Field | Value |
|-------|--------|
| **Current route** | `/edip/compliance` |
| **Current purpose** | Schema compliance CLI reference + spatial asset map explorer |
| **Data used** | Static CLI copy; `GET /api/governance/v1/spatial/layers`, `/layers/{id}/features` |
| **User role** | All visitors |
| **Recommended Tanna destination** | **Data Products** (spatial section) + **Knowledge Assets** (CLI section) |

**Split recommendation:**

| Section | Tanna destination | Reason |
|---------|-------------------|--------|
| LDV compliance CLI | **Knowledge Assets** | Documents how to run compliance checks |
| Spatial asset explorer | **Data Products** | Interactive browse of spatial data product layers |

**Secondary:** **Decision Products** (regulatory asset visibility map).

---

### 5.11 Data Products (metadata dictionary)

| Field | Value |
|-------|--------|
| **Current route** | `/edip/data-products` |
| **Current purpose** | Table catalog from information_schema across EDIP schemas |
| **Data used** | `GET /api/edip/v1/metadata/dictionary/tables` (requires EDIP JWT) |
| **User role** | Intended: `analyst`, `data_steward`; UI open |
| **Recommended Tanna destination** | **Data Products** |
| **Reason** | Direct browse of published schema/table inventory — canonical Data Products navigator. |

**Secondary:** **Knowledge Assets** (dictionary as catalog metadata).

---

### 5.12 Platform Services

| Field | Value |
|-------|--------|
| **Current route** | `/edip/platform-services` |
| **Current purpose** | In-workspace summary of LDV Platform, domain products, governance API proxy |
| **Data used** | Static content |
| **User role** | All visitors |
| **Recommended Tanna destination** | **Knowledge Assets** |
| **Reason** | Platform capability reference embedded in the module. |

**Secondary:** **Administration** (API proxy documentation for operators).

---

### 5.13 Sign in

| Field | Value |
|-------|--------|
| **Current route** | `/edip/login` |
| **Current purpose** | Governance API login; stores JWT in `localStorage` (`edip_token`); redirects to TRD after success |
| **Data used** | `POST /api/governance/v1/auth/login` |
| **User role** | **`admin`** (demo: `admin` / `change-me`) for job runs |
| **Recommended Tanna destination** | **Administration** |
| **Reason** | Authentication gate for privileged warehouse actions. |

---

## 6. Page catalog — Legacy EDIP web

| Page | Route | Purpose | Data used | User role | Tanna destination | Reason |
|------|-------|---------|-----------|-----------|-------------------|--------|
| **Home** | `/` | Intro; prompts login for features | Static | Anonymous | **Overview** | Legacy module entry |
| **Login** | `/login` | EDIP email/password auth | `POST /v1/auth/login` (EDIP) | Pre-auth | **Administration** | Identity gate |
| **Production Dashboard** | `/dashboard` | Same as portal Executive (KPI, trend, PDEN) | `/v1/marts/production/kpis`, `/pdens`, `/timeseries` | **EDIP JWT required** | **Decision Products** | Executive decision dashboard |
| **Governance** | `/governance` | Mart DQ/certification cards only | `/v1/governance/dq-scores` | **EDIP JWT required** | **Illuminations** | Certification interpretation |
| **Metadata** | `/metadata` | Dictionary tables + lineage | `/v1/metadata/dictionary/tables`, `/lineage` | **EDIP JWT required** | **Data Products** + **Traceability** | Catalog + provenance (split by section) |

**Legacy nav gap vs portal:** No Reporting, TRD, Compliance, Production detail route, or CSV export in this app.

---

## 7. Page catalog — Legacy ppdm-edip web

| Page | Route | Purpose | Data used | User role | Tanna destination | Reason |
|------|-------|---------|-----------|-----------|-------------------|--------|
| **Home** | `/` | Product index linking Warehouse, Spatial, Production, Admin | Static links | Anonymous | **Overview** | Legacy entry hub |
| **Login** | `/login` | Governance username/password auth | `POST /v1/auth/login` | Pre-auth | **Administration** | Identity gate |
| **Warehouse Core** | `/warehouse` | Runs, DQ, lineage, exceptions (read-only monitor) | `/v1/jobs/runs`, `/admin/dq/scores`, `/admin/lineage`, `/admin/exceptions` | Anonymous browse | **Traceability** + **Administration** | Operational warehouse visibility |
| **Spatial Explorer** | `/spatial` | Layer picker + Leaflet map | `/v1/spatial/layers`, `/layers/{id}/features` | Anonymous | **Data Products** | Spatial data product explorer |
| **Production (list)** | `/production` | Same pattern as portal production list | `/v1/production/pdens`, `/kpis`, `/rollups` | Anonymous | **Data Products** | Entity explorer |
| **Production (detail)** | `/production/[pdenId]` | PDEN detail + volumes | `/v1/production/pdens/by-id`, `/volumes` | Anonymous | **Data Products** | Entity detail |
| **Reporting** | `/reporting` | Same as portal reporting workspace | `/v1/marts/production/*`, CSV export | Anonymous | **Decision Products** | Reporting and export workspace |
| **Admin** | `/admin` | Ingest sources, contract tables, job runner | `/v1/admin/sources`, `/contract/tables`, `POST /v1/jobs/run` | **admin JWT for run** | **Administration** + **Sources** | Source registry + job control |

---

## 8. Consolidated mapping table (all pages)

| # | App | Current page | Route | Primary Tanna destination | Secondary Tanna destinations |
|---|-----|--------------|-------|---------------------------|------------------------------|
| 1 | Portal | PETRO Landing | `/` | Overview | Decision Products (links) |
| 2 | Portal | LDV Platform Core | `/platform` | Knowledge Assets | Administration |
| 3 | Portal | EDIP Workspace Overview | `/edip` | Overview | — |
| 4 | Portal | Executive Intelligence | `/edip/executive` | Decision Products | Patterns, Illuminations, Data Products |
| 5 | Portal | Production Intelligence | `/edip/production` | Data Products | Patterns, Decision Products |
| 6 | Portal | PDEN Detail | `/edip/production/[pdenId]` | Data Products | Signals, Decision Products |
| 7 | Portal | Reporting Workspace | `/edip/reporting` | Decision Products | Patterns, Illuminations, Knowledge Assets |
| 8 | Portal | Governance | `/edip/governance` | Traceability | Illuminations, Signals, Knowledge Assets |
| 9 | Portal | TRD Warehouse | `/edip/trd` | Administration | Sources, Traceability, Signals |
| 10 | Portal | Compliance | `/edip/compliance` | Data Products | Knowledge Assets, Decision Products |
| 11 | Portal | Data Products | `/edip/data-products` | Data Products | Knowledge Assets |
| 12 | Portal | Platform Services | `/edip/platform-services` | Knowledge Assets | Administration |
| 13 | Portal | Sign in | `/edip/login` | Administration | — |
| 14 | Legacy EDIP | Home | `/` | Overview | — |
| 15 | Legacy EDIP | Login | `/login` | Administration | — |
| 16 | Legacy EDIP | Production Dashboard | `/dashboard` | Decision Products | Patterns, Illuminations |
| 17 | Legacy EDIP | Governance | `/governance` | Illuminations | — |
| 18 | Legacy EDIP | Metadata | `/metadata` | Data Products | Traceability |
| 19 | Legacy ppdm | Home | `/` | Overview | — |
| 20 | Legacy ppdm | Login | `/login` | Administration | — |
| 21 | Legacy ppdm | Warehouse Core | `/warehouse` | Traceability | Administration, Signals |
| 22 | Legacy ppdm | Spatial Explorer | `/spatial` | Data Products | Decision Products |
| 23 | Legacy ppdm | Production list | `/production` | Data Products | Patterns |
| 24 | Legacy ppdm | PDEN detail | `/production/[pdenId]` | Data Products | Signals |
| 25 | Legacy ppdm | Reporting | `/reporting` | Decision Products | Patterns, Illuminations |
| 26 | Legacy ppdm | Admin | `/admin` | Administration | Sources, Knowledge Assets |

---

## 9. Current nav → Tanna nav evolution

### 9.1 Proposed Tanna module sidebar (future)

```text
petro-reporting (Tanna module)
├── Overview                    ← /, /edip
├── Sources                     ← TRD ingest sources (from /edip/trd, /admin)
├── Data Products               ← /edip/data-products, /edip/production, spatial layers
├── Signals                     ← NEW dedicated views (exceptions, DQ raw, volume facts)
├── Patterns                    ← KPI catalog, rollups, trends (split from Executive/Reporting)
├── Illuminations               ← certification, coverage, KPI explain (from Governance/Reporting)
├── Decision Products           ← Executive, Reporting dashboards, exports
├── Knowledge Assets            ← contract catalog, platform docs, KPI definitions, specs
├── Traceability                ← lineage, ingest runs (from Governance/TRD)
└── Administration              ← login, job run, roles (from /edip/login, /edip/trd)
```

### 9.2 Page migration map (current route → future Tanna route)

| Current route | Future Tanna route (illustrative) |
|---------------|-----------------------------------|
| `/` | `/tanna/petro-reporting/overview` |
| `/edip` | `/tanna/petro-reporting/overview/workspace` |
| `/edip/executive` | `/tanna/petro-reporting/decision-products/executive` |
| `/edip/production` | `/tanna/petro-reporting/data-products/production` |
| `/edip/production/[pdenId]` | `/tanna/petro-reporting/data-products/production/[pdenId]` |
| `/edip/reporting` | `/tanna/petro-reporting/decision-products/reporting` |
| `/edip/governance` | Split: `/illuminations/governance`, `/traceability/lineage`, `/knowledge-assets/contracts` |
| `/edip/trd` | `/tanna/petro-reporting/administration/warehouse` (+ `/sources` tab) |
| `/edip/compliance` | `/data-products/spatial` + `/knowledge-assets/compliance-cli` |
| `/edip/data-products` | `/tanna/petro-reporting/data-products/catalog` |
| `/edip/platform-services`, `/platform` | `/tanna/petro-reporting/knowledge-assets/platform` |
| `/edip/login` | `/tanna/petro-reporting/administration/sign-in` |

### 9.3 Content that has no dedicated page today (Tanna gaps)

These intelligence layers appear **only as sections inside other pages** — a Tanna module would likely give them first-class navigation:

| Tanna section | Currently embedded in | Gap |
|---------------|----------------------|-----|
| **Sources** | TRD job source dropdown; Admin sources list | No standalone Sources browser |
| **Signals** | Exception tables; volume columns; DQ scores | No Signals explorer |
| **Patterns** | KPI tiles on Executive/Reporting; pool rollups on Production | No Patterns library or KPI registry page |
| **Illuminations** | Certification badges; KPI Explain stub | No dedicated Illuminations hub |
| **Traceability** | Lineage tables on Governance/TRD | No graph visualization or run-scoped trace view |

---

## 10. Duplicate pages across frontends

Several pages implement the same user intent in multiple apps. For Tanna evolution, **one canonical Decision Product or Data Product view** should replace duplicates:

| User intent | Portal (canonical) | Legacy duplicate(s) |
|-------------|-------------------|---------------------|
| Executive KPI dashboard | `/edip/executive` | EDIP `/dashboard` |
| Production PDEN explorer | `/edip/production` | ppdm `/production` |
| PDEN volume detail | `/edip/production/[pdenId]` | ppdm `/production/[pdenId]` |
| Mart reporting + export | `/edip/reporting` | ppdm `/reporting` |
| Warehouse / TRD ops | `/edip/trd` | ppdm `/warehouse`, `/admin` (split) |
| Spatial map | `/edip/compliance` (section) | ppdm `/spatial` |
| Metadata dictionary | `/edip/data-products` | EDIP `/metadata` (partial) |
| Lineage browse | `/edip/governance` (section) | EDIP `/metadata` (section); ppdm `/warehouse` (section) |
| Governance DQ | `/edip/governance` (section) | EDIP `/governance` |

---

## 11. Example mappings (requested format)

### Executive Dashboard

**Current:** Executive Intelligence — `/edip/executive`  
**Maps to:** Decision Products  
**Reason:** Executive KPI summaries and production trends support operational and strategic decisions.

---

### Production PDEN Explorer

**Current:** Production Intelligence — `/edip/production`  
**Maps to:** Data Products  
**Reason:** Users browse published PDEN entities and pool rollups from the production data product layer.

---

### Reporting Workspace

**Current:** Reporting — `/edip/reporting`  
**Maps to:** Decision Products  
**Reason:** Drill-down grids, KPI panels, and CSV export are decision-support outputs built on mart data.

---

### Governance Console

**Current:** Governance — `/edip/governance`  
**Maps to:** Traceability (page primary); Illuminations + Knowledge Assets (sections)  
**Reason:** Lineage and stewardship are the navigational center; certification and contract catalog are supporting layers on the same screen.

---

### TRD Warehouse

**Current:** TRD Warehouse — `/edip/trd`  
**Maps to:** Administration  
**Reason:** Ingest job execution and run monitoring are platform administration workflows.

---

### Compliance Map

**Current:** Compliance — `/edip/compliance` (spatial section)  
**Maps to:** Data Products  
**Reason:** Spatial layers and GeoJSON features are published spatial data products.

---

### Data Products Dictionary

**Current:** Data Products — `/edip/data-products`  
**Maps to:** Data Products  
**Reason:** Schema/table inventory is the catalog of available data products.

---

### Platform Documentation

**Current:** Platform Services — `/edip/platform-services`; LDV Platform — `/platform`  
**Maps to:** Knowledge Assets  
**Reason:** Static platform and compliance documentation — institutional reference, not live signals.

---

### Sign in

**Current:** Sign in — `/edip/login`  
**Maps to:** Administration  
**Reason:** Authenticates admin users for privileged warehouse job execution.

---

## 12. Summary

The current UI is organized as **petroleum domain workspaces** (Executive, Production, Reporting, Governance, TRD, Compliance) that **blend multiple Tanna intelligence layers** on single screens. Evolving into a Tanna module means:

1. **Keep** portal routes as the canonical UX (`/` → `/edip/*`).
2. **Re-home** pages under Tanna sections — especially splitting **Governance** into Traceability, Illuminations, Signals, and Knowledge Assets.
3. **Promote** Sources and Signals to first-class nav items currently buried in TRD and table sections.
4. **Consolidate** legacy EDIP and ppdm-edip pages into the portal equivalents under Tanna naming.
5. **Retain** Administration for auth and ingest job control only.

**Total discovered:** 26 user-facing pages across 3 frontends, 13 cross-page workflows, 4 distinct navigation chrome patterns.

---

*Document generated from frontend source inspection. No code was modified.*
