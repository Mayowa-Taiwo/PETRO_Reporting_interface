import { bhaloTheme } from "./bhalo";
import { getThemeFamily } from "./familyRegistry";
import { tannaTheme } from "./tanna";
import type {
  AccentTokens,
  BhaloTokens,
  ChartTokens,
  ProductAccentOverrides,
  ResolvedTheme,
  TannaThemeTokens,
  ThemeProductInput,
} from "./types";

function mergeAccent(base: AccentTokens, ...overrides: Partial<AccentTokens>[]): AccentTokens {
  return Object.assign({}, base, ...overrides.filter(Boolean));
}

function mergeChart(base: ChartTokens, ...overrides: Partial<ChartTokens>[]): ChartTokens {
  return Object.assign({}, base, ...overrides.filter(Boolean));
}

function toCssVariables(
  bhalo: BhaloTokens,
  tanna: TannaThemeTokens,
  accent: AccentTokens,
  chart: ChartTokens,
  productSlug: string,
  themeFamily: string,
  accentColorKey: string | null,
): Record<string, string> {
  return {
    "--bhalo-ip-holder": bhalo.ipHolder,
    "--bhalo-design-authority": bhalo.designAuthority,
    "--bhalo-philosophy-ref": bhalo.philosophyRef,
    "--bhalo-footer-bg": bhalo.footerBg,
    "--bhalo-footer-text": bhalo.footerText,
    "--bhalo-footer-link": bhalo.footerLink,
    "--bhalo-footer-link-hover": bhalo.footerLinkHover,

    "--tanna-shell-root-bg": tanna.shell.rootBg,
    "--tanna-shell-root-text": tanna.shell.rootText,
    "--tanna-shell-platform-bg": tanna.shell.platformBg,
    "--tanna-shell-platform-text": tanna.shell.platformText,
    "--tanna-shell-header": tanna.shell.shellHeader,
    "--tanna-shell-header-border": tanna.shell.shellHeaderBorder,
    "--tanna-shell-workspace-bg": tanna.shell.workspaceBg,
    "--tanna-shell-workspace-text": tanna.shell.workspaceText,
    "--tanna-shell-panel-bg": tanna.shell.panelBg,
    "--tanna-shell-panel-border": tanna.shell.panelBorder,

    /* Tailwind-facing aliases — match bg-tanna-platform, bg-tanna-workspace, etc. */
    "--tanna-platform-bg": tanna.shell.platformBg,
    "--tanna-platform-fg": tanna.shell.platformText,
    "--tanna-workspace-bg": tanna.shell.workspaceBg,
    "--tanna-workspace-fg": tanna.shell.workspaceText,
    "--tanna-header": tanna.shell.shellHeader,
    "--tanna-header-border": tanna.shell.shellHeaderBorder,
    "--tanna-panel-bg": tanna.shell.panelBg,
    "--tanna-panel-border": tanna.shell.panelBorder,

    "--tanna-layout-module-max-width": tanna.layout.moduleMaxWidth,
    "--tanna-layout-module-padding": tanna.layout.modulePadding,
    "--tanna-layout-platform-max-width": tanna.layout.platformMaxWidth,
    "--tanna-layout-platform-padding": tanna.layout.platformPadding,
    "--tanna-layout-section-stack": tanna.layout.sectionStack,

    "--tanna-font-sans": tanna.typography.fontSans,
    "--tanna-font-mono": tanna.typography.fontMono,
    "--tanna-type-hero": tanna.typography.heroSize,
    "--tanna-type-page-title": tanna.typography.pageTitleSize,
    "--tanna-type-section-title": tanna.typography.sectionTitleSize,
    "--tanna-type-ui": tanna.typography.uiSize,
    "--tanna-type-meta": tanna.typography.metaSize,

    "--tanna-card-radius": tanna.card.radius,
    "--tanna-card-padding": tanna.card.padding,
    "--tanna-card-shadow": tanna.card.shadow,
    "--tanna-card-border": tanna.card.border,
    "--tanna-card-bg": tanna.card.bg,

    "--tanna-table-header-bg": tanna.table.headerBg,
    "--tanna-table-cell-padding": tanna.table.cellPadding,
    "--tanna-table-border": tanna.table.border,
    "--tanna-table-font-size": tanna.table.fontSize,

    "--tanna-form-input-border": tanna.form.inputBorder,
    "--tanna-form-input-padding": tanna.form.inputPadding,
    "--tanna-form-input-radius": tanna.form.inputRadius,
    "--tanna-form-button-radius": tanna.form.buttonRadius,

    "--tanna-semantic-success": tanna.semantic.success,
    "--tanna-semantic-success-fg": tanna.semantic.successFg,
    "--tanna-semantic-warning": tanna.semantic.warning,
    "--tanna-semantic-warning-fg": tanna.semantic.warningFg,
    "--tanna-semantic-error": tanna.semantic.error,
    "--tanna-semantic-info": tanna.semantic.info,
    "--tanna-semantic-muted": tanna.semantic.muted,
    "--tanna-semantic-link": tanna.semantic.link,

    "--tanna-nav-breadcrumb": tanna.nav.breadcrumb,
    "--tanna-nav-breadcrumb-hover": tanna.nav.breadcrumbHover,
    "--tanna-nav-separator": tanna.nav.separator,
    "--tanna-nav-link": tanna.nav.link,
    "--tanna-nav-link-hover": tanna.nav.linkHover,
    "--tanna-nav-active": accent.navActive,
    "--tanna-nav-active-weight": tanna.nav.activeWeight,

    "--tanna-accent-primary": accent.primary,
    "--tanna-accent-primary-hover": accent.primaryHover,
    "--tanna-accent-primary-fg": accent.primaryFg,
    "--tanna-accent-card-hover-border": accent.cardHoverBorder,
    "--tanna-accent-color-key": accentColorKey ?? "default",

    "--tanna-chart-container-bg": chart.containerBg,
    "--tanna-chart-container-border": chart.containerBorder,
    "--tanna-chart-container-height": chart.containerHeight,
    "--tanna-chart-series-primary": chart.seriesPrimary,
    "--tanna-chart-grid-stroke": chart.gridStroke,
    "--tanna-chart-axis-tick": chart.axisTick,

    "--tanna-map-wrapper-bg": tanna.map.wrapperBg,
    "--tanna-map-wrapper-border": tanna.map.wrapperBorder,
    "--tanna-map-wrapper-height": tanna.map.wrapperHeight,

    "--tanna-product-slug": productSlug,
    "--tanna-theme-family": themeFamily,
  };
}

/**
 * Resolves: bhalo → tanna → themeFamily (from config) → product accent overrides.
 * Never infers themeFamily from slug, domain, or company name.
 */
export function resolveTheme(product: ThemeProductInput): ResolvedTheme {
  if (!product.slug) {
    throw new Error("Product config is missing slug.");
  }

  if (!product.themeFamily) {
    throw new Error(
      `Product "${product.slug}" is missing themeFamily. Declare it explicitly in product config.`,
    );
  }

  const family = getThemeFamily(product.themeFamily);
  const productAccent: ProductAccentOverrides = product.accent ?? {};

  const accent = mergeAccent(
    tannaTheme.accent,
    family.accent ?? {},
    productAccent.accent ?? {},
  );

  const chart = mergeChart(
    tannaTheme.chart,
    family.chart ?? {},
    productAccent.chart ?? {},
  );

  const cssVariables = toCssVariables(
    bhaloTheme,
    tannaTheme,
    accent,
    chart,
    product.slug,
    family.id,
    productAccent.accentColorKey ?? null,
  );

  return {
    productSlug: product.slug,
    themeFamily: family.id,
    accentColorKey: productAccent.accentColorKey ?? null,
    cssVariables,
    bodyClassName: "min-h-screen antialiased bg-tanna-platform text-tanna-platform-fg",
    workspaceClassName:
      "min-h-screen flex flex-col bg-tanna-workspace text-tanna-workspace-fg",
    moduleHeaderClassName:
      "border-b border-tanna-header-border bg-tanna-header text-white",
    footerClassName: "bg-bhalo-footer text-bhalo-footer-text text-xs px-4 py-3",
    layers: {
      bhalo: bhaloTheme,
      tanna: tannaTheme,
      family,
      productAccent,
    },
  };
}

export { bhaloTheme } from "./bhalo";
export { tannaTheme } from "./tanna";
export { getThemeFamily, familyRegistry, listThemeFamilyIds } from "./familyRegistry";
export type * from "./types";
