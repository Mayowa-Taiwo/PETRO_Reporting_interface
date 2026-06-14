# Theme Analysis

**Scope:** Frontend visual design only (`portal/`, `edip/apps/web/`, `ppdm-edip/apps/web/`).  
**Excluded:** Business functionality, domain copy semantics, API behavior, component logic.  
**Method:** Tailwind class inspection, layout/CSS files, chart/map configuration. No code was modified.

---

## Theme Family

**Theme Family:** `LDV / A18`

This value is taken from the assignment header as the designated theme family options. This repository does **not** contain a `themeFamily` constant, `/themes/ldv.ts`, `/themes/a18.ts`, or any CSS branch that selects LDV versus A18. All frontends share one **Tailwind default utility palette** with no custom `theme.extend` entries.

**Implication:** Visual tokens documented below are **observed from the UI**. Platform operators bind them to **`/themes/ldv.ts` when LDV is the active family**, or to **`/themes/a18.ts` when A18 is the active family**. The extracted object is the same today because only one visual implementation exists in source.

---

## 1. Design system baseline

| Aspect | Finding |
|--------|---------|
| **CSS framework** | Tailwind CSS 3.4 (`@tailwind base/components/utilities` only) |
| **Custom theme extension** | None — all `tailwind.config.*` use `theme: { extend: {} }` |
| **CSS variables** | ppdm-edip legacy only: `--foreground: #0f172a`, `--background: #f8fafc` in `globals.css` |
| **Component library** | None — no shadcn, MUI, or design tokens file |
| **Icon set** | None — no SVG logo or icon components in repo |
| **Font loading** | System stack via Tailwind preflight (no `@font-face`, no Google Fonts link) |

---

## 2. Colors

### 2.1 Palette (Tailwind semantic usage)

| Role | Tailwind tokens | Hex (Tailwind v3 defaults) | Where used |
|------|-----------------|----------------------------|------------|
| **Shell dark background** | `bg-slate-950` | `#020617` | Portal root layout, landing `/`, `/platform` |
| **Shell dark text** | `text-slate-100` | `#f1f5f9` | Portal root body |
| **Nav / header dark** | `bg-slate-900`, `border-slate-700` | `#0f172a`, `#334155` | `EdipNav`, legacy app headers |
| **Workspace light background** | `bg-slate-50` | `#f8fafc` | EDIP workspace layout, legacy bodies |
| **Workspace primary text** | `text-slate-900` | `#0f172a` | EDIP workspace layout |
| **Secondary text** | `text-slate-600`, `text-slate-500`, `text-slate-400` | `#475569`, `#64748b`, `#94a3b8` | Subtitles, table meta, nav breadcrumb |
| **Muted nav text** | `text-slate-300` | `#cbd5e1` | Inactive nav links on dark header |
| **Accent (primary)** | `emerald-400`, `emerald-500`, `emerald-600`, `emerald-700` | `#34d399`, `#10b981`, `#059669`, `#047857` | Active nav, landing CTA, export button, hover on cards |
| **Accent eyebrow** | `text-emerald-400` | `#34d399` | Landing product label |
| **Link / action blue** | `text-blue-600`, `hover:underline` | `#2563eb` | In-content links (PDEN links, sign-in, back links) |
| **Primary button dark** | `bg-slate-900`, `hover:bg-slate-700`, `text-white` | `#0f172a`, `#334155` | Sign in, Run job, legacy submit |
| **Secondary button** | `bg-slate-200`, `hover:bg-slate-300` | `#e2e8f0`, `#cbd5e1` | Refresh KPIs, Apply filters |
| **Surface / panel** | `bg-white` | `#ffffff` | Cards, tables, forms inside workspace |
| **Panel border** | `border`, `border-slate-200` (implicit default), `border-slate-700` on dark | default `#e5e7eb` | Cards, tables, inputs |
| **Table header fill** | `bg-slate-100` | `#f1f5f9` | All data tables |
| **Code inline** | `bg-slate-100`, `bg-slate-800` (landing code), `text-slate-300` | varies | Inline `code`, landing paths |
| **Code block dark** | `bg-slate-950`, `text-slate-200` / `text-slate-300` | `#020617` | CLI `pre` blocks (compliance, platform) |
| **Success / certified** | `bg-emerald-100`, `text-emerald-800` | `#d1fae5`, `#065f46` | Certification badges |
| **Warning / not certified** | `bg-amber-100`, `text-amber-800` | `#fef3c7`, `#92400e` | Not certified badges |
| **Error** | `text-red-600` | `#dc2626` | Login form errors |
| **Map canvas** | `bg-slate-100` | `#f1f5f9` | Map container placeholder |
| **Chart line** | `#0ea5e9` (hardcoded, sky-500) | `#0ea5e9` | Recharts BOE line |
| **Chart container** | `bg-white`, `border`, `h-64` | — | Trend chart wrapper |

### 2.2 Dual-surface model (portal)

The primary product uses **two visual surfaces**, not one global theme:

| Surface | Routes | Background | Text | Accent usage |
|---------|--------|------------|------|--------------|
| **Dark marketing shell** | `/`, `/platform` | `slate-950` | `slate-100` / `slate-400` | Emerald CTA + card hover border |
| **Light workspace** | `/edip/*` | `slate-50` | `slate-900` / `slate-600` | Emerald nav active state + export; blue links |

Legacy apps (`edip/apps/web`, `ppdm-edip/apps/web`) use **light workspace only** with a **dark top header** (`bg-slate-900`).

---

## 3. Typography

### 3.1 Font families

| Use | Implementation |
|-----|----------------|
| **UI default** | Tailwind `font-sans` → system UI stack (ui-sans-serif, system-ui, …) |
| **IDs / schema / lineage** | `font-mono` → system monospace |
| **Antialiasing** | `antialiased` on portal root body only |

No custom font files or brand typeface is loaded.

### 3.2 Type scale (observed class patterns)

| Level | Classes | Typical use |
|-------|---------|-------------|
| **Marketing hero** | `text-3xl md:text-4xl font-bold` | Landing H1 |
| **Page title** | `text-2xl font-bold` | Workspace H1 |
| **Platform page title** | `text-3xl font-bold text-white` | `/platform` H1 |
| **Section title** | `text-lg font-semibold` (+ `mb-2` / `mb-3`) | H2 sections |
| **Card / nav title** | `font-bold text-lg` | EDIP Workspace in nav, legacy EDIP logo text |
| **Card subtitle** | `font-semibold` (no size) | Platform service list items |
| **Form title** | `text-xl font-bold` | Sign-in card |
| **Body / subtitle** | `text-lg`, `text-sm`, default | Descriptions |
| **Nav / table body** | `text-sm` | Nav links, tables, forms |
| **Meta / KPI label** | `text-xs`, sometimes `uppercase tracking-wide` | KPI tile labels, reporting KPI names |
| **Monospace data** | `text-sm font-mono`, `text-xs font-mono` | IDs, schema names, lineage columns |
| **KPI value** | `text-xl font-bold`, `text-2xl font-bold` | Tile numbers, stat cards |

### 3.3 Text treatments

| Treatment | Classes | Use |
|-----------|---------|-----|
| **Eyebrow label** | `text-sm font-medium tracking-wide uppercase` + emerald | Landing product name line |
| **Truncation** | `truncate`, `max-w-md`, `max-w-xs` | Exception messages |
| **Prose links** | `hover:underline` | Almost all links |

---

## 4. Spacing

### 4.1 Layout spacing

| Token pattern | Value | Use |
|---------------|-------|-----|
| `p-4`, `md:p-6` | 16px / 24px | Workspace main padding |
| `p-8`, `md:p-12` | 32px / 48px | Landing / platform page padding |
| `px-4 py-3` | 16×12px | Header bars |
| `max-w-7xl mx-auto w-full` | 80rem cap | EDIP workspace content width |
| `max-w-4xl`, `max-w-3xl`, `max-w-2xl`, `max-w-sm` | varied | Landing, platform, login card |
| `space-y-6`, `space-y-8` | 24px / 32px | Vertical section rhythm |
| `gap-3`, `gap-4` | 12px / 16px | Grids, flex rows |
| `mb-12`, `mb-8`, `mb-4`, `mb-3`, `mb-2`, `mb-1`, `mt-1`, `mt-2` | Tailwind scale | Heading margins |

### 4.2 Component spacing

| Component | Padding / gap |
|-----------|-----------------|
| **KPI / stat card** | `p-4` |
| **Info card** | `p-4` or `p-5` |
| **Table cell** | `p-2` |
| **Form field** | `px-3 py-2` or `px-2 py-1` (compact selects) |
| **Button** | `px-3 py-1`, `px-4 py-2`, `px-6 py-3` (CTA) |
| **Nav link row** | `gap-x-4 gap-y-1`, `pb-2` under header |

### 4.3 Grid breakpoints

| Pattern | Breakpoints |
|---------|-------------|
| KPI grid | `grid-cols-2 sm:grid-cols-3 md:grid-cols-4` or `md:grid-cols-5` |
| Stat row | `grid-cols-3` |
| Area cards | `md:grid-cols-2`, `sm:grid-cols-2 lg:grid-cols-3` |
| Spatial layout | `flex-col md:flex-row` |

---

## 5. Card styles

| Card type | Classes | Shadow / radius | Notes |
|-----------|---------|-----------------|-------|
| **KPI tile** | `border rounded-lg p-4 bg-white shadow-sm` | `rounded-lg`, light shadow | Optional `cursor-pointer` |
| **Stat tile** | `border rounded p-4 bg-white` | `rounded`, no shadow | Production summary strip |
| **Governance / DQ card** | `border rounded-lg p-4 bg-white shadow-sm` | same as KPI | Badge in header row |
| **Dark landing card** | `rounded-xl border border-slate-700 bg-slate-900/50 p-5 hover:border-emerald-600/50 hover:bg-slate-900` | xl radius, translucent | Marketing grid |
| **Light area card** | `rounded-lg border border-slate-200 bg-white p-5 shadow-sm hover:border-emerald-500 hover:shadow` | lg radius | EDIP overview grid |
| **Info / platform card** | `rounded-xl border border-slate-700 bg-slate-900/50 p-5` | dark variant | `/platform` |
| **White panel section** | `rounded-lg border bg-white p-4` or `p-5` | used for TRD job block, compliance CLI |
| **Login card** | `max-w-sm mx-auto p-6 border rounded-lg bg-white shadow` | centered narrow card | |
| **Entity detail** | `grid grid-cols-2 gap-2 text-sm bg-white border rounded p-4` | definition list in bordered panel | |

**Card borders:** default Tailwind `border` (gray-200 on light surfaces); dark cards use `border-slate-700`.

---

## 6. Table styles

Consistent pattern across all apps:

| Element | Classes |
|---------|---------|
| **Table** | `border table-auto w-full text-sm` (+ `bg-white` on workspace pages) |
| **Scroll wrapper** | `overflow-x-auto border rounded bg-white` |
| **Sticky header wrapper** | `max-h-96 overflow-y-auto` or `max-h-64` + `sticky top-0` on `<tr>` |
| **Header row** | `bg-slate-100` |
| **Header cell** | `text-left p-2` |
| **Body row** | `border-t` |
| **Body cell** | `p-2`; numeric columns use `text-right` where needed |
| **Monospace cells** | `font-mono`, often `text-xs` |
| **Empty state inside table area** | `p-4 text-slate-500` |

No zebra striping, no row hover state, no sort indicators.

---

## 7. Chart styles

Only one chart pattern exists (Executive / legacy Dashboard):

| Property | Value |
|----------|--------|
| **Library** | Recharts |
| **Container** | `h-64 bg-white rounded border p-2` |
| **Chart type** | `LineChart`, single `Line` |
| **Series color** | `#0ea5e9` (sky-500), hardcoded — not theme token |
| **Grid** | `CartesianGrid strokeDasharray="3 3"` (default stroke color) |
| **Axes** | `tick={{ fontSize: 10 }}` on X and Y |
| **Tooltip** | Default Recharts tooltip (unstyled) |
| **Line style** | `type="monotone"` |

No bar charts, pie charts, or themed chart palette beyond this single line color.

---

## 8. Map styles

| Property | Value |
|----------|--------|
| **Library** | Leaflet (dynamic `require`) |
| **Tiles** | OpenStreetMap `https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png` |
| **Default view** | `[9.0, 8.0], zoom 5` |
| **Markers** | Default Leaflet markers; popup shows `source_pk` |
| **Container** | `w-full h-full` inside `h-[400px] border rounded overflow-hidden bg-slate-100` |
| **Layer panel** | `w-full md:w-56 border rounded p-2 bg-white shrink-0` |
| **Geometry** | Points only in implementation (no styled polygons) |

Map styling is **vendor default**; no custom marker icons or brand colors on map.

---

## 9. Navigation styles

### 9.1 Portal EDIP nav (`EdipNav`)

| Element | Style |
|---------|--------|
| **Header** | `border-b border-slate-700 bg-slate-900 text-white` |
| **Breadcrumb root** | `text-sm text-slate-400 hover:text-white` — text wordmark, not logo |
| **Separator** | `/` in `text-slate-600` |
| **Workspace title** | `font-bold text-lg` white |
| **Nav links inactive** | `text-slate-300 hover:text-white text-sm` |
| **Nav links active** | `text-emerald-400 font-medium text-sm` |
| **Auth control** | `text-slate-300 hover:text-white text-sm` |

### 9.2 Legacy app nav (`ClientNav`)

| Element | Style |
|---------|--------|
| **Header** | `border-b bg-slate-900 text-white px-4 py-3` |
| **Logo** | `font-bold text-lg` text link ("EDIP") |
| **Links** | `hover:underline` gap-4 horizontal list |
| **No active route styling** | Unlike portal EDIP nav |

### 9.3 In-page navigation

| Pattern | Style |
|---------|--------|
| **Back link** | `text-blue-600 hover:underline` |
| **Landing CTA** | `rounded-lg bg-emerald-600 px-6 py-3 text-base font-semibold text-white hover:bg-emerald-500` |

---

## 10. Page layouts

### 10.1 Portal root (`/`)

```
min-h-screen p-8 md:p-12
└ max-w-4xl mx-auto
   ├ eyebrow + hero + CTA
   └ 2-col grid of dark link cards (md:grid-cols-2)
```

Dark full-bleed; no persistent nav bar.

### 10.2 EDIP workspace (`/edip/*`)

```
flex flex-col min-h-screen bg-slate-50 text-slate-900
├ EdipNav (dark header, full width)
└ main flex-1 p-4 md:p-6 max-w-7xl mx-auto w-full
   └ space-y-6|8 sections
```

### 10.3 Legacy apps

```
flex flex-col min-h-screen bg-slate-50
├ dark header (logo + ClientNav)
└ main flex-1 p-4 (unbounded width)
```

### 10.4 Form-centered pages

Login: `max-w-sm mx-auto mt-8` card on workspace background.

### 10.5 Split map layout

Compliance / Spatial: sidebar `md:w-56` + flexible map `flex-1 h-[400px]`.

---

## 11. Logo usage

| Finding | Detail |
|---------|--------|
| **Image logo** | **None** — no SVG, PNG, ICO, or favicon assets in `portal/` |
| **Wordmark "PETRO"** | Text link on landing and EDIP nav breadcrumb (`text-sm` / muted) |
| **Wordmark "EDIP"** | Legacy header `font-bold text-lg`; EDIP nav uses "EDIP Workspace" |
| **Product title in metadata** | `"PETRO Reporting Interface"` — document title only, not rendered as logo |
| **Favicon** | Not defined in inspected app files |

Visual identity is **typographic wordmarks**, not a mark/icon system.

---

## 12. Brand language (visual tone only)

Visual voice derived from styling choices — not product domain copy.

| Attribute | Visual expression |
|-----------|-------------------|
| **Tone** | Enterprise-neutral; dark shell + clean white workspace panels |
| **Density** | Medium — compact tables (`text-sm`, `p-2`), generous section gaps (`space-y-8`) |
| **Emphasis** | Bold page titles; semibold sections; emerald for primary emphasis |
| **Data feel** | Monospace for technical identifiers; muted gray for labels |
| **Status communication** | Soft pills (emerald/amber-100 backgrounds), not icons |
| **Marketing vs tool** | Landing uses uppercase tracked eyebrow + large hero; workspace is utilitarian |
| **Motion** | `transition-colors` on landing cards and CTA only; no animations elsewhere |

**Not part of theme file:** product names (PETRO, EDIP), route labels, KPI names — those belong in product config.

---

## 13. Visual hierarchy

```text
Level 1 — Page title     text-2xl|3xl font-bold
Level 2 — Section title  text-lg font-semibold
Level 3 — Card title     font-semibold | text-xs uppercase (KPI)
Level 4 — Body           text-sm default | text-slate-600
Level 5 — Meta / IDs     text-xs text-slate-400|500 font-mono
```

**Surface hierarchy:** dark header → white content panels → gray table headers → bordered cells.

**Action hierarchy:**

1. Emerald filled buttons (CTA, export)
2. Dark slate filled buttons (primary form actions)
3. Slate-200 secondary buttons
4. Blue text links

**Status hierarchy:** emerald certified > amber not certified > plain text for neutral table values.

---

## 14. Cross-app consistency

| Element | Portal | Legacy EDIP | Legacy ppdm |
|---------|--------|-------------|-------------|
| Header | `EdipNav` dark | `slate-900` header | same |
| Body bg | `slate-50` in workspace | `slate-50` | `#f8fafc` via CSS var |
| Accent | emerald active nav | none on nav | none on nav |
| Tables | identical pattern | identical | identical |
| Charts | Recharts sky line | same | none |
| Landing dark shell | yes | no | no |

**Canonical visual source:** `portal/` (richest: dual surfaces + emerald accent + active nav states).

---

## 15. What belongs in theme files vs elsewhere

| Belongs in `/themes/ldv.ts` or `/themes/a18.ts` | Belongs elsewhere (NOT theme) |
|--------------------------------------------------|-------------------------------|
| Color tokens (slate, emerald, amber, sky, blue, red scales) | Product name, slug, routes |
| Typography scale (size/weight classes → token names) | KPI definitions, entity names |
| Spacing scale, max-width containers | Navigation item labels |
| Card/table/chart/map **style tokens** | API URLs, auth rules |
| Dual-surface definitions (dark shell / light workspace) | Business vocabulary |
| Button variants (primary, secondary, CTA, destructive) | Decision product metadata |
| Badge variants (success, warning) | Feature copy / TRD text |
| Header/nav link states (active, inactive, hover) | `@tanna/ui` component implementations |
| Font family stacks (sans, mono) | Recharts/Leaflet libraries themselves |

---

## 16. Theme file export (Theme Family: `LDV / A18`)

One observed token set exists in the repository. Bind it to the active platform theme file below. **Do not duplicate into both files at runtime** — import one family file per deployment.

### 16.1 When Theme Family = **LDV** → `/themes/ldv.ts`

```typescript
/**
 * LDV theme tokens extracted from PETRO Reporting Interface portal (canonical).
 * Visual identity only — no product names, routes, or domain strings.
 */
export const ldvTheme = {
  family: "LDV",

  colors: {
    shell: {
      dark: { bg: "#020617", text: "#f1f5f9", muted: "#94a3b8" },
      light: { bg: "#f8fafc", text: "#0f172a", muted: "#475569" },
    },
    header: { bg: "#0f172a", border: "#334155", text: "#ffffff" },
    accent: {
      primary: "#059669",
      primaryHover: "#047857",
      primaryLight: "#34d399",
      onDark: "#34d399",
    },
    link: { default: "#2563eb" },
    surface: { panel: "#ffffff", border: "#e5e7eb", subtle: "#f1f5f9" },
    status: {
      success: { bg: "#d1fae5", text: "#065f46" },
      warning: { bg: "#fef3c7", text: "#92400e" },
      error: { text: "#dc2626" },
    },
    button: {
      primary: { bg: "#0f172a", hover: "#334155", text: "#ffffff" },
      secondary: { bg: "#e2e8f0", hover: "#cbd5e1", text: "#0f172a" },
      cta: { bg: "#059669", hover: "#10b981", text: "#ffffff" },
    },
    chart: { seriesPrimary: "#0ea5e9", gridDash: "3 3" },
    code: { blockBg: "#020617", blockText: "#e2e8f0", inlineBg: "#f1f5f9" },
  },

  typography: {
    fontSans: 'ui-sans-serif, system-ui, sans-serif, "Apple Color Emoji", "Segoe UI Emoji"',
    fontMono: 'ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace',
    scale: {
      hero: { size: "2.25rem", weight: 700, mdSize: "2.25rem" },
      pageTitle: { size: "1.5rem", weight: 700 },
      sectionTitle: { size: "1.125rem", weight: 600 },
      body: { size: "0.875rem", weight: 400 },
      label: { size: "0.75rem", weight: 500, uppercase: true, tracking: "0.05em" },
      kpiValue: { size: "1.25rem", weight: 700 },
      statValue: { size: "1.5rem", weight: 700 },
    },
  },

  spacing: {
    page: { sm: "1rem", md: "1.5rem", landing: "2rem", landingMd: "3rem" },
    section: { gap: "2rem" },
    container: { workspace: "80rem", landing: "56rem", narrow: "24rem" },
    card: { padding: "1rem", paddingLg: "1.25rem" },
    table: { cell: "0.5rem" },
  },

  radius: {
    sm: "0.25rem",
    md: "0.5rem",
    lg: "0.75rem",
    xl: "0.75rem",
  },

  shadow: {
    sm: "0 1px 2px 0 rgb(0 0 0 / 0.05)",
    card: "0 1px 2px 0 rgb(0 0 0 / 0.05)",
    login: "0 1px 3px 0 rgb(0 0 0 / 0.1)",
  },

  components: {
    card: {
      kpi: "border rounded-lg p-4 bg-white shadow-sm",
      stat: "border rounded p-4 bg-white",
      darkMarketing:
        "rounded-xl border border-slate-700 bg-slate-900/50 p-5 hover:border-emerald-600/50",
      lightArea:
        "rounded-lg border border-slate-200 bg-white p-5 shadow-sm hover:border-emerald-500",
    },
    table: {
      wrapper: "overflow-x-auto border rounded bg-white",
      base: "border table-auto w-full text-sm bg-white",
      headRow: "bg-slate-100",
      headCell: "text-left p-2",
      row: "border-t",
      cell: "p-2",
    },
    nav: {
      header: "border-b border-slate-700 bg-slate-900 text-white",
      link: "text-sm text-slate-300 hover:text-white",
      linkActive: "text-sm text-emerald-400 font-medium",
      breadcrumb: "text-sm text-slate-400 hover:text-white",
    },
    badge: {
      success: "px-2 py-1 rounded text-sm bg-emerald-100 text-emerald-800",
      warning: "px-2 py-1 rounded text-sm bg-amber-100 text-amber-800",
    },
    input: "border rounded px-3 py-2",
    inputCompact: "border rounded px-2 py-1",
    chartContainer: "h-64 bg-white rounded border p-2",
    mapContainer: "h-[400px] border rounded overflow-hidden bg-slate-100",
  },

  surfaces: {
    marketingDark: { bg: "slate-950", text: "slate-100" },
    workspaceLight: { bg: "slate-50", text: "slate-900" },
  },

  logo: {
    type: "wordmark",
    marks: [], // no image assets in repo
  },
} as const;

export type LdvTheme = typeof ldvTheme;
```

### 16.2 When Theme Family = **A18** → `/themes/a18.ts`

This repository contains **no A18-specific visual branch** (no A18 palette, classes, or assets). Under Theme Family `LDV / A18`, the A18 theme file should **not invent a new brand or palette**.

**Options for platform binding:**

| Approach | Content of `/themes/a18.ts` |
|----------|----------------------------|
| **A18 canonical palette defined externally** | Replace token values with A18 platform canon when available; keep same token **shape** as `ldvTheme` |
| **A18 active but no external canon yet** | Re-export the observed token object under `family: "A18"` until A18 palette is supplied by platform — **same values as extracted**, explicitly temporary |

```typescript
/**
 * A18 theme — structure mirrors LDV export; values must come from A18 platform canon.
 * This product's current UI does not define a separate A18 visual layer in source.
 */
export const a18Theme = {
  family: "A18",
  // Platform: populate from A18 canonical tokens OR interim re-export of observed UI tokens.
  // Do NOT add product-specific strings here.
} as const;
```

**Do not place in `/themes/a18.ts`:** product slugs, EDIP labels, petroleum terminology, or net-new colors not sourced from platform A18 canon.

---

## 17. Gaps (visual)

| Gap | Notes |
|-----|-------|
| **No favicon / app icon** | Browser tab uses default |
| **No design tokens file in repo** | All styling inline in JSX |
| **Chart uses hardcoded hex** | `#0ea5e9` not tied to `emerald` accent |
| **No dark workspace mode** | Only marketing pages are dark |
| **No LDV/A18 CSS split** | Single Tailwind utility implementation |
| **Legacy nav lacks active state** | Portal only highlights active route in emerald |
| **Map / chart vendor defaults** | Not themed beyond container borders |

---

## 18. Summary

The frontend visual system is a **Tailwind utility composition**: **slate neutrals**, **emerald accent**, **blue links**, **emerald/amber status pills**, **white bordered panels**, and **dark slate headers**. Typography is **system sans + mono** with a clear **page → section → card → meta** hierarchy. The portal adds a **dark marketing shell** distinct from the **light EDIP workspace**.

Under Theme Family **`LDV / A18`**, extract these tokens into **`/themes/ldv.ts`** when LDV is bound, or into **`/themes/a18.ts`** when A18 is bound — using the same observed values until platform-supplied A18 canon diverges. Product-specific naming and functionality remain outside theme files.

---

*Document generated from frontend visual inspection. No code was modified.*
