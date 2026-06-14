import type { ProductConfig } from "./types";

/**
 * Transitional product config for the current PETRO Reporting Interface portal.
 * themeFamily is declared explicitly — never inferred from name, domain, or routes.
 */
export const petroleumIntelligenceConfig: ProductConfig = {
  slug: "petroleum-intelligence",
  displayName: "Petroleum Intelligence Workspace",
  shortName: "PIW",
  workspaceName: "Petroleum Intelligence Workspace",
  owningCompany: "LDV Consulting Ltd",
  productFamily: "Industry Intelligence",
  status: "transitional",
  themeFamily: "ldv",
  domain: "Petroleum reporting and executive intelligence",
  tagline:
    "Unified petroleum intelligence, governance, traceability, and decision support.",
  logo: null,

  primaryUsers: [
    {
      id: "executive_viewer",
      displayName: "Executive Viewer",
      description: "E&P leadership portfolio decisions",
    },
    { id: "analyst", displayName: "Analyst", description: "Production and asset analysis" },
    {
      id: "data_steward",
      displayName: "Data Steward",
      description: "DQ, lineage, and certification stewardship",
    },
    {
      id: "warehouse_admin",
      displayName: "Warehouse Admin",
      description: "Ingest and TRD operations",
    },
  ],

  primaryDecisions: [
    {
      id: "production_performance",
      question: "How is the company producing this period?",
    },
    {
      id: "mart_trust",
      question: "Is the production mart certified for executive use?",
    },
    { id: "provenance", question: "Where did published mart data come from?" },
    {
      id: "publish_readiness",
      question: "Is it safe to run ingest and publish?",
    },
  ],

  coreEntities: [
    { id: "pden", displayName: "PDEN (Production Entity)", naturalKey: "pden_id" },
    { id: "pden_volume", displayName: "PDEN Volume Summary", naturalKey: "volume_date" },
    { id: "ingest_run", displayName: "Ingest Run", naturalKey: "run_id" },
    { id: "mart", displayName: "Analytic Mart", naturalKey: "mart_id" },
    { id: "spatial_layer", displayName: "Spatial Layer", naturalKey: "layer_id" },
  ],

  dataSources: [
    { id: "edip_marts", name: "EDIP Production Marts", type: "api" },
    { id: "governance_warehouse", name: "TRD Governance Warehouse", type: "api" },
    { id: "ppdm_lite_gold", name: "PPDM Lite Gold", type: "warehouse" },
  ],

  connectorTypes: [
    { id: "ppdm_lite_ingest", label: "PPDM Lite Ingest" },
    { id: "dbt_mart", label: "dbt Mart Transform" },
  ],

  navigationItems: [
    { sectionId: "overview", label: "Overview", href: "/edip", exact: true },
    { sectionId: "decision-products", label: "Executive", href: "/edip/executive" },
    { sectionId: "decision-products", label: "Production", href: "/edip/production" },
    { sectionId: "decision-products", label: "Reporting", href: "/edip/reporting" },
    { sectionId: "traceability", label: "Governance", href: "/edip/governance" },
    { sectionId: "administration", label: "TRD Warehouse", href: "/edip/trd" },
    { sectionId: "data-products", label: "Compliance", href: "/edip/compliance" },
    { sectionId: "data-products", label: "Data Products", href: "/edip/data-products" },
    {
      sectionId: "knowledge-assets",
      label: "Platform Services",
      href: "/edip/platform-services",
    },
  ],

  decisionProducts: [
    {
      id: "executive_dashboard",
      label: "Executive Intelligence",
      href: "/edip/executive",
      description: "KPI tiles, trends, and executive dashboards",
    },
    {
      id: "production_explorer",
      label: "Production Intelligence",
      href: "/edip/production",
      description: "PDEN explorer and volume detail",
    },
    {
      id: "reporting_workspace",
      label: "Reporting Workspace",
      href: "/edip/reporting",
      description: "Drill-down, certification, and CSV export",
    },
    {
      id: "governance_console",
      label: "Governance",
      href: "/edip/governance",
      description: "DQ, lineage, exceptions, contract catalog",
    },
    {
      id: "trd_warehouse",
      label: "TRD Warehouse",
      href: "/edip/trd",
      description: "Ingest runs and warehouse stewardship",
    },
    {
      id: "compliance_spatial",
      label: "Compliance",
      href: "/edip/compliance",
      description: "Spatial assets and schema compliance",
    },
  ],

  knowledgeAssets: [
    {
      id: "trd_bi_suite",
      title: "TRD Oil & Gas Executive BI Suite",
      path: "ppdm-edip/docs/TRD_OIL_GAS_EXECUTIVE_BI_SUITE.md",
      type: "specification",
    },
    {
      id: "mart_star_schema",
      title: "Mart Star Schema Pack",
      path: "ppdm-edip/docs/MART_STAR_SCHEMA_PACK.md",
      type: "specification",
    },
    {
      id: "ppdm_lite",
      title: "PPDM Lite 1.1 DDL",
      type: "schema",
    },
  ],

  traceabilityConfig: {
    lineageEnabled: true,
    runsEnabled: true,
  },

  apiConfig: {
    edip: { proxyPath: "/api/edip", defaultBase: "http://127.0.0.1:8000" },
    governance: { proxyPath: "/api/governance", defaultBase: "http://127.0.0.1:8007" },
  },

  authConfig: {
    tokenKey: "edip_token",
    adminGateActions: ["jobs.run"],
  },

  footerLegalText:
    "© LDV Consulting Ltd · Petroleum Intelligence Workspace on Tanna · IP: Bhalo Technologies · PPDM Lite 1.1",

  accent: {
    accentColorKey: "ldv-emerald",
    accent: {
      primary: "#059669",
      primaryHover: "#10b981",
      primaryFg: "#ffffff",
      navActive: "#34d399",
      cardHoverBorder: "#059669",
    },
    chart: {
      seriesPrimary: "#0d9488",
    },
  },
};

/** @deprecated Use petroleumIntelligenceConfig — kept for transitional import path. */
export const petroReportingConfig = petroleumIntelligenceConfig;
