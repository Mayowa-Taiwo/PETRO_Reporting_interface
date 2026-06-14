# Tanna Frontend Constitution

**Document type:** Frontend architecture constitution  
**Authority:** Bhalo Technologies (IP/design governance) · Tanna Intelligence Operating System (shared frontend law)  
**Status:** Normative — binding on all Tanna product frontends, contributors, tooling, and agents  
**Out of scope:** Application code, refactors, TypeScript generation, component implementation

---

## 1. Purpose and principles

### 1.1 What this document is

This constitution is the **frontend law** for the Tanna Intelligence Operating System. It governs how every Tanna product presents intelligence to users: layout, navigation, components, themes, configuration boundaries, and folder discipline.

It is not a README, not a migration plan, not a portfolio inventory, and not an implementation backlog. Compliance is measured against these rules before any frontend work ships.

**Stability rule:** This document must remain valid as products are added, retired, or reorganized. If launching a product requires amending the constitution, the constitution is wrong.

### 1.2 Authority model

The platform hierarchy is:

```text
Bhalo
  ↓
Tanna
  ↓
Theme Family
  ↓
Product
```

| Layer | Role | Customer-facing UI |
|-------|------|-------------------|
| **Bhalo Technologies** | IP/design authority — philosophy, design governance, legal/footer presence, IP attribution | **Must not dominate** workspace UI |
| **Tanna** | Intelligence operating system — shared architecture, navigation, layout, components, theme resolution, traceability, intelligence lifecycle | **Owns** all product workspace experience |
| **Theme Family** | Visual identity and experience characteristics for a class of products | **Tunes** tone and accent defaults |
| **Product** | Business vocabulary, entities, KPIs, decision products, knowledge assets | **Configures** Tanna via product config |

### 1.3 Intelligence transformation mandate

Every product must support the canonical intelligence transformation:

```text
Data → Context → Intelligence → Decision → Action
```

The frontend expresses this through the intelligence lifecycle (Section 4). No product may bypass a lifecycle stage in navigation or information architecture without explicit product-config documentation and Tanna platform approval.

### 1.4 Binding principles

1. **One operating system** — All products share Tanna layout, navigation sections, and component standards.
2. **Config declares uniqueness** — Domain language, KPIs, entities, and accents live in `/products/[slug].config.ts` only.
3. **Theme family is config, never inferred** — `themeFamily` is read from product config. Cursor, code, developers, and agents must never derive theme family from folders, APIs, README, industry words, product names, or product descriptions.
4. **Bhalo is presence, not chrome** — Legal, IP, and governance attribution appear in footer/legal context only.
5. **No product-specific forks** — No duplicate frontend apps, no per-product layout shells, no hardcoded product names in shared components.
6. **Traceability is first-class** — Lineage, provenance, and run audit UI follow Tanna standards across all products.
7. **Portfolio scales without constitutional change** — New products onboard through configuration and registration, not constitution edits.

---

## 2. Product registry principles

The constitution does **not** enumerate products. Product names, domains, and portfolio composition are **portfolio inventory** — maintained outside this document (e.g. product registry service, `/products/index.ts`, business documentation).

### 2.1 Platform capacity

The platform supports an **unlimited number of products**. Each product is an independent intelligence module that composes the same Tanna frontend architecture.

### 2.2 Separation of concerns

| Concern | Owner |
|---------|-------|
| Visual identity and experience characteristics | **Theme family** (Section 3) |
| Business vocabulary, entities, KPIs, decision products, knowledge assets | **Product config** |
| Layout, navigation model, component standards | **Tanna** (this constitution) |
| IP, legal, footer | **Bhalo** |

The constitution does not care which product exists. It cares that every product follows the same rules.

### 2.3 Product configuration contract

Every product **must** have:

```text
/products/[slug].config.ts
```

Platform registration:

```text
/products/index.ts          ← maps slug → config; grows with portfolio
```

`slug` is a stable product identifier chosen at onboarding. The constitution imposes no fixed slug list.

### 2.4 Product onboarding (normative)

To onboard a new product **without modifying this constitution**:

1. **Create a product configuration** — `/products/[slug].config.ts` with all required fields (Section 6).
2. **Assign a theme family** — set `themeFamily` to a registered theme family implementation (Section 3).
3. **Register the product** — add entry to `/products/index.ts` (or platform registry).
4. **Implement connectors and APIs** as required by the product domain.

**No modification** to shared layouts, navigation model, theme inheritance rules, or component standards should be required for routine product launch.

If onboarding demands a new layout primitive, nav section, or component category, that is a **platform amendment** — distinct from product launch.

### 2.5 What the constitution forbids in product governance

- Embedding product names or slug lists in shared components, layouts, or theme files
- Requiring constitution revision when a new product ships
- Discovering or assigning `themeFamily` from implementation artifacts
- Creating a separate frontend app or dedicated port per product

---

## 3. Theme family principles

The constitution defines **Theme Family** as a concept. It does **not** define today's companies, brand names, or specific family identifiers.

### 3.1 What a theme family is

A **theme family** is a registered implementation that supplies visual identity and experience characteristics for a class of products:

- Typography rhythm and density bias
- Tone (operational, enterprise, product-led, regulatory, etc.)
- Family-level accent defaults (subordinate to product accent)
- Experience affordances appropriate to that class

Theme families are **extension points**. New families may be added by implementing a new family theme file and registering it — without amending this constitution.

### 3.2 What a theme family is not

A theme family is **not**:

- A product
- A company or legal entity
- A substitute for product config
- A reason to fork layout or navigation

### 3.3 Theme family implementations (illustrative)

Today's implementations live in the theme package as files — names are **implementation detail**, not constitutional fact:

```text
/packages/theme/families/
  ldv.ts          ← current implementation
  a18.ts          ← current implementation
  [future].ts     ← future implementations
```

The constitution requires:

- Exactly **one** family implementation resolves per product session
- Resolution key is `product.config.themeFamily` (string matching a registered implementation)
- New families add a file + registry entry in the theme package — not a constitution edit

**Example product configs (illustrative only — not constitutional inventory):**

```ts
// Products declare family; constitution does not name products.
export const exampleIndustryProduct = {
  themeFamily: "ldv",
  domain: "upstream_oil_gas",
};

export const exampleEnterpriseProduct = {
  themeFamily: "a18",
  domain: "metadata_operations",
};
```

### 3.4 Theme family selection rules

1. **`themeFamily` must be declared** in product config.
2. **Must not be inferred** by Cursor, developers, agents, build scripts, or runtime heuristics from:
   - Folder names
   - Industry words
   - APIs
   - README files
   - Product descriptions
   - Domain strings
   - Owning company
3. **Must reference a registered implementation** — unknown `themeFamily` values fail validation at build or runtime.
4. **One family per product** — loading multiple family implementations for one product is forbidden.

### 3.5 Theme family registration (platform concern)

The theme package maintains a **family registry** (implementation catalog). Registering a new family requires:

1. New `families/[id].ts` implementing family token contract
2. Registry entry mapping `themeFamily` id → implementation
3. No change to this constitution

Portfolio documentation may describe which products use which family. That documentation is **not** this constitution.

---

## 4. Shared layout architecture

All products share one layout system owned by **Tanna** (`tanna.ts`). Products do not define alternate shells.

### 4.1 Layout hierarchy

```text
TannaRootLayout
├── ThemeProvider              ← resolves bhalo → tanna → themeFamily → product accent
├── html / body                ← global font, antialiasing, base semantic tokens
└── {children}
    ├── TannaPlatformLayout    ← suite-level entry (product picker, platform docs)
    │   ├── header (minimal)
    │   ├── main
    │   └── footer / legal     ← Bhalo presence (Section 4.4)
    │
    └── TannaModuleLayout      ← all /tanna/[product]/* routes
        ├── TannaModuleNav     ← module header, breadcrumb, lifecycle nav
        ├── main workspace     ← intelligence content (Section 4.3)
        └── footer / legal     ← Bhalo presence (Section 4.4)
```

### 4.2 Layout components

| Component | Owner | Responsibility |
|-----------|-------|----------------|
| **TannaRootLayout** | Tanna | Application root: theme provider, document shell, base body tokens. No product-specific markup. |
| **TannaPlatformLayout** | Tanna | Suite landing and cross-product surfaces. Dark platform shell. Constrained content width. |
| **TannaModuleLayout** | Tanna | Product workspace wrapper. Light workspace body, flex column, mounts `TannaModuleNav` and main. |
| **TannaModuleNav** | Tanna | Dark module header: breadcrumb, product identity (from config), ten-section navigation (from config), auth affordances. |
| **Main workspace** | Tanna | `flex-1` content region: responsive padding, `max-w-7xl` centered container, hosts page composition. |
| **Footer / legal area** | Bhalo + Tanna structure | Renders `footerLegalText` from product config inside Bhalo-governed footer slot. Bhalo content only — no workspace controls. |

### 4.3 Main workspace rules

1. Background and text colors come from `tanna.ts` workspace tokens — not product accent overrides.
2. Page content composes from Tanna layout primitives (Section 6) and intelligence-section pages.
3. Maps and charts use theme-defined container heights inside `TannaPanel` or equivalent.
4. Products may not change workspace max-width, header structure, or footer placement.

### 4.4 Footer and legal area

The footer/legal region is the **only** sanctioned Bhalo-forward surface in module UI.

| Permitted | Prohibited |
|-----------|------------|
| IP attribution | Product navigation |
| Legal notices | KPI tiles |
| Design governance links | Data tables |
| `footerLegalText` from product config | Domain workflow controls |
| Owning-company reference | Bhalo-branded workspace chrome |

Bhalo must not dominate customer-facing product UI.

### 4.5 Shell variants

| Shell | When used | Visual character |
|-------|-----------|------------------|
| **Platform shell** | `/`, product picker, suite documentation | Dark neutral (`tanna.ts` platform tokens) |
| **Module shell** | `/tanna/[product]/*` | Light workspace body, dark module header (`tanna.ts` + theme family + product accent for active nav) |

---

## 5. Shared navigation architecture

### 5.1 Intelligence lifecycle

Every product follows this intelligence lifecycle. Navigation sections map to lifecycle stages:

```text
Sources
  → Data Products
    → Signals
      → Patterns
        → Illuminations
          → Decision Products
            → Knowledge Assets
              → Traceability
                → Administration
```

**Overview** sits above the lifecycle as the module entry — cross-section summary and configured entry points.

### 5.2 Ten canonical sections

Every product **must expose** the same ten top-level sections. Product config controls **labels, routes, visibility, and content** — not the existence of the section model.

| # | Section | Lifecycle role | Typical content |
|---|---------|----------------|-----------------|
| 1 | **Overview** | Entry and orientation | Module home, summary cards, cross-area links |
| 2 | **Sources** | Data origin | Ingest sources, landing zones, feed registry |
| 3 | **Data Products** | Published intelligence inputs | Schemas, marts, entity explorers, spatial layers |
| 4 | **Signals** | Point-in-time measures | Raw values, DQ scores, exceptions, facts |
| 5 | **Patterns** | Derived analytics | KPIs, rollups, trends, rankings |
| 6 | **Illuminations** | Interpreted trust | Certification, coverage, confidence, explain |
| 7 | **Decision Products** | Decision surfaces | Dashboards, drill-down workspaces, exports |
| 8 | **Knowledge Assets** | Institutional knowledge | Contracts, specs, policies, catalogs |
| 9 | **Traceability** | Provenance | Lineage, ingest runs, audit trails |
| 10 | **Administration** | Stewardship | Auth, jobs, tenants, operational control |

### 5.3 Navigation rules

1. **TannaModuleNav** renders sections from `navigationItems` in product config.
2. Active-route styling uses theme resolution (theme family + product accent) — not inline classes.
3. A section may be **hidden** via config (`visible: false`) but the section id must remain registrable in config schema.
4. Every page route must declare a **primary Tanna section** in config or route metadata.
5. No product may introduce eleventh top-level sections in shared nav without Tanna platform amendment.

### 5.4 Routing convention

```text
/tanna/[product]/overview
/tanna/[product]/sources/…
/tanna/[product]/data-products/…
/tanna/[product]/signals/…
/tanna/[product]/patterns/…
/tanna/[product]/illuminations/…
/tanna/[product]/decision-products/…
/tanna/[product]/knowledge-assets/…
/tanna/[product]/traceability/…
/tanna/[product]/administration/…
```

`[product]` must match a slug registered in `/products/index.ts`.

---

## 6. Shared component architecture

All components live in `@tanna/ui`. They implement **Tanna standards** (`tanna.ts`). Products compose them; products do not fork markup. **Shared components must not hardcode product names.**

### 6.1 Cards

| Component | Purpose | Config binding |
|-----------|---------|----------------|
| **TannaKpiCard** | Single metric: label, value, optional definition/unit | `kpiCatalog` |
| **TannaSignalCard** | Signal summary: measure, freshness, DQ adjacency | `signalCatalog` |
| **TannaPatternCard** | Pattern preview: trend, rollup, comparative analytic | `patternCatalog` |
| **TannaIlluminationCard** | Interpretation: certification, coverage, confidence narrative | `illuminationCatalog` |
| **TannaDecisionCard** | Decision product entry: title, blurb, link to workspace | `decisionProducts` |
| **TannaKnowledgeAssetCard** | Knowledge asset entry: spec, policy, catalog reference | `knowledgeAssets` |
| **TannaEntityDetailCard** | Entity attribute panel (`dl` / field list) | `coreEntities` |
| **TannaInfoCard** | Static documentation block (prose, code reference) | config copy fields |

### 6.2 Tables

| Component | Purpose | Lifecycle section |
|-----------|---------|-------------------|
| **TannaDataTable** | Generic column/row table — base primitive | All |
| **TannaLineageTable** | Column-level provenance edges | Traceability |
| **TannaRunTable** | Ingest / job run audit | Traceability, Administration |
| **TannaDqScoreTable** | DQ scores per target | Signals, Traceability |
| **TannaSourceTable** | Source registry listing | Sources |
| **TannaExceptionTable** | Stewardship exceptions | Signals |
| **TannaMetadataDictionary** | Schema / table catalog browser | Data Products, Knowledge Assets |

### 6.3 Forms and filters

| Component | Purpose |
|-----------|---------|
| **TannaSignInForm** | Authentication (mode-aware: platform vs product) |
| **TannaJobRunForm** | Job / ingest execution with source selection |
| **TannaFilterBar** | Multi-field entity or fact filter with apply/export |
| **TannaPeriodFilter** | Calendar period selector (year / month / refresh) |

### 6.4 Maps and charts

| Component | Purpose |
|-----------|---------|
| **TannaGeoMap** | GeoJSON map viewport |
| **TannaSpatialExplorer** | Layer selector + map composition |
| **TannaTrendChart** | Time-series line chart |

Chart series colors resolve through theme stack — no hardcoded hex in components.

### 6.5 Feedback

| Component | Purpose |
|-----------|---------|
| **TannaStatusBadge** | Binary or enumerated status |
| **TannaConfidenceBadge** | Confidence or trust level for illuminations |
| **TannaAlertInline** | Success / error / info inline message |
| **TannaLoadingState** | Data-fetch loading placeholder |
| **TannaEmptyState** | Absence explanation with optional action |

### 6.6 Layout primitives

| Component | Purpose |
|-----------|---------|
| **TannaPageHeader** | Page `h1`, subtitle, optional actions slot |
| **TannaSection** | Vertical section stack |
| **TannaSectionHeader** | Section `h2` and description |
| **TannaPanel** | Bordered content panel |
| **TannaSplitLayout** | Sidebar + main |

### 6.7 Component ownership rule

| Owns component structure | Owns displayed text and domain labels |
|--------------------------|--------------------------------------|
| `tanna.ts` + `@tanna/ui` | `/products/[slug].config.ts` |

Product-specific business language belongs in product config, not shared components.

---

## 7. Product configuration architecture

### 7.1 Required fields

Every `/products/[slug].config.ts` must include:

| Field | Purpose |
|-------|---------|
| `slug` | Stable product identifier |
| `displayName` | User-facing product name |
| `owningCompany` | Corporate attribution |
| **`themeFamily`** | Registered theme family implementation id — **config only, never inferred** |
| `domain` | Product domain descriptor (implementation-defined vocabulary) |
| `tagline` | Product marketing line |
| `logo` | Product logo asset reference |
| `primaryUsers` | Personas and decision authority |
| `primaryDecisions` | Decision questions the product supports |
| `coreEntities` | Domain entities and natural keys |
| `dataSources` | Registered upstream sources |
| `connectorTypes` | Connector identifiers and semantics |
| `navigationItems` | Section ids, labels, hrefs, visibility |
| `overviewCards` | Overview section entry cards |
| `kpiCatalog` | Pattern-layer KPI definitions |
| `signalCatalog` | Signal definitions and bindings |
| `patternCatalog` | Pattern definitions (rollups, trends) |
| `illuminationCatalog` | Certification, coverage, explain rules |
| `decisionProducts` | Dashboards, workspaces, exports |
| `knowledgeAssets` | Specs, policies, catalog refs |
| `traceabilityConfig` | Lineage sources, run tables, audit bindings |
| `apiConfig` | Proxy paths, bases, schema names |
| `authConfig` | Token keys, gated actions |
| `footerLegalText` | Bhalo-governed footer content |

### 7.2 Config rules

1. **Pure data** — Product config must not import UI components, React, or theme implementations.
2. **No theme inference** — Config declares `themeFamily`; nothing else assigns it.
3. **Vocabulary boundary** — Domain terms live in config. Components receive props.
4. **Accent overrides** — Optional accent color keys map into theme resolution; they do not replace layout or component structure.
5. **Navigation authority** — `navigationItems` is the sole source of module nav links.

### 7.3 What must never live in product config

| Excluded | Belongs in |
|----------|------------|
| Component JSX / layout structure | `@tanna/ui` |
| Ten-section model definition | This constitution |
| Generic table geometry | `tanna.ts` |
| Theme family selection logic | **Forbidden** |
| Theme family implementation tokens | `families/[id].ts` |
| JWT mechanics, fetch implementation | `@tanna/platform` |
| Infrastructure | Operations / backend |

---

## 8. Theme architecture

Themes resolve through a **fixed inheritance chain**. No layer may be skipped. No product may load multiple theme family implementations.

### 8.1 Inheritance model

```text
bhalo.ts
  → tanna.ts
    → families/[themeFamily].ts    ← exactly one, from product.config.themeFamily
      → product accent overrides   ← from /products/[slug].config.ts
```

Equivalent conceptual stack:

```text
Bhalo → Tanna → Theme Family → Product
```

**Resolution rule:** `resolveTheme(productConfig)` reads `themeFamily`, loads the registered family implementation, merges layers in order. Later layers override only where permitted (Section 8.3).

**Prohibited:**

- Inferring `themeFamily` from any source other than product config
- Defaulting unconfigured products to any family
- Loading more than one family implementation per product
- Encoding product names or portfolio lists in theme files

### 8.2 Layer responsibilities

#### `bhalo.ts`

| Owns | Does not own |
|------|--------------|
| IP authority metadata | Shared layout |
| Design governance references | Navigation |
| Legal/footer presence rules | Component standards |
| Philosophy reference hooks | Intelligence lifecycle UI |
| Footer typography and spacing tokens | Customer-facing workspace styling |

#### `tanna.ts`

| Owns |
|------|
| Shared layout (platform shell, module shell, workspace, footer slot structure) |
| Navigation chrome (header geometry, nav row, breadcrumb styling) |
| Component standards (all `@tanna/ui` recipes) |
| Intelligence lifecycle UI patterns |
| Cards, tables, charts, maps, forms token recipes |
| Traceability presentation tokens |
| Semantic status colors (success, warning, error, info, neutral) |
| Colors: neutral scale, workspace foreground/background |
| Typography, spacing, table/chart/form/nav/map chrome base tokens |

#### `families/[themeFamily].ts` — theme family implementation

| Owns | Does not own |
|------|--------------|
| Family visual identity and experience characteristics | Product logo or slug |
| Tone and rhythm bias for a product class | Domain KPI definitions |
| Family default accent suggestions (subordinate to product) | Layout structure |
| Family-specific affordance tokens | Product vocabulary |

Each implementation file is registered in the theme package. The constitution does not name or count implementations.

#### Product accent overrides — `/products/[slug].config.ts`

| Owns | Does not own |
|------|--------------|
| Product logo | Layout shell |
| Product slug | Nav section list |
| Product vocabulary / domain language | Component HTML |
| Domain-specific KPIs, signals, patterns, illuminations | Theme family files |
| Domain-specific entities | themeFamily for other products |
| Decision products (ids, routes, labels) | bhalo.ts legal content |
| Optional accent color keys | Tanna component standards |

### 8.3 Token ownership matrix

| Token category | bhalo | tanna | theme family | product accent |
|----------------|-------|-------|--------------|----------------|
| Footer legal text | ✓ | — | — | — |
| Workspace neutral colors | — | ✓ | — | — |
| Active nav / CTA accent | — | default | family default | ✓ wins |
| Semantic status colors | — | ✓ | tone adjust | — |
| Footer typography | ✓ | slot | — | — |
| Workspace typography | — | ✓ | rhythm bias | — |
| Layout spacing | — | ✓ | bias only | — |
| Card/table geometry | — | ✓ | — | — |
| Chart container / grid | — | ✓ | tone | series optional |
| Form control base | — | ✓ | — | accent actions |
| Nav structure | — | ✓ | — | — |
| Map chrome | — | ✓ | — | — |

### 8.4 Semantic status colors

Owned by **`tanna.ts`**. Theme family may adjust tone; product accent must not replace semantic success/warning/error meanings.

### 8.5 Theme package structure (reference)

```text
/packages/theme
  bhalo.ts
  tanna.ts
  families/
    [themeFamily].ts         ← one file per registered implementation
  familyRegistry.ts        ← maps themeFamily id → implementation
  resolveTheme.ts          ← reads product.config.themeFamily; no inference
  preset/
  globals.css
```

Adding a theme family = new `families/[id].ts` + registry entry. **No constitution amendment.**

---

## 9. Frontend folder structure

One portal application serves all products. No per-product frontend apps. No product-specific ports.

```text
/apps
  /portal
    /app
      layout.tsx                    ← TannaRootLayout
      page.tsx                      ← suite / product picker
      /tanna
        /[product]
          layout.tsx                ← TannaModuleLayout + config load
          /overview
          /sources
          /data-products
          /signals
          /patterns
          /illuminations
          /decision-products
          /knowledge-assets
          /traceability
          /administration

/packages
  /ui                               ← @tanna/ui
  /theme                            ← @tanna/theme — Section 8
  /platform                         ← @tanna/platform

/products
  [slug].config.ts                  ← one file per product; unbounded set
  index.ts                          ← registration map; grows with portfolio
```

Legacy or transitional repositories may host interim routes during migration; they must converge on this structure.

---

## 10. Dependency rules

```text
apps/portal
  → MAY import @tanna/ui, @tanna/theme, @tanna/platform, /products/*

packages/ui
  → MAY import @tanna/theme (tanna base tokens)
  → MUST NOT import /products/*
  → MUST NOT hardcode product names

packages/platform
  → MAY import @tanna/theme and shared utilities
  → MUST NOT import /products/* (reads config at runtime via portal)

packages/theme
  → MAY import bhalo, tanna, family implementations
  → resolveTheme MUST accept product config object
  → MUST NOT infer themeFamily
  → MUST NOT enumerate products

/products/*
  → MUST be pure config
  → MUST NOT import UI components
  → MUST NOT import React, Next.js, or theme implementations
  → MUST declare themeFamily referencing registered implementation

shared components (@tanna/ui)
  → MUST NOT hardcode product names, slugs, or domain labels
  → MUST receive domain content via props from config-driven pages
```

---

## 11. Governance checklist

Every frontend change must pass this checklist before merge:

- [ ] Product uses **TannaModuleLayout** for all `/tanna/[product]/*` routes
- [ ] Product slug is **registered** in `/products/index.ts`
- [ ] **`themeFamily` is declared** in product config — not inferred anywhere
- [ ] **`themeFamily` references a registered implementation** in theme family registry
- [ ] **No theme inference** — no heuristics from folders, APIs, README, domain, or product name
- [ ] **Nav comes from config** — `navigationItems`; no hard-coded link arrays
- [ ] **No inline hardcoded styling** where a theme token exists
- [ ] **Domain catalogs** (KPIs, signals, patterns, illuminations) live in product config
- [ ] **Bhalo appears only** in footer/legal/IP context — not workspace chrome
- [ ] **Every page maps** to a primary Tanna section (Section 5)
- [ ] **No duplicate frontend apps** or product-specific ports
- [ ] **Shared components** do not embed product names or domain strings
- [ ] **Product config** does not import UI or theme implementation
- [ ] **Theme resolves** through full chain: bhalo → tanna → themeFamily → product accent
- [ ] **Intelligence lifecycle** respected — content in correct section
- [ ] **Constitution not edited** for routine product launch

---

## Appendix — Document control

| Field | Value |
|-------|-------|
| Title | Tanna Frontend Constitution |
| Governs | All Tanna product frontends in perpetuity |
| IP authority | Bhalo Technologies |
| Operating system | Tanna Intelligence Operating System |
| Product inventory | **Outside** this document — `/products/`, portfolio registry |
| Theme family implementations | **Outside** this document — `/packages/theme/families/` |
| Platform amendment | Required only for new layout, nav section, or component category |
| Product launch | Config + registration only — no constitution edit |

---

*This document is the frontend law for the Tanna Intelligence Operating System. It defines architecture, not portfolio. No application code was created or modified in its authoring.*
