import { getProductConfig, validateProductConfig } from "@products/index";
import type { ProductConfig } from "@products/types";

/** Active transitional product for the current portal shell. */
export const DEFAULT_PRODUCT_SLUG = "petroleum-intelligence";

export function getActiveProductConfig(): ProductConfig {
  return getProductConfig(DEFAULT_PRODUCT_SLUG);
}

export function getProductConfigBySlug(slug: string): ProductConfig {
  return getProductConfig(slug);
}
