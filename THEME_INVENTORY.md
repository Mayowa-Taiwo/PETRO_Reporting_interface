# Theme Inventory

Factual inventory of **visual design decisions embedded in frontend source** as of repository inspection.  
**Scope:** `portal/`, `edip/apps/web/`, `ppdm-edip/apps/web/`.  
**Excluded:** Business copy meaning, proposed changes, theme file creation.

---

## 1. How styling is implemented

| Item | Location | What exists |
|------|----------|-------------|
| CSS framework | All apps | Tailwind CSS 3.4 via `@tailwind base/components/utilities` |
| Portal global CSS | `portal/app/globals.css` | Tailwind directives only — no custom rules |
| EDIP legacy global CSS | `edip/apps/web/src/app/globals.css` | Tailwind directives only |
| ppdm legacy global CSS | `ppdm-edip/apps/web/app/globals.css` | Tailwind directives + CSS variables (see Colors) |
| Tailwind config | `portal/tailwind.config.js`, `edip/apps/web/tailwind.config.js`, `ppdm-edip/apps/web/tailwind.config.ts` | `theme: { extend: {} }` — **no custom tokens** |
| Dedicated theme file | — | **None** (`themes/`, design tokens, CSS modules absent) |
| Component style library | — | **None** — classes inline in page/component TSX |
| Chart library | `portal/package.json`, `edip/apps/web/package.json` | `recharts` ^2.12.0 |
| Map library | `portal/package.json`, `ppdm-edip/apps/web/package.json` | `leaflet` ^1.9.4; `react-leaflet` in portal deps (Map uses imperative `require("leaflet")`) |

---

## 2. Colors

All colors are **Tailwind utility class names** or **one hardcoded hex** in Recharts. No centralized color map in repo.

### 2.1 CSS custom properties (ppdm-edip only)

| Variable | Value | File |
|----------|-------|------|
| `--foreground` | `#0f172a` | `ppdm-edip/apps/web/app/globals.css` |
| `--background` | `#f8fafc` | `ppdm-edip/apps/web/app/globals.css` |

Applied: `body { color: var(--foreground); background: var(--background); }` in same file.

### 2.2 Slate (neutral scale)

| Class | Used for | Example files |
|-------|----------|---------------|
| `bg-slate-950` | Dark page background, code block background | `portal/app/layout.tsx`, `portal/app/edip/compliance/page.tsx`, `portal/app/platform/page.tsx` |
| `bg-slate-900` | Header, primary buttons, dark card fill | `portal/components/EdipNav.tsx`, `portal/app/edip/trd/page.tsx`, legacy layouts |
| `bg-slate-900/50` | Semi-transparent dark cards | `portal/app/page.tsx`, `portal/app/platform/page.tsx` |
| `bg-slate-800` | Inline code on dark landing | `portal/app/page.tsx` |
| `bg-slate-700` | Button hover | `portal/app/edip/login/page.tsx`, `portal/app/edip/trd/page.tsx` |
| `bg-slate-300` | Secondary button hover | `portal/app/edip/reporting/page.tsx` |
| `bg-slate-200` | Secondary buttons | `portal/app/edip/reporting/page.tsx` |
| `bg-slate-100` | Table headers, inline code on light | Most table pages; `portal/app/edip/platform-services/page.tsx` |
| `bg-slate-50` | Workspace body | `portal/app/edip/layout.tsx`, `edip/apps/web/src/app/layout.tsx` |
| `text-slate-900` | Workspace body text | `portal/app/edip/layout.tsx`, `portal/app/edip/page.tsx` |
| `text-slate-800` | — | (not observed) |
| `text-slate-700` | Form labels | `ppdm-edip/apps/web/app/login/page.tsx` |
| `text-slate-600` | Subtitles, secondary body, table comments | Widespread workspace pages |
| `text-slate-500` | Muted empty states, KPI labels (reporting) | `portal/app/edip/data-products/page.tsx`, reporting KPI tiles |
| `text-slate-400` | Muted on dark surfaces, KPI meta | `portal/app/page.tsx`, `portal/components/EdipNav.tsx`, executive KPI explain |
| `text-slate-300` | Nav links on dark header, platform body | `portal/components/EdipNav.tsx`, `portal/app/platform/page.tsx` |
| `text-slate-200` | Code block text on dark | `portal/app/edip/compliance/page.tsx` |
| `text-slate-100` | Root body text on dark | `portal/app/layout.tsx` |
| `border-slate-700` | Dark card/header borders | `portal/app/page.tsx`, `portal/components/EdipNav.tsx` |
| `border-slate-200` | Light card borders | `portal/app/edip/page.tsx` |
| `border-slate-600` | Breadcrumb separator tone | `portal/components/EdipNav.tsx` |
| `hover:bg-slate-900` | Dark card hover | `portal/app/page.tsx` |
| `hover:bg-slate-800` | Login submit hover (EDIP legacy) | `edip/apps/web/src/app/login/page.tsx` |
| `hover:bg-slate-300` | Secondary button hover | Reporting pages |
| `hover:text-white` | Muted link hover on dark | `portal/components/EdipNav.tsx`, `portal/app/platform/page.tsx` |

### 2.3 Emerald (accent)

| Class | Used for | Example files |
|-------|----------|---------------|
| `text-emerald-400` | Landing eyebrow, platform link, **active nav link** | `portal/app/page.tsx`, `portal/app/platform/page.tsx`, `portal/components/EdipNav.tsx` |
| `text-emerald-300` | Platform link hover | `portal/app/platform/page.tsx` |
| `bg-emerald-600` | Primary CTA, Export CSV button | `portal/app/page.tsx`, `portal/app/edip/reporting/page.tsx` |
| `bg-emerald-500` | CTA hover | `portal/app/page.tsx` |
| `bg-emerald-700` | Export button hover | `portal/app/edip/reporting/page.tsx` |
| `hover:border-emerald-600/50` | Dark landing card hover border | `portal/app/page.tsx` |
| `hover:border-emerald-500` | Light area card hover border | `portal/app/edip/page.tsx` |
| `bg-emerald-100` / `text-emerald-800` | Certified badge | `portal/app/edip/reporting/page.tsx`, `portal/app/edip/governance/page.tsx`, `edip/apps/web/src/app/governance/page.tsx` |

### 2.4 Amber (warning / not certified)

| Class | Used for | Example files |
|-------|----------|---------------|
| `bg-amber-100` / `text-amber-800` | Not certified badge | `portal/app/edip/reporting/page.tsx`, governance DQ cards |

### 2.5 Blue (links)

| Class | Used for | Example files |
|-------|----------|---------------|
| `text-blue-600` | In-content links | Production, reporting, governance, login back links across portal and legacy apps |
| `hover:underline` | Link hover (with blue or nav) | All link patterns |

### 2.6 Red (errors)

| Class | Used for | Example files |
|-------|----------|---------------|
| `text-red-600` | Form validation errors | `portal/app/edip/login/page.tsx`, legacy login pages |

### 2.7 White

| Class | Used for | Example files |
|-------|----------|---------------|
| `bg-white` | Cards, tables, panels, chart container | Workspace pages throughout |
| `text-white` | Text on dark header, hero, buttons | `portal/app/page.tsx`, `portal/components/EdipNav.tsx`, dark buttons |

### 2.8 Hardcoded hex (non-Tailwind)

| Value | Used for | File |
|-------|----------|------|
| `#0ea5e9` | Recharts line stroke (sky-500 equivalent) | `portal/app/edip/executive/page.tsx` line 94; `edip/apps/web/src/app/dashboard/page.tsx` line 97 |

### 2.9 Default / implicit borders

| Class | Used for | Example files |
|-------|----------|---------------|
| `border` | Default gray border on cards, tables, inputs | Widespread — Tailwind default `border-gray-200` |
| `border-t` | Table row dividers | All tables |

---

## 3. Typography

### 3.1 Font stacks

| Stack | Mechanism | Files |
|-------|-----------|-------|
| **Sans (system)** | Tailwind preflight default; no `@font-face` | All apps via Tailwind |
| **Monospace** | `font-mono` class | Tables, IDs, schema names — e.g. `portal/app/edip/trd/page.tsx`, `portal/app/edip/data-products/page.tsx` |
| **Antialiasing** | `antialiased` on body | `portal/app/layout.tsx` only |

### 3.2 Font sizes and weights (observed classes)

| Pattern | Classes | Typical use | Example files |
|---------|---------|-------------|---------------|
| Hero | `text-3xl md:text-4xl font-bold` | Landing H1 | `portal/app/page.tsx` |
| Platform title | `text-3xl font-bold text-white` | `/platform` H1 | `portal/app/platform/page.tsx` |
| Page title | `text-2xl font-bold` | Workspace H1 | Most `/edip/*` pages, legacy pages |
| Section title | `text-lg font-semibold` (+ `mb-2` or `mb-3`) | H2 sections | Reporting, governance, executive, etc. |
| Form card title | `text-xl font-bold` | Sign in | `portal/app/edip/login/page.tsx` |
| Nav wordmark | `font-bold text-lg` | EDIP Workspace, legacy EDIP logo | `portal/components/EdipNav.tsx`, legacy layouts |
| Card title | `font-semibold` | Area cards, platform sections | `portal/app/edip/page.tsx`, platform-services |
| Body large | `text-lg` | Landing description | `portal/app/page.tsx` |
| Body / UI | `text-sm` | Nav, tables, forms, subtitles | Widespread |
| Meta / labels | `text-xs` | KPI labels, filter labels, code | Reporting, executive, compliance `pre` |
| KPI value | `text-xl font-bold` | KPI tiles | `portal/app/edip/reporting/page.tsx`, executive |
| Stat value | `text-2xl font-bold` | Production stat cards | `portal/app/edip/production/page.tsx` |
| Loading plain | default size | `Loading…` paragraphs | Multiple pages |

### 3.3 Text transforms and tracking

| Class | Use | File |
|-------|-----|------|
| `uppercase tracking-wide` | Landing product eyebrow | `portal/app/page.tsx` |
| `uppercase tracking-wide` | Reporting KPI tile names | `portal/app/edip/reporting/page.tsx` |
| `leading-relaxed` | Landing paragraph | `portal/app/page.tsx` |
| `truncate` | Long exception messages | `portal/app/edip/governance/page.tsx`, `portal/app/edip/trd/page.tsx` |

### 3.4 Document metadata (not rendered typography)

| Field | Value | File |
|-------|-------|------|
| Portal title | `PETRO Reporting Interface` | `portal/app/layout.tsx` |
| EDIP legacy title | `EDIP — Oil & Gas Executive BI` | `edip/apps/web/src/app/layout.tsx` |
| ppdm legacy title | `EDIP — Energy Decision Intelligence Platform` | `ppdm-edip/apps/web/app/layout.tsx` |

---

## 4. Spacing

### 4.1 Page padding and width

| Classes | Use | Files |
|---------|-----|-------|
| `min-h-screen` | Full viewport height | Root layouts, landing, EDIP layout |
| `p-8 md:p-12` | Landing / platform padding | `portal/app/page.tsx`, `portal/app/platform/page.tsx` |
| `p-4 md:p-6` | Workspace main padding | `portal/app/edip/layout.tsx` |
| `p-4` | Legacy main padding | `edip/apps/web/src/app/layout.tsx`, `ppdm-edip/apps/web/app/layout.tsx` |
| `max-w-7xl mx-auto w-full` | Workspace content max width | `portal/app/edip/layout.tsx` |
| `max-w-4xl mx-auto` | Landing content | `portal/app/page.tsx` |
| `max-w-3xl mx-auto` | Platform content | `portal/app/platform/page.tsx` |
| `max-w-2xl mx-auto` | Legacy home | `edip/apps/web/src/app/page.tsx` |
| `max-w-sm mx-auto` | Login card width | Login pages |

### 4.2 Vertical rhythm

| Classes | Use | Files |
|---------|-----|-------|
| `space-y-8` | Page section stack | Executive, reporting, governance, TRD, compliance |
| `space-y-6` | Smaller page stack | Data products, platform-services, loading state |
| `space-y-4` | Form fields, list items | Login forms, platform-services list |
| `mb-12`, `mb-8`, `mb-6`, `mb-4`, `mb-3`, `mb-2`, `mb-1` | Heading / block margins | Throughout |
| `mt-1`, `mt-2`, `mt-4`, `mt-8`, `mt-10`, `mt-12` | Element top margins | Throughout |

### 4.3 Flex and grid gaps

| Classes | Use | Files |
|---------|-----|-------|
| `gap-2`, `gap-3`, `gap-4` | Flex rows, grids, nav | KPI grids, filter bars, governance card grid |
| `grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4` | KPI tiles | `portal/app/edip/reporting/page.tsx` |
| `grid grid-cols-2 sm:grid-cols-3 md:grid-cols-5` | Executive KPI tiles | `portal/app/edip/executive/page.tsx`, legacy dashboard |
| `grid grid-cols-3` | Production stat strip | `portal/app/edip/production/page.tsx` |
| `grid gap-4 md:grid-cols-2` | Landing cards, governance DQ | `portal/app/page.tsx`, governance |
| `grid sm:grid-cols-2 lg:grid-cols-3` | EDIP overview cards | `portal/app/edip/page.tsx` |
| `grid grid-cols-2 gap-2` | Entity `<dl>`, DQ metrics inside card | PDEN detail, governance cards |

### 4.4 Component-internal spacing

| Classes | Use | Files |
|---------|-----|-------|
| `p-2` | Table cells, compact panels, map layer panel | Tables, compliance spatial sidebar |
| `p-4` | KPI cards, stat cards, TRD panel, list cards | Multiple |
| `p-5` | Area cards, compliance section | `portal/app/edip/page.tsx`, compliance |
| `p-6` | Login card | Login pages |
| `px-2 py-1`, `px-3 py-1`, `px-3 py-2`, `px-4 py-2`, `px-6 py-3` | Inputs and buttons | Forms, reporting filters |
| `px-4 py-3` | Header bars | `portal/components/EdipNav.tsx`, legacy headers |
| `px-1`, `px-1.5 py-0.5` | Inline code padding | platform-services, landing code |

### 4.5 Fixed dimensions

| Classes | Use | Files |
|---------|-----|-------|
| `h-64` | Chart height | `portal/app/edip/executive/page.tsx`, legacy dashboard |
| `h-[400px]` | Map viewport | `portal/app/edip/compliance/page.tsx`, `ppdm-edip/apps/web/app/spatial/page.tsx` |
| `max-h-96`, `max-h-64` | Scrollable table areas | data-products, metadata, governance catalog |
| `w-24`, `w-32`, `w-56`, `md:w-56` | Filter inputs, layer sidebar | Reporting filters, compliance spatial |
| `w-full` | Full-width inputs, tables | Forms, tables |

---

## 5. Layouts

### 5.1 Portal root layout (dark shell)

```
html > body.min-h-screen.bg-slate-950.text-slate-100.antialiased
  └── {children}  // no global nav
```

**File:** `portal/app/layout.tsx`

### 5.2 Portal EDIP workspace layout (light shell + nav)

```
div.min-h-screen.flex.flex-col.bg-slate-50.text-slate-900
├── EdipNav (dark header)
└── main.flex-1.p-4.md:p-6.max-w-7xl.mx-auto.w-full
```

**Files:** `portal/app/edip/layout.tsx`, `portal/components/EdipNav.tsx`

### 5.3 Portal landing (`/`)

**File:** `portal/app/page.tsx`

- `main.min-h-screen.p-8.md:p-12`
- Inner `max-w-4xl mx-auto`
- Hero block + emerald CTA + `md:grid-cols-2` link grid

### 5.4 Portal platform (`/platform`)

**File:** `portal/app/platform/page.tsx`

- Same outer padding as landing (inherits root dark body)
- `max-w-3xl mx-auto`
- Stacked `rounded-xl` dark sections

### 5.5 Legacy EDIP web layout

**File:** `edip/apps/web/src/app/layout.tsx`

- `body.min-h-screen.flex.flex-col.bg-slate-50`
- `header.border-b.bg-slate-900.text-white.px-4.py-3.flex.justify-between`
- `main.flex-1.p-4` (no max-width)

### 5.6 Legacy ppdm-edip web layout

**File:** `ppdm-edip/apps/web/app/layout.tsx`

- Same header pattern as EDIP legacy
- Body colors from `globals.css` variables

### 5.7 Split map layout

**Files:** `portal/app/edip/compliance/page.tsx`, `ppdm-edip/apps/web/app/spatial/page.tsx`

- `flex gap-4 flex-col md:flex-row`
- Sidebar + `flex-1` map column

### 5.8 Login-centered layout

**Files:** `portal/app/edip/login/page.tsx`, `edip/apps/web/src/app/login/page.tsx`, `ppdm-edip/apps/web/app/login/page.tsx`

- Centered card: `max-w-sm mx-auto mt-8` (or `mt-12` legacy EDIP)

### 5.9 Page header row pattern

**File:** `portal/app/edip/reporting/page.tsx`

- `flex items-center justify-between` — title left, certification badge right

---

## 6. Cards

No shared Card component. Repeated class combinations:

| Variant | Classes | Files |
|---------|---------|-------|
| **KPI tile** | `border rounded-lg p-4 bg-white shadow-sm` (+ optional `cursor-pointer`) | `portal/app/edip/executive/page.tsx`, `portal/app/edip/reporting/page.tsx`, `edip/apps/web/src/app/dashboard/page.tsx`, `ppdm-edip/apps/web/app/reporting/page.tsx` |
| **Stat tile** | `border rounded p-4 bg-white` (no shadow) | `portal/app/edip/production/page.tsx`, `ppdm-edip/apps/web/app/production/page.tsx` |
| **DQ / governance card** | `border rounded-lg p-4 bg-white shadow-sm` | `portal/app/edip/governance/page.tsx`, `edip/apps/web/src/app/governance/page.tsx` |
| **Dark marketing card** | `rounded-xl border border-slate-700 bg-slate-900/50 p-5 hover:border-emerald-600/50 hover:bg-slate-900 transition-colors` | `portal/app/page.tsx` |
| **Light area card** | `rounded-lg border border-slate-200 bg-white p-5 shadow-sm hover:border-emerald-500 hover:shadow transition-all` | `portal/app/edip/page.tsx` |
| **Dark info section** | `rounded-xl border border-slate-700 bg-slate-900/50 p-5` | `portal/app/platform/page.tsx` |
| **White panel section** | `rounded-lg border bg-white p-4` or `p-5` | `portal/app/edip/trd/page.tsx`, `portal/app/edip/compliance/page.tsx` |
| **Platform service list item** | `border rounded-lg bg-white p-4` | `portal/app/edip/platform-services/page.tsx` |
| **Login card** | `max-w-sm mx-auto p-6 border rounded-lg bg-white shadow` | Portal and legacy login pages |
| **Entity detail panel** | `grid grid-cols-2 gap-2 text-sm bg-white border rounded p-4` | `portal/app/edip/production/[pdenId]/page.tsx` |
| **Spatial layer panel** | `border rounded p-2 bg-white` (+ width constraints) | `portal/app/edip/compliance/page.tsx`, spatial page |

### 6.1 Shadows

| Class | Used on | Files |
|-------|---------|-------|
| `shadow-sm` | KPI cards, area cards | Executive, reporting, EDIP overview |
| `shadow` | Login card | Login pages |
| `hover:shadow` | Light area card hover | `portal/app/edip/page.tsx` |

### 6.2 Border radius

| Class | Used on | Files |
|-------|---------|-------|
| `rounded` | Inputs, buttons, tables, stat cards | Widespread |
| `rounded-lg` | KPI cards, login, area cards, panels | Widespread |
| `rounded-xl` | Landing cards, platform sections | `portal/app/page.tsx`, `portal/app/platform/page.tsx` |

---

## 7. Tables

### 7.1 Standard table pattern

| Element | Classes | Files |
|---------|---------|-------|
| Wrapper | `overflow-x-auto border rounded bg-white` | Governance, executive PDEN table, legacy dashboard |
| Table | `border table-auto w-full text-sm bg-white` **or** `w-full text-sm` | TRD, production, reporting, warehouse, admin |
| Header row | `bg-slate-100` | All data tables |
| Header cell | `text-left p-2` | All data tables |
| Body row | `border-t` | All data tables |
| Body cell | `p-2` | All data tables |
| Right-aligned numeric | `text-right` | Volume columns in PDEN detail, reporting fact table |
| Monospace cells | `font-mono`, often `text-xs` | TRD lineage, IDs, schema dictionary |

### 7.2 Scrollable / sticky header tables

| Feature | Classes | Files |
|---------|---------|-------|
| Vertical scroll + max height | `max-h-96 overflow-y-auto` or `max-h-64 overflow-y-auto` | `portal/app/edip/data-products/page.tsx`, governance catalog, `edip/apps/web/src/app/metadata/page.tsx` |
| Sticky header row | `sticky top-0` on `<tr className="bg-slate-100 sticky top-0">` | data-products, governance catalog, metadata |

### 7.3 Table empty states

| Pattern | Classes | Files |
|---------|---------|-------|
| Inside scroll area | `p-4 text-slate-500` | `portal/app/edip/data-products/page.tsx` |
| Below table | `text-slate-500 py-4` | Reporting no rows |
| Table row colspan | `p-2 text-slate-500` | `ppdm-edip/apps/web/app/warehouse/page.tsx` |

### 7.4 Variations by file

| File | Notable table styling |
|------|------------------------|
| `portal/app/edip/reporting/page.tsx` | Drill-down table without outer `bg-white` on wrapper (`overflow-x-auto` only); operator/top-10 tables use `border table-auto w-full text-sm` |
| `portal/app/edip/executive/page.tsx` | PDEN table: `overflow-x-auto border rounded bg-white`, `w-full text-sm` |
| `portal/app/edip/governance/page.tsx` | Lineage/exceptions: wrapper `overflow-x-auto border rounded bg-white`; catalog adds scroll |
| `portal/app/edip/trd/page.tsx` | Four tables, all `border table-auto w-full text-sm bg-white` |

---

## 8. Charts

Charts exist in **two files only** (portal executive + legacy dashboard).

| Property | Value | Files |
|----------|-------|-------|
| Library | Recharts (`LineChart`, `Line`, `XAxis`, `YAxis`, `CartesianGrid`, `Tooltip`, `ResponsiveContainer`) | `portal/app/edip/executive/page.tsx`, `edip/apps/web/src/app/dashboard/page.tsx` |
| Container | `div.h-64.bg-white.rounded.border.p-2` | Same files |
| Chart height | `ResponsiveContainer width="100%" height="100%"` | Same files |
| Grid | `CartesianGrid strokeDasharray="3 3"` | Same files |
| Axis ticks | `tick={{ fontSize: 10 }}` on X and Y | Same files |
| Line series | `type="monotone" dataKey="boe" stroke="#0ea5e9" name="BOE"` | Same files |
| Tooltip | Default `<Tooltip />` (unstyled) | Same files |
| Section title | `h2.text-lg.font-semibold.mb-3` — "Trend (BOE)" | Same files |

**Not present:** bar charts, area charts, themed chart palette, dark-mode charts. ppdm-edip web has no charts.

---

## 9. Navigation

### 9.1 Portal EDIP navigation component

**File:** `portal/components/EdipNav.tsx`

| Part | Classes / behavior |
|------|-------------------|
| Header container | `border-b border-slate-700 bg-slate-900 text-white` |
| Top row | `px-4 py-3 flex flex-wrap items-center justify-between gap-3` |
| Breadcrumb link "PETRO" | `text-sm text-slate-400 hover:text-white` → `/` |
| Separator | `/` in `text-slate-600` |
| Workspace title link | `font-bold text-lg` → `/edip` |
| Auth link / button | `text-slate-300 hover:text-white text-sm` |
| Nav row | `px-4 pb-2 flex flex-wrap gap-x-4 gap-y-1 text-sm` |
| Active route link | `text-emerald-400 font-medium` |
| Inactive route link | `text-slate-300 hover:text-white` |
| Active detection | `pathname === href` or `pathname.startsWith(href + "/")` |

### 9.2 Legacy ClientNav (×2)

**Files:** `edip/apps/web/src/components/ClientNav.tsx`, `ppdm-edip/apps/web/components/ClientNav.tsx`

| Part | Classes |
|------|---------|
| Nav container | `flex gap-4 items-center` |
| Links | `hover:underline` only — **no active state color** |
| Logout button | `hover:underline text-sm` |

### 9.3 Legacy app headers

**Files:** `edip/apps/web/src/app/layout.tsx`, `ppdm-edip/apps/web/app/layout.tsx`

| Part | Classes |
|------|---------|
| Header | `border-b bg-slate-900 text-white px-4 py-3 flex items-center justify-between` |
| Logo link | `font-bold text-lg` text "EDIP" → `/` |

### 9.4 In-page navigation links

| Pattern | Classes | Files |
|---------|---------|-------|
| Standard link | `text-blue-600 hover:underline` | Production, reporting, governance cross-links |
| Back link | Same blue pattern | PDEN detail pages |
| Landing CTA | `inline-flex items-center gap-2 rounded-lg bg-emerald-600 px-6 py-3 text-base font-semibold text-white hover:bg-emerald-500 transition-colors` | `portal/app/page.tsx` |
| Platform footer link | `text-emerald-400 hover:text-emerald-300 text-sm` | `portal/app/platform/page.tsx` |
| Dark back link | `text-sm text-slate-400 hover:text-white` | `portal/app/platform/page.tsx` |

### 9.5 Forms as navigation-adjacent UI

**Files:** login pages, TRD/admin job forms

| Control | Classes |
|---------|---------|
| Text input | `w-full border rounded px-3 py-2` (+ `mt-1` on portal login) |
| Compact select | `border rounded px-2 py-1` (+ `ml-2` on TRD labels) |
| Primary button | `bg-slate-900 text-white … rounded hover:bg-slate-700` |
| Secondary button | `bg-slate-200 hover:bg-slate-300` + `px-3 py-1 rounded` |
| Accent action | `bg-emerald-600 text-white hover:bg-emerald-700` (Export CSV) |
| Disabled | `disabled:opacity-50` on submit buttons |

---

## 10. Maps

**Map component files:** `portal/components/Map.tsx`, `ppdm-edip/apps/web/components/Map.tsx` (nearly identical)

| Property | Value | Files |
|----------|-------|-------|
| Container div | `w-full h-full` | Both Map.tsx |
| Parent wrapper | `flex-1 h-[400px] border rounded overflow-hidden bg-slate-100` | compliance, spatial pages |
| Tile URL | `https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png` | Map.tsx |
| Tile attribution | `© OpenStreetMap` | Map.tsx |
| Initial view | `setView([9.0, 8.0], 5)` | Map.tsx |
| Markers | Default Leaflet markers | Map.tsx |
| Popup content | `source_pk` property when present | Map.tsx |
| CSS import | `require("leaflet/dist/leaflet.css")` | portal Map.tsx only |
| Layer selector UI | Radio inputs in `flex items-center gap-2 cursor-pointer text-sm` labels | compliance page |

**Not styled in repo:** custom marker icons, polygon styling, map control theming.

---

## 11. Brand assets

No dedicated brand asset folder or design kit in repo.

### 11.1 Text wordmarks (rendered in UI)

| String | Styling | File |
|--------|---------|------|
| `PETRO` | `text-sm text-slate-400 hover:text-white` link | `portal/components/EdipNav.tsx` |
| `PETRO Reporting Interface` | `text-emerald-400 text-sm font-medium tracking-wide uppercase` | `portal/app/page.tsx` |
| `EDIP Workspace` | `font-bold text-lg` white on dark nav | `portal/components/EdipNav.tsx` |
| `EDIP` | `font-bold text-lg` header link | Legacy layouts |
| Hero white title | `text-3xl md:text-4xl font-bold text-white` | `portal/app/page.tsx` |

### 11.2 Status badges (visual brand signals)

| State | Classes | Files |
|-------|---------|-------|
| Certified | `px-2 py-1 rounded text-sm font-medium bg-emerald-100 text-emerald-800` | Reporting header, governance cards |
| Not certified | `px-2 py-1 rounded text-sm font-medium bg-amber-100 text-amber-800` | Same |
| Certified (table) | Plain text "Yes" / "No" | TRD, warehouse DQ tables |

### 11.3 Code / CLI presentation

| Element | Classes | Files |
|---------|---------|-------|
| Dark `pre` block | `text-xs bg-slate-950 text-slate-200 p-3 rounded overflow-x-auto` | `portal/app/edip/compliance/page.tsx` |
| Platform `pre` | `text-xs bg-slate-950 p-3 rounded overflow-x-auto text-slate-300` | `portal/app/platform/page.tsx` |
| Inline code (light) | `text-xs bg-slate-100 px-1` | platform-services |
| Inline code (dark landing) | `text-slate-400 bg-slate-800 px-1.5 py-0.5 rounded` | `portal/app/page.tsx` |
| Inline code in `<dt>` labels | `text-slate-600` on label text | PDEN detail pages |

### 11.4 Motion

| Class | Use | File |
|-------|-----|------|
| `transition-colors` | Landing CTA and dark cards | `portal/app/page.tsx` |
| `transition-all` | EDIP overview cards | `portal/app/edip/page.tsx` |

---

## 12. Logos

| Asset type | Status | Evidence |
|------------|--------|----------|
| SVG logo | **None** | `Glob **/*.{svg,png,ico}` under project apps returned 0 files |
| PNG / ICO favicon | **None** | No `favicon.ico`, `icon.png`, or `app/icon.*` in portal or legacy apps |
| Image-based branding | **None** | No `<Image>` logo components found |
| Wordmark-only branding | **Yes** | Text links "PETRO", "EDIP", "EDIP Workspace" (see §11.1) |

Browser tab icon: **not defined** in inspected layout/metadata files.

---

## 13. Icons

| Asset type | Status | Evidence |
|------------|--------|----------|
| Icon library (Heroicons, Lucide, etc.) | **Not used** | No imports in app TSX |
| SVG icons | **None** in app source | No icon components or files |
| Unicode / text symbols | **Yes** | `→` in CTA "Enter EDIP Workspace →" (`portal/app/page.tsx`); `←` in back links (`portal/app/platform/page.tsx`, PDEN detail) |
| Leaflet default marker icon | **Vendor default** | `portal/components/Map.tsx` |
| Recharts | **No custom icons** | Chart pages |

---

## 14. Buttons (visual inventory)

| Variant | Classes | Files |
|---------|---------|-------|
| Primary dark | `bg-slate-900 text-white px-4 py-2 rounded hover:bg-slate-700` | TRD Run, admin Run |
| Primary dark full-width | `w-full bg-slate-900 text-white py-2 rounded hover:bg-slate-700 disabled:opacity-50` | Login submits |
| Primary dark (legacy EDIP login) | `hover:bg-slate-800` variant | `edip/apps/web/src/app/login/page.tsx` |
| Secondary gray | `px-3 py-1 rounded bg-slate-200 hover:bg-slate-300` | Refresh KPIs, Apply filters |
| Accent emerald | `px-3 py-1 rounded bg-emerald-600 text-white hover:bg-emerald-700` | Export CSV |
| Landing CTA | See §9.4 | `portal/app/page.tsx` |
| Text button (sign out) | Plain button with nav link colors | `EdipNav`, `ClientNav` |

---

## 15. Inputs and selects

| Element | Classes | Files |
|---------|---------|-------|
| Standard input | `border rounded px-3 py-2` (+ `w-full`, `mt-1`) | Login pages |
| Compact select/input | `border rounded px-2 py-1` | Reporting year/month, TRD job form |
| Filter inputs | `border rounded px-2 py-1 w-24` / `w-32` | Reporting drill-down |
| Date input | `border rounded px-2 py-1` | Reporting |
| Radio (map layers) | Native `<input type="radio">` — no custom styling | Compliance, spatial |

---

## 16. Loading and empty states (visual only)

| Pattern | Classes | Files |
|---------|---------|-------|
| Loading paragraph | Plain `<p>` or `text-slate-600` | executive, governance, data-products |
| Loading with padding | `p-4` | legacy dashboard, governance, metadata |
| Empty slate text | `text-slate-500` | data-products, reporting, warehouse |

---

## 17. Cross-app consistency summary

| Visual element | Portal | EDIP legacy | ppdm legacy |
|----------------|--------|-------------|-------------|
| Dark header | EdipNav | slate-900 header | slate-900 header |
| Body background | slate-50 (workspace) / slate-950 (root) | slate-50 | CSS var `#f8fafc` |
| Emerald accent | Yes (nav active, CTA, export) | No nav accent | No nav accent |
| Table pattern | Yes | Yes | Yes |
| Recharts BOE line `#0ea5e9` | Yes | Yes | No |
| Leaflet map | Yes | No | Yes |
| CSS variables | No | No | Yes (foreground/background) |
| Certification badges | Yes | Yes (governance) | Yes (reporting) |

---

## 18. Files that concentrate visual decisions

| File | Visual role |
|------|-------------|
| `portal/app/layout.tsx` | Root dark body |
| `portal/app/edip/layout.tsx` | Workspace light shell |
| `portal/components/EdipNav.tsx` | Primary nav colors and typography |
| `portal/app/page.tsx` | Landing dark marketing layout, emerald CTA, dark cards |
| `portal/app/platform/page.tsx` | Dark documentation layout |
| `portal/app/edip/page.tsx` | Light area card grid |
| `portal/app/edip/reporting/page.tsx` | KPI tiles, badges, filters, buttons, tables |
| `portal/app/edip/executive/page.tsx` | KPI tiles, Recharts chart, PDEN table |
| `portal/app/edip/governance/page.tsx` | DQ cards, badges, tables |
| `portal/app/edip/compliance/page.tsx` | Map layout, dark pre block |
| `portal/components/Map.tsx` | Map tile and marker defaults |
| `edip/apps/web/src/app/layout.tsx` | Legacy header shell |
| `edip/apps/web/src/app/dashboard/page.tsx` | Duplicate executive visual pattern |
| `ppdm-edip/apps/web/app/globals.css` | Only custom CSS variables |
| `ppdm-edip/apps/web/app/reporting/page.tsx` | Duplicate of portal reporting visuals |

---

*Inventory generated from frontend source. No code was modified. No themes were created.*
