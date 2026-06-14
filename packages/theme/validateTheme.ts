import type { ResolvedTheme } from "./types";

export type ThemeValidationResult = {
  ok: boolean;
  errors: string[];
};

export function validateResolvedTheme(theme: ResolvedTheme): ThemeValidationResult {
  const errors: string[] = [];

  if (!theme.productSlug) errors.push("Resolved theme missing productSlug.");
  if (!theme.themeFamily) errors.push("Resolved theme missing themeFamily.");

  if (!theme.layers.bhalo?.ipHolder) errors.push("Bhalo layer missing ipHolder.");
  if (!theme.layers.bhalo?.footerText) errors.push("Bhalo layer missing footer tokens.");

  if (!theme.layers.tanna?.shell?.workspaceBg) errors.push("Tanna layer missing shell tokens.");
  if (!theme.layers.tanna?.card?.bg) errors.push("Tanna layer missing card tokens.");
  if (!theme.layers.tanna?.table?.headerBg) errors.push("Tanna layer missing table tokens.");
  if (!theme.layers.tanna?.chart?.seriesPrimary) errors.push("Tanna layer missing chart tokens.");

  if (!theme.layers.family?.id) errors.push("Theme family layer missing id.");
  if (theme.layers.family.id !== theme.themeFamily) {
    errors.push("Theme family layer id does not match resolved themeFamily.");
  }

  if (!theme.cssVariables["--tanna-accent-primary"]) {
    errors.push("Resolved CSS variables missing product accent primary.");
  }
  if (!theme.cssVariables["--bhalo-footer-text"]) {
    errors.push("Resolved CSS variables missing bhalo footer text.");
  }
  if (!theme.cssVariables["--tanna-theme-family"]) {
    errors.push("Resolved CSS variables missing theme family marker.");
  }

  return { ok: errors.length === 0, errors };
}
