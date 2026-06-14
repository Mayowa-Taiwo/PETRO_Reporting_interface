import type { TannaThemeTokens } from "./types";

/**
 * Tanna Intelligence OS — shared layout, navigation, component standards,
 * intelligence lifecycle UI, semantic status tokens.
 */
export const tannaTheme: TannaThemeTokens = {
  shell: {
    rootBg: "#020617",
    rootText: "#f1f5f9",
    platformBg: "#020617",
    platformText: "#f1f5f9",
    shellHeader: "#0f172a",
    shellHeaderBorder: "#334155",
    workspaceBg: "#f8fafc",
    workspaceText: "#0f172a",
    panelBg: "#ffffff",
    panelBorder: "#e2e8f0",
  },
  layout: {
    moduleMaxWidth: "80rem",
    modulePadding: "1rem",
    platformMaxWidth: "56rem",
    platformPadding: "2rem",
    sectionStack: "2rem",
  },
  typography: {
    fontSans:
      'ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif',
    fontMono: 'ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace',
    heroSize: "2.25rem",
    pageTitleSize: "1.5rem",
    sectionTitleSize: "1.125rem",
    uiSize: "0.875rem",
    metaSize: "0.75rem",
  },
  card: {
    radius: "0.5rem",
    padding: "1rem",
    shadow: "0 1px 2px 0 rgb(0 0 0 / 0.05)",
    border: "#e2e8f0",
    bg: "#ffffff",
  },
  table: {
    headerBg: "#f1f5f9",
    cellPadding: "0.5rem",
    border: "#e2e8f0",
    fontSize: "0.875rem",
  },
  form: {
    inputBorder: "#e2e8f0",
    inputPadding: "0.5rem 0.75rem",
    inputRadius: "0.25rem",
    buttonRadius: "0.25rem",
  },
  semantic: {
    success: "#d1fae5",
    successFg: "#065f46",
    warning: "#fef3c7",
    warningFg: "#92400e",
    error: "#dc2626",
    info: "#64748b",
    muted: "#64748b",
    link: "#2563eb",
  },
  nav: {
    breadcrumb: "#94a3b8",
    breadcrumbHover: "#ffffff",
    separator: "#475569",
    link: "#cbd5e1",
    linkHover: "#ffffff",
    active: "#34d399",
    activeWeight: "500",
  },
  accent: {
    primary: "#059669",
    primaryHover: "#10b981",
    primaryFg: "#ffffff",
    navActive: "#34d399",
    cardHoverBorder: "#10b981",
  },
  chart: {
    containerBg: "#ffffff",
    containerBorder: "#e2e8f0",
    containerHeight: "16rem",
    seriesPrimary: "#0ea5e9",
    gridStroke: "#e2e8f0",
    axisTick: "#64748b",
  },
  map: {
    wrapperBg: "#f1f5f9",
    wrapperBorder: "#e2e8f0",
    wrapperHeight: "400px",
  },
};
