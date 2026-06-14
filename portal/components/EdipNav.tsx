"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { useEffect, useState } from "react";
import { useTannaProduct } from "@/context/TannaProductContext";
import { getToken, removeToken } from "@/lib/api";

function isActive(pathname: string, href: string, exact?: boolean) {
  if (exact) return pathname === href;
  return pathname === href || pathname.startsWith(`${href}/`);
}

export default function EdipNav() {
  const pathname = usePathname();
  const [hasToken, setHasToken] = useState(false);
  const { config, theme } = useTannaProduct();

  const navItems = config.navigationItems.filter((item) => item.visible !== false);

  useEffect(() => {
    setHasToken(!!getToken());
  }, [pathname]);

  return (
    <header className={theme.moduleHeaderClassName}>
      <div className="px-4 py-3 flex flex-wrap items-center justify-between gap-3">
        <div className="flex items-center gap-4">
          <Link
            href="/"
            className="text-sm text-tanna-nav-breadcrumb hover:text-tanna-nav-breadcrumb-hover"
          >
            {config.shortName}
          </Link>
          <span className="text-tanna-nav-separator">/</span>
          <Link href="/edip" className="font-bold text-lg">
            {config.workspaceName}
          </Link>
        </div>
        <div className="flex items-center gap-3 text-sm">
          {hasToken ? (
            <button
              type="button"
              className="text-tanna-nav-link hover:text-tanna-nav-link-hover"
              onClick={() => {
                removeToken();
                setHasToken(false);
              }}
            >
              Sign out
            </button>
          ) : (
            <Link
              href="/edip/login"
              className="text-tanna-nav-link hover:text-tanna-nav-link-hover"
            >
              Sign in
            </Link>
          )}
        </div>
      </div>
      <nav className="px-4 pb-2 flex flex-wrap gap-x-4 gap-y-1 text-sm">
        {navItems.map((item) => (
          <Link
            key={`${item.href}-${item.label}`}
            href={item.href}
            className={
              isActive(pathname, item.href, item.exact)
                ? "text-tanna-nav-active font-medium"
                : "text-tanna-nav-link hover:text-tanna-nav-link-hover"
            }
          >
            {item.label}
          </Link>
        ))}
      </nav>
    </header>
  );
}
