/**
 * Lightweight validation for product + theme resolution.
 * Run: npx tsx products/validate.foundation.ts
 */
import { resolveTheme, validateResolvedTheme } from "../packages/theme";
import {
  getProductConfig,
  petroleumIntelligenceConfig,
  validateProductConfig,
} from "./index";

const SLUG = petroleumIntelligenceConfig.slug;

function main() {
  const config = getProductConfig(SLUG);
  const productValidation = validateProductConfig(config);

  if (!productValidation.ok) {
    console.error("Product config validation failed:");
    productValidation.errors.forEach((e) => console.error(`  - ${e}`));
    process.exit(1);
  }

  const theme = resolveTheme({
    slug: config.slug,
    themeFamily: config.themeFamily,
    accent: config.accent,
  });

  const themeValidation = validateResolvedTheme(theme);

  if (!themeValidation.ok) {
    console.error("Theme resolution validation failed:");
    themeValidation.errors.forEach((e) => console.error(`  - ${e}`));
    process.exit(1);
  }

  console.log("Foundation validation passed.");
  console.log(`  product: ${theme.productSlug}`);
  console.log(`  themeFamily: ${theme.themeFamily}`);
  console.log(`  accentColorKey: ${theme.accentColorKey ?? "(none)"}`);
  console.log(`  bhalo.ipHolder: ${theme.layers.bhalo.ipHolder}`);
  console.log(`  family.name: ${theme.layers.family.name}`);
  console.log(`  accent.primary: ${theme.cssVariables["--tanna-accent-primary"]}`);
  console.log(`  chart.series: ${theme.cssVariables["--tanna-chart-series-primary"]}`);
}

main();
