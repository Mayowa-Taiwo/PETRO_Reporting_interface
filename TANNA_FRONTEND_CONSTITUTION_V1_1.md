# Tanna Frontend Constitution v1.1

**Document type:** Architecture constitution (normative for future frontend work)  
**Version:** 1.1  
**Supersedes:** `TANNA_FRONTEND_CONSTITUTION.md` (v1.0)  
**Derived from:** v1.0 constitution plus fixed business product registry and theme governance model  
**Scope:** All Tanna product frontends — registry products and transitional implementations  
**Out of scope:** Code changes, refactors, implementation, generated TypeScript

### v1.1 changes

| Change | Summary |
|--------|---------|
| **Product Registry** | Fixed reference model for eight registry products (LDV + A18 families) — authoritative business context, not inferred from code |
| **Theme Governance and Inheritance Model** | Five-layer theme stack: `bhalo.ts` → `tanna.ts` → `ldv.ts` / `a18.ts` → product accent overrides |
| **Theme family authority** | `themeFamily` is declared in product config; developers and tooling must not infer or override it |
| **Section renumbering** | Former §6 → §7 (folder structure); former §7 → §8 (governance) |

---

## 0. Purpose and principles

This constitution defines the **shared frontend contract** for the Tanna intelligence platform. Every **registry product** (Section 0.1) and every **transitional implementation** (e.g. current `petro-reporting` in this repository) must:

1. **Reuse one layout shell** — no per-product layout forks.
2. **Expose the same ten intelligence navigation sections** — product config chooses which sections are populated, not whether they exist.
3. **Consume shared UI from `@tanna/ui`** — cards, tables, forms, maps, charts, navigation.
4. **Declare product uniqueness in `/products/[product].config.ts` only** — never in component markup.
5. **Apply visual tokens through the theme inheritance stack** (Section 6) — no inline Tailwind color/spacing recipes in product pages.
6. **Declare `themeFamily` in product config** — never inferred by Cursor, code, or developers from domain, folder names, or implementation artifacts.

**Current state (as-built):** Three Next.js apps (`portal/`, `edip/apps/web/`, `ppdm-edip/apps/web/`) with inline Tailwind, three extracted components, and no theme files. This document describes the **target architecture** informed by repository inventory analyses.

**Authoritative product list:** Section 0.1 Product Registry. Product meaning, domain scope, and theme-family membership are **business facts** declared in config — not derived from repository structure or legacy naming (PETRO, EDIP, etc.).

---

## 0.1 Product Registry (fixed reference model)

The following registry is **fixed business context**. It defines the canonical Tanna product portfolio. Constitution rules, theme families, and folder conventions apply to these products. **Do not infer product ownership, domain meaning, or LDV/A18 assignment from application code, README text, or legacy labels.**

### LDV products — theme family: `ldv`

| Product slug | Display name | Domain (fixed) |
|--------------|--------------|----------------|
| `petro-core` | PetroCore | Upstream oil and gas intelligence |
| `petro-sight` | PetroSight | Downstream petroleum intelligence |
| `grid-sight` | GridSight | Electricity/utilities intelligence |
| `waste-grid` | WasteGrid | Municipal waste operations intelligence |

### A18 products — theme family: `a18`

| Product slug | Display name | Domain (fixed) |
|--------------|--------------|----------------|
| `metaops-studio` | MetaOps Studio | Metadata operations and data governance intelligence |
| `recon-intel` | ReconIntel | Settlement reconciliation and commercial intelligence |
| `wellmind` | WellMind | WITSML, drilling, and well intelligence |
| `constituency-os` | ConstituencyOS | Constituency and public-sector intelligence |

### Registry rules (normative)

1. **Eight registry products** — the table above is complete for portfolio planning; new products require registry amendment, not code discovery.
2. **`themeFamily` is config, not code** — each registry product config must set `themeFamily: "ldv"` or `themeFamily: "a18"` matching its row above. No developer, agent, or build step may assign or change theme family by inspecting routes, APIs, or copy.
3. **Slug stability** — config file name `/products/[slug].config.ts` must match registry slug exactly.
4. **Transitional implementations** — repositories may host interim products (e.g. `petro-reporting` for the current PETRO Reporting Interface) that are **not** registry entries. Transitional products still obey this constitution but must declare their own `themeFamily` explicitly in config; they do not redefine registry membership.

### Transitional product in this repository

| Slug | Status | Note |
|------|--------|------|
| `petro-reporting` | Transitional implementation | Current portal/EDIP workspace; not a registry product name. Migration target is one or more registry products per business decision — **not** inferred here. |

---

## 1. Shared layout architecture

### 1.1 Canonical layout model

All products share a **two-shell layout system**:

| Shell | Role | Visual character | When used |
|-------|------|------------------|-----------|
| **Platform shell** | Product suite entry, cross-product marketing, platform docs | Dark (`shellDark`: from `tanna.ts` tokens) | Landing, platform core info, sign-in outside a module |
| **Module shell** | Intelligence workspace for one product | Light body (`workspaceLight`: from `tanna.ts`), dark module header, constrained main | All in-module routes under a product slug |

This mirrors the current portal pattern: root `layout.tsx` (dark) → `/edip/layout.tsx` (module shell with `EdipNav`).

### 1.2 Canonical layout hierarchy

```text
TannaRootLayout                    ← html/body, theme provider, fonts, antialiased
├── TannaPlatformLayout            ← optional dark marketing shell (landing, /platform)
│   └── {page content}
└── TannaModuleLayout              ← product workspace (required for all /tanna/[product]/* routes)
    ├── TannaModuleNav             ← dark header, breadcrumb, 10-section nav (from config)
    └── main                       ← flex-1, workspace padding, max-width container
        └── {section page content}
```

**Canonical constraints (from current `portal/app/edip/layout.tsx`):**

| Region | Required behavior | Token source |
|--------|-------------------|--------------|
| Viewport | `min-h-screen flex flex-col` | `tanna.ts` layout |
| Workspace body | Light background, dark text | `tanna.ts` workspace |
| Main padding | Responsive `p-4 md:p-6` | `tanna.ts` spacing |
| Content max width | `max-w-7xl mx-auto w-full` | `tanna.ts` layout |
| Module header | Dark bar via `TannaModuleNav` | `tanna.ts` nav + family accent from `ldv.ts` / `a18.ts` |

### 1.3 Page layout primitives

Every page inside a module composes from shared layout primitives (not ad-hoc markup):

| Primitive | Responsibility | Package |
|-----------|----------------|---------|
| `TannaPageHeader` | `h1` + optional subtitle | `@tanna/ui/layout` |
| `TannaSection` | Vertical stack (`space-y-6` / `space-y-8`) | `@tanna/ui/layout` |
| `TannaSectionHeader` | Section `h2` | `@tanna/ui/layout` |
| `TannaPanel` | Bordered white panel | `@tanna/ui/layout` |
| `TannaSplitLayout` | Sidebar + main | `@tanna/ui/layout` |
| `TannaCenteredCardLayout` | Login / narrow forms | `@tanna/ui/layout` |

### 1.4 Layout rules (normative)

1. **One module layout per product** — products do not define alternate headers or body backgrounds.
2. **Platform shell and module shell must not mix** — module pages never inherit dark body from root without the module wrapper.
3. **Max-width is fixed by shell** — products may not override `max-w-7xl` except for intentional narrow layouts (login, landing hero).
4. **Maps and charts live inside `TannaPanel` or dedicated containers** — fixed heights come from `tanna.ts` theme tokens.
5. **Legacy app layouts (`edip/apps/web`, `ppdm-edip/apps/web`) are deprecated** — converge on `TannaModuleLayout`.
6. **Layout tokens live in `tanna.ts`** — not in `bhalo.ts`, not in product config.

---

## 2. Shared navigation architecture

### 2.1 Canonical ten-section model

Every Tanna product module exposes the same top-level navigation sections. Product config supplies labels, icons, routes, and visibility — not the section list itself.

| # | Tanna section | Purpose |
|---|---------------|---------|
| 1 | **Overview** | Module home, cross-area summary, entry points |
| 2 | **Sources** | Ingest sources, landing zones, upstream feed registry |
| 3 | **Data Products** | Published schemas, marts, entity explorers, spatial layers |
| 4 | **Signals** | Raw measures, DQ scores, exceptions, point-in-time values |
| 5 | **Patterns** | KPIs, rollups, trends, rankings, comparative analytics |
| 6 | **Illuminations** | Certification, coverage interpretation, KPI explain, compliance findings |
| 7 | **Decision Products** | Dashboards, drill-down workspaces, exports |
| 8 | **Knowledge Assets** | Contract catalog, specifications, platform docs, policies |
| 9 | **Traceability** | Lineage graphs, ingest run audit, provenance |
| 10 | **Administration** | Auth, job execution, tenant/user stewardship |

**Navigation component:** `TannaModuleNav` — replaces `EdipNav`, both `ClientNav` variants. Nav items are **injected from product config**, not hard-coded.

### 2.2 Current pages → Tanna sections (portal — canonical)

Transitional `petro-reporting` routes mapped for migration reference:

| Current route | Page | Primary section | Secondary sections |
|---------------|------|-----------------|-------------------|
| `/` | PETRO Landing | Overview | Decision Products (CTA links) |
| `/platform` | LDV Platform Core | Knowledge Assets | Administration |
| `/edip` | EDIP Workspace Overview | Overview | — |
| `/edip/executive` | Executive Intelligence | Decision Products | Patterns, Illuminations, Data Products |
| `/edip/production` | Production Intelligence | Data Products | Patterns, Decision Products |
| `/edip/production/[pdenId]` | PDEN Detail | Data Products | Signals, Decision Products |
| `/edip/reporting` | Reporting Workspace | Decision Products | Patterns, Illuminations, Knowledge Assets |
| `/edip/governance` | Governance | Traceability | Illuminations, Signals, Knowledge Assets |
| `/edip/trd` | TRD Warehouse | Administration | Sources, Traceability, Signals |
| `/edip/compliance` | Compliance | Data Products | Knowledge Assets, Decision Products |
| `/edip/data-products` | Data Products catalog | Data Products | Knowledge Assets |
| `/edip/platform-services` | Platform Services | Knowledge Assets | Administration |
| `/edip/login` | Sign in | Administration | — |

### 2.3 Legacy pages → Tanna sections

| App | Route | Page | Primary | Secondary |
|-----|-------|------|---------|-----------|
| Legacy EDIP | `/` | Home | Overview | — |
| Legacy EDIP | `/login` | Login | Administration | — |
| Legacy EDIP | `/dashboard` | Production Dashboard | Decision Products | Patterns, Illuminations |
| Legacy EDIP | `/governance` | Governance | Illuminations | — |
| Legacy EDIP | `/metadata` | Metadata | Data Products | Traceability |
| Legacy ppdm | `/` | Home | Overview | — |
| Legacy ppdm | `/login` | Login | Administration | — |
| Legacy ppdm | `/warehouse` | Warehouse Core | Traceability | Administration, Signals |
| Legacy ppdm | `/spatial` | Spatial Explorer | Data Products | Decision Products |
| Legacy ppdm | `/production` | Production list | Data Products | Patterns |
| Legacy ppdm | `/production/[pdenId]` | PDEN detail | Data Products | Signals |
| Legacy ppdm | `/reporting` | Reporting | Decision Products | Patterns, Illuminations |
| Legacy ppdm | `/admin` | Admin | Administration | Sources, Knowledge Assets |

### 2.4 Section content migration (transitional petro-reporting)

Governance and TRD pages **split** across multiple Tanna sections when first-class nav is introduced:

| Embedded content today | Source page | Target section |
|------------------------|-------------|----------------|
| DQ / certification cards | `/edip/governance`, Reporting badge | Illuminations |
| KPI tiles, rollups, trends | Executive, Reporting, Production | Patterns |
| Exception tables, volume facts, raw DQ scores | Governance, TRD, Warehouse | Signals |
| Lineage tables, ingest runs | Governance, TRD, Warehouse | Traceability |
| Contract catalog, KPI definitions, specs | Governance, Data Products, Platform | Knowledge Assets |
| Ingest sources, job runner | TRD, Admin | Sources + Administration |

### 2.5 Navigation gaps (require new pages)

| Section | Gap | Minimum future page |
|---------|-----|---------------------|
| Sources | Source dropdown on TRD only; Admin sources list in legacy | Sources browser + registry detail |
| Signals | Exceptions/volumes embedded in other pages | Signals explorer (exceptions, facts, DQ raw) |
| Patterns | KPI tiles scattered | Patterns library / KPI registry |
| Illuminations | Badges and explain stubs only | Illuminations hub (certification, coverage, explain) |
| Traceability | Table-only lineage | Run-scoped trace view; optional graph |

### 2.6 Cross-product navigation (multi-product shell)

```text
/tanna                          ← product picker (registry products)
/tanna/[product]                ← module Overview (uses TannaModuleLayout)
/tanna/[product]/[section]/…    ← intelligence section routes
```

Product picker and suite branding use **Platform shell**; all product work uses **Module shell**.

---

## 3. Shared component architecture

Components live in `@tanna/ui`. Products compose them; they do not fork markup.

### 3.1 Shared cards

| Future component | Current source(s) | Required props | Candidate location |
|------------------|-------------------|----------------|-------------------|
| `TannaKpiCard` | `portal/app/edip/executive/page.tsx`; `portal/app/edip/reporting/page.tsx`; `edip/apps/web/src/app/dashboard/page.tsx`; `ppdm-edip/apps/web/app/reporting/page.tsx` | `id`, `label`, `value`; optional `definition`, `unit`, `variant`, `onExplainToggle` | `@tanna/ui/cards/TannaKpiCard` |
| `TannaSignalCard` | `portal/app/edip/governance/page.tsx`; `edip/apps/web/src/app/governance/page.tsx` | `martId`, coverage pcts, `dqScore`, `certified`, optional `computedAt` | `@tanna/ui/cards/TannaSignalCard` |
| `TannaStatCard` | `portal/app/edip/production/page.tsx`; `ppdm-edip/apps/web/app/production/page.tsx` | `value`, `label` | `@tanna/ui/cards/TannaStatCard` |
| `TannaAreaCard` | `portal/app/page.tsx`; `portal/app/edip/page.tsx` | `href`, `title`, `description`, optional `variant` (`dark` \| `light`) | `@tanna/ui/cards/TannaAreaCard` |
| `TannaInfoCard` | `portal/app/platform/page.tsx`; platform-services; compliance | `title`, `children` | `@tanna/ui/cards/TannaInfoCard` |
| `TannaEntityDetailCard` | PDEN detail pages | `fields: { label, value }[]` | `@tanna/ui/cards/TannaEntityDetailCard` |

### 3.2 Shared tables

| Future component | Current source(s) | Required props | Candidate location |
|------------------|-------------------|----------------|-------------------|
| `TannaDataTable` | 15+ pages | `columns[]`, `rows`, optional `maxHeight`, `emptyMessage`, `stickyHeader` | `@tanna/ui/data/TannaDataTable` |
| `TannaPdenTable` | Executive, Production, Dashboard | `pdens[]`, `showLinkColumn?`, `linkBasePath?` | `@tanna/ui/data/TannaPdenTable` |
| `TannaFactTable` | PDEN detail, Reporting drill-down | `rows`, `columns`, optional `linkColumn` | `@tanna/ui/data/TannaFactTable` |
| `TannaBreakdownTable` | Production rollups, Reporting | `groupKey`, `rows`, `valueColumns` | `@tanna/ui/data/TannaBreakdownTable` |
| `TannaLineageTable` | Governance, TRD, Warehouse, Metadata | `edges[]`, `columnPreset`, optional `limit` | `@tanna/ui/data/TannaLineageTable` |
| `TannaRunTable` | TRD, Warehouse | `runs[]` | `@tanna/ui/data/TannaRunTable` |
| `TannaDqScoreTable` | TRD, Warehouse | `scores[]` | `@tanna/ui/data/TannaDqScoreTable` |
| `TannaSourceTable` | `ppdm-edip/apps/web/app/admin/page.tsx` | `sources[]` | `@tanna/ui/data/TannaSourceTable` |
| `TannaMetadataDictionary` | Data Products, Metadata | `tables[]` | `@tanna/ui/data/TannaMetadataDictionary` |
| `TannaContractCatalog` | Governance, Admin | `entries[]` | `@tanna/ui/data/TannaContractCatalog` |
| `TannaExceptionTable` | Governance, TRD, Warehouse | `exceptions[]` | `@tanna/ui/data/TannaExceptionTable` |

### 3.3 Shared forms

| Future component | Current source(s) | Required props | Candidate location |
|------------------|-------------------|----------------|-------------------|
| `TannaSignInForm` | Login pages (portal, legacy) | `mode`, `onSubmit`, optional `redirectTo`, `errorMessage` | `@tanna/ui/forms/TannaSignInForm` |
| `TannaJobRunForm` | TRD, Admin | `sources[]`, `selectedSourceId`, handlers, `disabled?`, `requiresAuth?` | `@tanna/ui/forms/TannaJobRunForm` |
| `TannaPeriodFilter` | Reporting (portal + ppdm) | `year`, `month`, change handlers, `onRefresh` | `@tanna/ui/filters/TannaPeriodFilter` |
| `TannaFilterBar` | Reporting (portal + ppdm) | `filters`, `onApply`, `onExportCsv?` | `@tanna/ui/filters/TannaFilterBar` |
| `TannaLayerSelector` | Compliance, Spatial | `layers[]`, `selected`, `onChange` | `@tanna/ui/filters/TannaLayerSelector` |

### 3.4 Shared maps

| Future component | Current source(s) | Required props | Candidate location |
|------------------|-------------------|----------------|-------------------|
| `TannaGeoMap` | `portal/components/Map.tsx`; `ppdm-edip/apps/web/components/Map.tsx` | `geojson`, optional `initialView`, `popupFields?` | `@tanna/ui/maps/TannaGeoMap` |
| `TannaSpatialExplorer` | Compliance, Spatial pages | Composes layer selector + map | `@tanna/ui/maps/TannaSpatialExplorer` |

### 3.5 Shared charts

| Future component | Current source(s) | Required props | Candidate location |
|------------------|-------------------|----------------|-------------------|
| `TannaTrendChart` | Executive, legacy dashboard | `data[]`, `dataKey`, optional `title`, `height` | `@tanna/ui/charts/TannaTrendChart` |

Chart styling must read from theme stack — not hardcoded hex values.

### 3.6 Shared navigation

| Future component | Current source(s) | Required props | Candidate location |
|------------------|-------------------|----------------|-------------------|
| `TannaModuleNav` | `EdipNav`, `ClientNav` ×2 | `productShortName`, `workspaceName`, `breadcrumb[]`, `navItems[]`, `pathname`, `authState`, `onSignOut` | `@tanna/ui/navigation/TannaModuleNav` |
| `TannaModuleLayout` | `portal/app/edip/layout.tsx` | `children`, optional `navProps` | `@tanna/ui/navigation/TannaModuleLayout` |
| `TannaBreadcrumb` | EdipNav, platform, back links | `segments[]` | `@tanna/ui/navigation/TannaBreadcrumb` |
| `TannaBackLink` | PDEN detail, platform | `href`, `label` | `@tanna/ui/navigation/TannaBackLink` |
| `TannaPrimaryButton` | Landing CTA | `href`, `label`, optional `variant` | `@tanna/ui/navigation/TannaPrimaryButton` |

### 3.7 Shared feedback and layout helpers

| Future component | Candidate location |
|------------------|-------------------|
| `TannaStatusBadge`, `TannaCoverageSummary`, `TannaAlertInline`, `TannaLoadingState`, `TannaEmptyState` | `@tanna/ui/feedback` |
| `TannaPageHeader`, `TannaSectionHeader`, `TannaPanel`, `TannaCodeBlock` | `@tanna/ui/layout` |
| `TannaAdminJobPanel`, `TannaWarehouseMonitor` | `@tanna/ui/admin` |

### 3.8 Extraction priority

| Priority | Components |
|----------|------------|
| **P0** | `TannaKpiCard`, `TannaDataTable`, `TannaLineageTable`, `TannaFilterBar`, `TannaPeriodFilter`, `TannaGeoMap`, `TannaJobRunForm` |
| **P1** | `TannaSignalCard`, `TannaStatusBadge`, `TannaMetadataDictionary`, `TannaModuleNav`, `TannaModuleLayout` |
| **P2** | `TannaTrendChart`, `TannaSearchPanel` (net-new) |

### 3.9 Platform modules (non-visual)

| Module | Candidate location |
|--------|---------------------|
| `tanna-api-client` | `@tanna/platform/api-client` |

**Component standards are owned by Tanna (`tanna.ts` layer)** — not Bhalo, not product config.

---

## 4. Product configuration architecture

### 4.1 Config file contract

```text
/products/
  index.ts                      ← registry: slug → config (platform-owned)
  petro-core.config.ts            ← LDV registry product
  petro-sight.config.ts           ← LDV registry product
  grid-sight.config.ts            ← LDV registry product
  waste-grid.config.ts            ← LDV registry product
  metaops-studio.config.ts        ← A18 registry product
  recon-intel.config.ts           ← A18 registry product
  wellmind.config.ts              ← A18 registry product
  constituency-os.config.ts       ← A18 registry product
  petro-reporting.config.ts       ← transitional (this repo only; optional)
```

### 4.2 Required registry fields (every product config)

| Field | Type | Authority |
|-------|------|-----------|
| `slug` | string | Must match Product Registry §0.1 |
| `displayName` | string | Must match Product Registry §0.1 |
| `domain` | string | Must match Product Registry §0.1 description |
| **`themeFamily`** | `"ldv"` \| `"a18"` | **Must match registry family — declared only here** |

**Normative rule:** `themeFamily` is read at runtime/build from config. Application code, theme loaders, Cursor agents, and developers **must not**:

- Infer `ldv` vs `a18` from product name, industry words, or repo folder
- Default unconfigured products to either family
- Override config with heuristics (e.g. "oil → ldv", "metadata → a18")
- Branch layout or navigation structure on theme family (family affects **tone and accent**, not intelligence model)

### 4.3 What MUST live in `/products/[product].config.ts`

| Config domain | Contents |
|---------------|----------|
| **Registry identity** | `slug`, `displayName`, `domain`, **`themeFamily`** |
| **Personas** | Primary user roles and decision authority |
| **Decisions** | Decision questions the product supports |
| **Entities** | Domain entities and natural keys |
| **Metrics & KPIs** | Domain-specific KPI catalog |
| **Governance rules** | Product-specific certification/scoring rules |
| **Sources & connectors** | Ingest source types, connector ids |
| **API wiring** | Proxy paths, schema names |
| **Auth wiring** | Token keys, gated actions |
| **Navigation** | Section visibility, route map, nav labels |
| **Decision products** | Registered dashboards/workspaces |
| **Knowledge assets** | Spec and policy references |
| **Business vocabulary** | Domain glossary |
| **Brand / accent overrides** | Logo ref, accent token keys, copy patterns (see Section 6.5) |

**Rule:** If another Tanna module could not reuse it unchanged, it belongs here.

### 4.4 What must NEVER live in product config

| Belongs elsewhere | Package / layer |
|-------------------|-----------------|
| Component markup & layout | `@tanna/ui` |
| Ten-section nav model, module router, JWT helpers | `@tanna/platform` |
| Generic design tokens (slate scale, table header, chart grid) | `tanna.ts`, `ldv.ts`, `a18.ts` |
| IP authority, legal/footer, design philosophy | `bhalo.ts` |
| Connector runtime, infrastructure, generic RBAC | Platform / infra |
| Theme family assignment logic | **Forbidden** — config only |

### 4.5 Config vs theme vs UI boundary

| Concern | Product config | Theme stack | UI components |
|---------|----------------|-------------|---------------|
| `themeFamily: "ldv"` | ✓ required | Resolves `ldv.ts` | — |
| Product logo path | ✓ accent overrides | — | Header renders asset |
| KPI definition text | ✓ KPI catalog | — | `TannaKpiCard` displays |
| Table header background | — | ✓ `tanna.ts` | ✓ applies token |
| Active nav accent color | ✓ accent token key | ✓ family + product merge | ✓ `TannaModuleNav` |
| Footer legal text | — | ✓ `bhalo.ts` only | ✓ footer slot |

---

## 5. Theme architecture (token inventory)

Visual decisions currently live as **inline Tailwind** across three apps. Migration target is the inheritance stack in **Section 6**. This section inventories tokens to centralize (from `THEME_INVENTORY.md`).

### 5.1 Token categories to migrate

| Category | Examples today | Target owner layer |
|----------|----------------|-------------------|
| Colors (shell, workspace, semantic) | slate scale, emerald accent, amber/red/blue | `tanna.ts` + family + product accent |
| Typography | hero, pageTitle, kpiValue, mono | `tanna.ts` |
| Spacing & layout | module padding, max-width, grids | `tanna.ts` |
| Card styles | kpi, stat, signal, area variants | `tanna.ts` |
| Table styles | header, scroll, sticky, empty | `tanna.ts` |
| Chart styles | container, grid, series (replace `#0ea5e9`) | `tanna.ts` + family tone |
| Nav & form controls | header, links, buttons, inputs | `tanna.ts` + family accent |
| Map chrome | wrapper height, background | `tanna.ts` |

### 5.2 Colors (inventory)

| Token group | Values observed | Notes |
|-------------|-----------------|-------|
| Shell dark | `slate-950`, `slate-900`, `slate-900/50`, `slate-700` borders | Platform + module header |
| Workspace light | `slate-50` body, `white` panels | Module main |
| Accent | emerald scale | **Product accent override** — not family default |
| Semantic status | emerald certified, amber not certified | `tanna.ts` semantic tokens |
| Links / errors | `blue-600`, `red-600` | `tanna.ts` |
| Chart series | `#0ea5e9` hardcoded | Must become `chart.series.primary` |

### 5.3 Typography (inventory)

| Token | Classes observed |
|-------|------------------|
| `text.hero` | `text-3xl md:text-4xl font-bold` |
| `text.pageTitle` | `text-2xl font-bold` |
| `text.sectionTitle` | `text-lg font-semibold` |
| `text.kpiValue` | `text-xl font-bold` |
| `text.statValue` | `text-2xl font-bold` |
| `text.ui` / `text.meta` | `text-sm` / `text-xs` |
| `text.eyebrow` | `uppercase tracking-wide` |

### 5.4 Spacing (inventory)

| Token | Values observed |
|-------|-----------------|
| Module padding | `p-4 md:p-6` |
| Content max width | `max-w-7xl` |
| Page stack | `space-y-8`, `space-y-6` |
| Chart / map height | `h-64`, `h-[400px]` |
| Table scroll | `max-h-96`, `max-h-64` |

### 5.5 Card, table, chart styles (inventory)

See v1.0 §5.5–5.7 for full class recipes. All become semantic tokens in `tanna.ts`; accent-bearing variants (e.g. `hover:border-emerald-500`) defer to product accent overrides.

---

## 6. Theme Governance and Inheritance Model

This section is **normative**. It defines who owns what in the theme stack and how layers compose. File names (`bhalo.ts`, `tanna.ts`, `ldv.ts`, `a18.ts`) denote **authority boundaries**, not implementation filenames alone.

### 6.1 Inheritance chain

```text
bhalo.ts
  └── tanna.ts
        ├── ldv.ts          ← when product.config.themeFamily === "ldv"
        └── a18.ts          ← when product.config.themeFamily === "a18"
              └── product accent overrides   ← from /products/[product].config.ts
```

**Resolution order (later wins only where permitted):**

1. `bhalo.ts` — legal/footer, IP metadata (minimal surface presence)
2. `tanna.ts` — intelligence OS visual foundation (layout, components, lifecycle UI)
3. `ldv.ts` **or** `a18.ts` — exactly one, selected by **`themeFamily` from product config**
4. Product accent overrides — logo, slug, vocabulary-driven copy styling, domain accent color keys

**Prohibited:** skipping layers; loading both `ldv.ts` and `a18.ts`; choosing family in theme loader code; merging families per product.

### 6.2 Layer ownership

#### BHALO (`bhalo.ts`)

| Owns | Does not own |
|------|--------------|
| IP / design authority metadata | Layout grids, nav structure, component recipes |
| Design governance policy references | Intelligence section model |
| Brand philosophy documentation hooks | KPI cards, tables, charts |
| Legal/footer content and presence rules | Product domain vocabulary |
| Corporate identity constraints (what Tanna may not contradict) | LDV vs A18 selection |

**Surface rule:** Bhalo appears in **legal/footer presence only** — copyright, attribution, governance links, IP notices. Bhalo does not drive workspace chrome, sidebars, or data UI.

#### TANNA (`tanna.ts`)

| Owns | Does not own |
|------|--------------|
| Intelligence operating system visual foundation | Product logo |
| Layout shells (platform + module) | Domain-specific KPI labels |
| Navigation chrome structure (not product labels) | Industry tone (LDV vs A18) |
| Component standards (card, table, chart, form, map recipes) | Product accent hue selection |
| Intelligence lifecycle UI patterns (Sources → Knowledge Assets) | Legal copy |
| Traceability model presentation (lineage tables, run audit UI) | Footer legal blocks |
| Shared semantic colors (neutral slate, status amber/red, link blue) | Bhalo philosophy text |

**Rule:** All `@tanna/ui` components consume `tanna.ts` tokens by default. Family and product layers may override **accent and tone only** where explicitly allowed.

#### LDV (`ldv.ts`) — family theme

**Applies to:** PetroCore, PetroSight, GridSight, WasteGrid (when `themeFamily: "ldv"` in config).

| Owns | Character |
|------|-----------|
| Industry intelligence theme family | Infrastructure, regulatory, operational tone |
| Family typography adjustments (density, weight bias) | Grounded, operational, field-and-asset readability |
| Family spacing bias (if any) | Favors clarity under data-heavy tables |
| Family accent *defaults* (overridable per product) | Restrained; subordinate to product accent |
| Regulatory/operational mood tokens | Conveys stewardship, compliance adjacency, physical operations |

**Does not own:** product logo, product slug, domain entities, or KPI definitions.

#### A18 (`a18.ts`) — family theme

**Applies to:** MetaOps Studio, ReconIntel, WellMind, ConstituencyOS (when `themeFamily: "a18"` in config).

| Owns | Character |
|------|-----------|
| Enterprise SaaS intelligence theme family | Modern, product-led, AI-native tone |
| Family typography adjustments | Slightly more open rhythm, product-led hierarchy |
| Family motion/elevation bias (when adopted) | Contemporary SaaS feel |
| Family accent *defaults* (overridable per product) | Sharper, product-led |
| AI-native affordance tokens (explain panels, insight callouts) | Supports Illuminations-forward UX |

**Does not own:** product logo, product slug, domain entities, or KPI definitions.

#### Product accent overrides (`/products/[product].config.ts`)

| Owns | Does not own |
|------|--------------|
| Product logo asset reference | Layout shell structure |
| Product slug (routing identity) | Component HTML structure |
| Product vocabulary / domain language | Table column layout primitives |
| Domain-specific KPIs (ids, labels, definitions) | Intelligence lifecycle section list |
| Domain-specific entities | `themeFamily` value for other products |
| Domain-specific decision products (routes, labels) | `ldv.ts` / `a18.ts` token files |
| Accent color token keys (maps into theme) | Bhalo legal text |

**Accent rule:** Product accent overrides **color keys and brand copy only** — not card geometry, table structure, or nav section count.

### 6.3 Theme family selection (authoritative)

```text
product.config.themeFamily  →  load exactly one of ldv.ts | a18.ts
```

| Registry product | Required `themeFamily` |
|------------------|------------------------|
| `petro-core` | `ldv` |
| `petro-sight` | `ldv` |
| `grid-sight` | `ldv` |
| `waste-grid` | `ldv` |
| `metaops-studio` | `a18` |
| `recon-intel` | `a18` |
| `wellmind` | `a18` |
| `constituency-os` | `a18` |

**Enforcement:**

- CI/config validation should reject registry products whose `themeFamily` disagrees with this table.
- Cursor and other agents must treat this table as source of truth — not repository folders, not PETRO/EDIP naming, not API domains.
- Transitional products (`petro-reporting`) must set `themeFamily` explicitly; constitution does not assign it.

### 6.4 Proposed theme package structure (illustrative)

```text
@tanna/theme
├── bhalo.ts                   ← IP, philosophy, legal/footer tokens only
├── tanna.ts                   ← IOS layout, components, intelligence lifecycle
├── families/
│   ├── ldv.ts                 ← LDV family tone
│   └── a18.ts                   ← A18 family tone
├── resolveTheme.ts            ← reads product.config.themeFamily; no inference
├── preset/                    ← Tailwind preset composed from resolved stack
│   colors.ts
│   typography.ts
│   spacing.ts
│   components/                ← card, table, chart, nav, form, map
└── globals.css                ← CSS variables from resolved stack
```

Product accent overrides are **data** passed into `resolveTheme(config)` — not a fifth TypeScript theme file unless generated from config at build time.

### 6.5 What each layer may override

| Token class | bhalo | tanna | ldv/a18 | product accent |
|-------------|-------|-------|---------|----------------|
| Footer legal text | ✓ | — | — | — |
| Module layout width/padding | — | ✓ | — | — |
| Table header geometry | — | ✓ | — | — |
| Nav link structure | — | ✓ | — | — |
| Family font rhythm | — | — | ✓ | — |
| Active link accent hue | — | default | default | ✓ wins |
| Product logo | — | — | — | ✓ |
| CTA / export button accent | — | semantic default | family default | ✓ wins |
| KPI label text | — | — | — | ✓ (config copy) |
| Chart series primary | — | ✓ base | ✓ tone | ✓ optional |

### 6.6 Developer and agent obligations

1. Read `themeFamily` from loaded product config before applying theme.
2. Never add `if (product.includes('petro')) use ldv` or similar heuristics.
3. Never place domain KPI definitions in `ldv.ts` or `a18.ts`.
4. Never place layout primitives in product config or family files.
5. Never place legal/footer content outside `bhalo.ts`.
6. When adding a new registry product, amend §0.1 and §6.3 — do not discover products from code.

---

## 7. Frontend folder structure

Recommended monorepo layout supporting **one portal, eight registry products**, without duplicating layouts or components.

### 7.1 Top-level structure

```text
/
├── apps/
│   └── portal/                          ← single Next.js entry
│       ├── app/
│       │   ├── layout.tsx               ← TannaRootLayout + resolveTheme from active product
│       │   ├── page.tsx                 ← suite landing / product picker (registry)
│       │   └── tanna/
│       │       └── [product]/           ← slug validated against /products registry
│       │           ├── layout.tsx       ← TannaModuleLayout + product config
│       │           ├── overview/
│       │           ├── sources/
│       │           ├── data-products/
│       │           ├── signals/
│       │           ├── patterns/
│       │           ├── illuminations/
│       │           ├── decision-products/
│       │           ├── knowledge-assets/
│       │           ├── traceability/
│       │           └── administration/
│       └── package.json
│
├── packages/
│   ├── ui/                              ← @tanna/ui
│   ├── theme/                           ← @tanna/theme (Section 6 stack)
│   │   ├── bhalo.ts
│   │   ├── tanna.ts
│   │   ├── families/ldv.ts
│   │   ├── families/a18.ts
│   │   └── resolveTheme.ts
│   └── platform/                        ← @tanna/platform
│
├── products/                            ← declarative configs (Section 4)
│   ├── index.ts                         ← eight registry products + optional transitional
│   ├── petro-core.config.ts
│   ├── petro-sight.config.ts
│   ├── grid-sight.config.ts
│   ├── waste-grid.config.ts
│   ├── metaops-studio.config.ts
│   ├── recon-intel.config.ts
│   ├── wellmind.config.ts
│   └── constituency-os.config.ts
│
├── edip/                                ← backend (transitional repo)
├── ppdm-edip/
└── docker-compose.yml
```

### 7.2 Product module routing convention

```text
/tanna/[product]                                    → Overview
/tanna/[product]/sources/…                          → Sources
/tanna/[product]/data-products/…                    → Data Products
/tanna/[product]/signals/…                          → Signals
/tanna/[product]/patterns/…                         → Patterns
/tanna/[product]/illuminations/…                    → Illuminations
/tanna/[product]/decision-products/[workspaceId]    → Decision Products
/tanna/[product]/knowledge-assets/…                 → Knowledge Assets
/tanna/[product]/traceability/…                     → Traceability
/tanna/[product]/administration/…                   → Administration
```

### 7.3 Registry product matrix

| Slug | Display name | `themeFamily` | Domain (from registry) |
|------|--------------|---------------|------------------------|
| `petro-core` | PetroCore | `ldv` | Upstream oil and gas intelligence |
| `petro-sight` | PetroSight | `ldv` | Downstream petroleum intelligence |
| `grid-sight` | GridSight | `ldv` | Electricity/utilities intelligence |
| `waste-grid` | WasteGrid | `ldv` | Municipal waste operations intelligence |
| `metaops-studio` | MetaOps Studio | `a18` | Metadata operations and data governance intelligence |
| `recon-intel` | ReconIntel | `a18` | Settlement reconciliation and commercial intelligence |
| `wellmind` | WellMind | `a18` | WITSML, drilling, and well intelligence |
| `constituency-os` | ConstituencyOS | `a18` | Constituency and public-sector intelligence |

All registry products share: `TannaModuleLayout`, `TannaModuleNav`, `@tanna/ui`, resolved theme stack. None duplicate layout or data-component markup.

### 7.4 Dependency rules (normative)

```text
apps/portal          → @tanna/ui, @tanna/theme, @tanna/platform, /products/*
packages/ui          → @tanna/theme (resolved tanna.ts base only)
packages/theme       → bhalo, tanna, families; resolveTheme reads /products config
/products/*          → pure data; MUST include themeFamily; MUST NOT import packages
```

---

## 8. Governance

### 8.1 Compliance checklist (new frontend work)

Before merging UI work, verify:

- [ ] Uses `TannaModuleLayout` inside a product route
- [ ] Product slug exists in Product Registry §0.1 or is documented transitional
- [ ] `themeFamily` set in product config — not inferred in code
- [ ] Theme resolved via `bhalo → tanna → ldv|a18 → accent` — no bypass
- [ ] Nav items come from product config, not hard-coded arrays
- [ ] No new inline color/spacing recipes — theme tokens only
- [ ] Tables use `TannaDataTable` or documented extension
- [ ] Domain KPIs and vocabulary live in product config only
- [ ] Legal/footer uses `bhalo.ts` presence rules only
- [ ] Page maps to one primary Tanna section
- [ ] No duplicate page across legacy and portal apps

### 8.2 Document lineage

| Constitution section | Primary source |
|------------------------|----------------|
| Product Registry §0.1 | Fixed business context (user-supplied) |
| Layout | `THEME_INVENTORY.md` §5, `TANNA_COMPONENT_INVENTORY.md` §13.4 |
| Navigation | `TANNA_NAVIGATION_ANALYSIS.md` §8–9 |
| Components | `TANNA_COMPONENT_INVENTORY.md` §2–17 |
| Product config | `PRODUCT_CONFIG_PROPOSAL.md` §15–16 |
| Theme inventory §5 | `THEME_INVENTORY.md` §2–9 |
| Theme governance §6 | v1.1 extension (Bhalo/Tanna/LDV/A18 model) |
| Folder structure | `PROJECT_CONTEXT.md`, v1.0 §6 |

### 8.3 Version history

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | — | Initial constitution from repo analyses |
| 1.1 | — | Product Registry; Theme Governance and Inheritance Model; `themeFamily` authority rules |

---

*This constitution is normative for future frontend work. No application code was modified in its creation.*
