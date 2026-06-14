import { listThemeFamilyIds } from "../packages/theme/familyRegistry";
import { petroleumIntelligenceConfig } from "./petroleum-intelligence.config";
import type { ProductConfig } from "./types";

export type {
  ProductConfig,
  NavigationItem,
  ProductAccentConfig,
} from "./types";
export { petroleumIntelligenceConfig, petroReportingConfig } from "./petroleum-intelligence.config";

/** Dynamic registry — add new products here without changing shared UI. */
const registry: Record<string, ProductConfig> = {
  [petroleumIntelligenceConfig.slug]: petroleumIntelligenceConfig,
};

export function registerProduct(config: ProductConfig): void {
  if (!config.slug) {
    throw new Error("Cannot register product without slug.");
  }
  registry[config.slug] = config;
}

export function getProductConfig(slug: string): ProductConfig {
  const config = registry[slug];
  if (!config) {
    throw new Error(
      `Unknown product slug "${slug}". Register it in products/index.ts via registerProduct().`,
    );
  }
  return config;
}

export function listProductConfigs(): ProductConfig[] {
  return Object.values(registry);
}

export function isRegisteredProduct(slug: string): boolean {
  return slug in registry;
}

export type ProductValidationResult = {
  ok: boolean;
  errors: string[];
};

/** Validates product config fields required for theme resolution. */
export function validateProductConfig(config: ProductConfig): ProductValidationResult {
  const errors: string[] = [];

  if (!config.slug) errors.push("Product config missing slug.");
  if (!config.displayName) errors.push("Product config missing displayName.");
  if (!config.themeFamily) {
    errors.push("Product config missing themeFamily — must be declared explicitly.");
  } else if (!listThemeFamilyIds().includes(config.themeFamily)) {
    errors.push(
      `Unknown themeFamily "${config.themeFamily}". Registered: ${listThemeFamilyIds().join(", ")}`,
    );
  }
  if (!config.footerLegalText) errors.push("Product config missing footerLegalText.");
  if (!config.navigationItems?.length) {
    errors.push("Product config missing navigationItems.");
  }

  return { ok: errors.length === 0, errors };
}
