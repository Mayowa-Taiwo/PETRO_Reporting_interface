import EdipNav from "@/components/EdipNav";
import TannaThemeDebug from "@/components/TannaThemeDebug";
import { TannaProductProvider } from "@/context/TannaProductContext";
import { getActiveProductConfig } from "@/lib/product";
import { resolveProductTheme } from "@/lib/theme";

export default function EdipLayout({ children }: { children: React.ReactNode }) {
  const config = getActiveProductConfig();
  const theme = resolveProductTheme(config);

  return (
    <TannaProductProvider config={config} theme={theme}>
      <div
        className={theme.workspaceClassName}
        data-tanna-product={config.slug}
        data-tanna-theme-family={theme.themeFamily}
        data-tanna-accent-key={theme.accentColorKey ?? undefined}
      >
        <EdipNav />
        <main className="flex-1 p-4 md:p-6 max-w-7xl mx-auto w-full">{children}</main>
        <footer className={theme.footerClassName}>
          <span>{config.footerLegalText}</span>
          <span className="block mt-1 opacity-75">
            IP: {theme.layers.bhalo.ipHolder} · Design: {theme.layers.bhalo.designAuthority}
          </span>
        </footer>
        <TannaThemeDebug />
      </div>
    </TannaProductProvider>
  );
}
