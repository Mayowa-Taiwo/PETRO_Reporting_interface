import type { Metadata } from "next";
import type { CSSProperties } from "react";
import "./globals.css";
import { getActiveProductConfig } from "@/lib/product";
import { resolveProductTheme } from "@/lib/theme";

const productConfig = getActiveProductConfig();
const resolvedTheme = resolveProductTheme(productConfig);

export const metadata: Metadata = {
  title: productConfig.displayName,
  description: productConfig.tagline,
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html
      lang="en"
      data-tanna-product={resolvedTheme.productSlug}
      data-tanna-theme-family={resolvedTheme.themeFamily}
      style={resolvedTheme.cssVariables as CSSProperties}
    >
      <body className={resolvedTheme.bodyClassName}>{children}</body>
    </html>
  );
}
