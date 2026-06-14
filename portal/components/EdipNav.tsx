"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { useEffect, useState } from "react";
import { getToken, removeToken } from "@/lib/api";

const NAV = [
  { href: "/edip", label: "Overview", exact: true },
  { href: "/edip/executive", label: "Executive" },
  { href: "/edip/production", label: "Production" },
  { href: "/edip/reporting", label: "Reporting" },
  { href: "/edip/governance", label: "Governance" },
  { href: "/edip/trd", label: "TRD Warehouse" },
  { href: "/edip/compliance", label: "Compliance" },
  { href: "/edip/data-products", label: "Data Products" },
  { href: "/edip/platform-services", label: "Platform Services" },
];

function isActive(pathname: string, href: string, exact?: boolean) {
  if (exact) return pathname === href;
  return pathname === href || pathname.startsWith(`${href}/`);
}

export default function EdipNav() {
  const pathname = usePathname();
  const [hasToken, setHasToken] = useState(false);

  useEffect(() => {
    setHasToken(!!getToken());
  }, [pathname]);

  return (
    <header className="border-b border-slate-700 bg-slate-900 text-white">
      <div className="px-4 py-3 flex flex-wrap items-center justify-between gap-3">
        <div className="flex items-center gap-4">
          <Link href="/" className="text-sm text-slate-400 hover:text-white">
            PETRO
          </Link>
          <span className="text-slate-600">/</span>
          <Link href="/edip" className="font-bold text-lg">
            EDIP Workspace
          </Link>
        </div>
        <div className="flex items-center gap-3 text-sm">
          {hasToken ? (
            <button
              type="button"
              className="text-slate-300 hover:text-white"
              onClick={() => {
                removeToken();
                setHasToken(false);
              }}
            >
              Sign out
            </button>
          ) : (
            <Link href="/edip/login" className="text-slate-300 hover:text-white">
              Sign in
            </Link>
          )}
        </div>
      </div>
      <nav className="px-4 pb-2 flex flex-wrap gap-x-4 gap-y-1 text-sm">
        {NAV.map((item) => (
          <Link
            key={item.href}
            href={item.href}
            className={
              isActive(pathname, item.href, item.exact)
                ? "text-emerald-400 font-medium"
                : "text-slate-300 hover:text-white"
            }
          >
            {item.label}
          </Link>
        ))}
      </nav>
    </header>
  );
}
