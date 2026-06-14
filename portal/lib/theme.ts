import { resolveTheme, validateResolvedTheme, type ResolvedTheme } from "@tanna/theme";
import { validateProductConfig } from "@products/index";
import type { ProductConfig } from "@products/types";

export function productToThemeInput(config: ProductConfig) {
  return {
    slug: config.slug,
    themeFamily: config.themeFamily,
    accent: config.accent,
  };
}

export function resolveProductTheme(config: ProductConfig): ResolvedTheme {
  const productValidation = validateProductConfig(config);
  if (!productValidation.ok) {
    throw new Error(
      `Invalid product config "${config.slug}": ${productValidation.errors.join("; ")}`,
    );
  }

  const theme = resolveTheme(productToThemeInput(config));

  const themeValidation = validateResolvedTheme(theme);
  if (!themeValidation.ok) {
    throw new Error(
      `Theme resolution failed for "${config.slug}": ${themeValidation.errors.join("; ")}`,
    );
  }

  if (process.env.NODE_ENV === "development") {
    console.info("[Tanna] Theme resolved", {
      product: theme.productSlug,
      themeFamily: theme.themeFamily,
      accentColorKey: theme.accentColorKey,
      accentPrimary: theme.cssVariables["--tanna-accent-primary"],
      ipHolder: theme.layers.bhalo.ipHolder,
      family: theme.layers.family.name,
    });
  }

  return theme;
}
