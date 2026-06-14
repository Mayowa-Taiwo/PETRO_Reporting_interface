"use client";

import { createContext, useContext } from "react";
import type { ProductConfig } from "@products/types";
import type { ResolvedTheme } from "@tanna/theme";

type TannaProductContextValue = {
  config: ProductConfig;
  theme: ResolvedTheme;
};

const TannaProductContext = createContext<TannaProductContextValue | null>(null);

export function TannaProductProvider({
  config,
  theme,
  children,
}: {
  config: ProductConfig;
  theme: ResolvedTheme;
  children: React.ReactNode;
}) {
  return (
    <TannaProductContext.Provider value={{ config, theme }}>
      {children}
    </TannaProductContext.Provider>
  );
}

export function useTannaProduct(): TannaProductContextValue {
  const value = useContext(TannaProductContext);
  if (!value) {
    throw new Error("useTannaProduct must be used within TannaProductProvider");
  }
  return value;
}
