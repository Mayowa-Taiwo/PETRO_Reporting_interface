/** Product configuration contract — pure data, no UI imports. */

export type ProductAccentConfig = {
  accentColorKey?: string;
  accent?: {
    primary?: string;
    primaryHover?: string;
    primaryFg?: string;
    navActive?: string;
    cardHoverBorder?: string;
  };
  chart?: {
    seriesPrimary?: string;
  };
};

export type NavigationItem = {
  sectionId: string;
  label: string;
  href: string;
  exact?: boolean;
  visible?: boolean;
};

export type ProductConfig = {
  slug: string;
  displayName: string;
  shortName: string;
  workspaceName: string;
  owningCompany: string;
  productFamily: string;
  status: "active" | "transitional" | "deprecated";
  themeFamily: string;
  domain: string;
  tagline: string;
  logo: string | null;
  primaryUsers: { id: string; displayName: string; description?: string }[];
  primaryDecisions: { id: string; question: string }[];
  coreEntities: { id: string; displayName: string; naturalKey?: string }[];
  dataSources: { id: string; name: string; type?: string }[];
  connectorTypes?: { id: string; label: string }[];
  navigationItems: NavigationItem[];
  overviewCards?: { title: string; description: string; href: string }[];
  kpiCatalog?: { id: string; name: string; definition?: string; unit?: string }[];
  signalCatalog?: { id: string; name: string; description?: string }[];
  patternCatalog?: { id: string; name: string; description?: string }[];
  illuminationCatalog?: { id: string; name: string; description?: string }[];
  decisionProducts: { id: string; label: string; href: string; description?: string }[];
  knowledgeAssets: { id: string; title: string; path?: string; type?: string }[];
  traceabilityConfig?: {
    lineageEnabled: boolean;
    runsEnabled: boolean;
  };
  apiConfig?: {
    edip?: { proxyPath: string; defaultBase?: string };
    governance?: { proxyPath: string; defaultBase?: string };
  };
  authConfig?: {
    tokenKey: string;
    adminGateActions?: string[];
  };
  footerLegalText: string;
  accent?: ProductAccentConfig;
};
