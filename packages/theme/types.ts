/** Bhalo layer — legal/footer and IP presence only. */
export type BhaloTokens = {
  ipHolder: string;
  designAuthority: string;
  philosophyRef: string;
  footerBg: string;
  footerText: string;
  footerLink: string;
  footerLinkHover: string;
};

export type SemanticColors = {
  success: string;
  successFg: string;
  warning: string;
  warningFg: string;
  error: string;
  info: string;
  muted: string;
  link: string;
};

export type ShellColors = {
  rootBg: string;
  rootText: string;
  platformBg: string;
  platformText: string;
  shellHeader: string;
  shellHeaderBorder: string;
  workspaceBg: string;
  workspaceText: string;
  panelBg: string;
  panelBorder: string;
};

export type LayoutTokens = {
  moduleMaxWidth: string;
  modulePadding: string;
  platformMaxWidth: string;
  platformPadding: string;
  sectionStack: string;
};

export type TypographyTokens = {
  fontSans: string;
  fontMono: string;
  heroSize: string;
  pageTitleSize: string;
  sectionTitleSize: string;
  uiSize: string;
  metaSize: string;
};

export type CardTokens = {
  radius: string;
  padding: string;
  shadow: string;
  border: string;
  bg: string;
};

export type TableTokens = {
  headerBg: string;
  cellPadding: string;
  border: string;
  fontSize: string;
};

export type FormTokens = {
  inputBorder: string;
  inputPadding: string;
  inputRadius: string;
  buttonRadius: string;
};

export type NavTokens = {
  breadcrumb: string;
  breadcrumbHover: string;
  separator: string;
  link: string;
  linkHover: string;
  active: string;
  activeWeight: string;
};

export type AccentTokens = {
  primary: string;
  primaryHover: string;
  primaryFg: string;
  navActive: string;
  cardHoverBorder: string;
};

export type ChartTokens = {
  containerBg: string;
  containerBorder: string;
  containerHeight: string;
  seriesPrimary: string;
  gridStroke: string;
  axisTick: string;
};

export type MapTokens = {
  wrapperBg: string;
  wrapperBorder: string;
  wrapperHeight: string;
};

export type TannaThemeTokens = {
  shell: ShellColors;
  layout: LayoutTokens;
  typography: TypographyTokens;
  card: CardTokens;
  table: TableTokens;
  form: FormTokens;
  semantic: SemanticColors;
  nav: NavTokens;
  accent: AccentTokens;
  chart: ChartTokens;
  map: MapTokens;
};

export type ThemeFamilyTokens = {
  id: string;
  name: string;
  tone: string;
  mood: string;
  accent: Partial<AccentTokens>;
  chart?: Partial<ChartTokens>;
  typographyDensity?: "compact" | "balanced" | "open";
};

export type ProductAccentOverrides = {
  accentColorKey?: string;
  accent?: Partial<AccentTokens>;
  chart?: Partial<ChartTokens>;
};

export type ResolvedTheme = {
  productSlug: string;
  themeFamily: string;
  accentColorKey: string | null;
  cssVariables: Record<string, string>;
  bodyClassName: string;
  workspaceClassName: string;
  moduleHeaderClassName: string;
  footerClassName: string;
  layers: {
    bhalo: BhaloTokens;
    tanna: TannaThemeTokens;
    family: ThemeFamilyTokens;
    productAccent: ProductAccentOverrides;
  };
};

/** Minimal product input for theme resolution — themeFamily must be explicit. */
export type ThemeProductInput = {
  slug: string;
  themeFamily: string;
  accent?: ProductAccentOverrides;
};
