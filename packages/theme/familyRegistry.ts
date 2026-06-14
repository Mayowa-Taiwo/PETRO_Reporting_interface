import { a18Family } from "./families/a18";
import { ldvFamily } from "./families/ldv";
import type { ThemeFamilyTokens } from "./types";

export const familyRegistry: Record<string, ThemeFamilyTokens> = {
  ldv: ldvFamily,
  a18: a18Family,
};

export function getThemeFamily(id: string): ThemeFamilyTokens {
  const family = familyRegistry[id];
  if (!family) {
    throw new Error(
      `Unknown theme family "${id}". Register an implementation in packages/theme/familyRegistry.ts.`,
    );
  }
  return family;
}

export function listThemeFamilyIds(): string[] {
  return Object.keys(familyRegistry);
}
