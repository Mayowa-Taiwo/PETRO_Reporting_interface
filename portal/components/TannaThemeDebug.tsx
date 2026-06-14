"use client";

import { useTannaProduct } from "@/context/TannaProductContext";

/** Development-only theme resolution debug panel. */
export default function TannaThemeDebug() {
  if (process.env.NODE_ENV !== "development") {
    return null;
  }

  const { config, theme } = useTannaProduct();

  return (
    <div
      className="fixed bottom-2 right-2 z-50 max-w-xs rounded border border-slate-600 bg-slate-900/95 p-3 text-xs text-slate-300 shadow-lg font-mono"
      aria-label="Tanna theme debug (development only)"
    >
      <p className="font-semibold text-emerald-400 mb-1">Tanna theme (dev)</p>
      <p>product: {theme.productSlug}</p>
      <p>family: {theme.themeFamily}</p>
      <p>accent key: {theme.accentColorKey ?? "—"}</p>
      <p>accent: {theme.cssVariables["--tanna-accent-primary"]}</p>
      <p>bhalo: {theme.layers.bhalo.ipHolder}</p>
      <p>status: {config.status}</p>
    </div>
  );
}
