import Link from "next/link";
import { getActiveProductConfig } from "@/lib/product";

const PLATFORM_CARD = {
  title: "LDV Platform Core",
  description:
    "Shared Python services for domain logic, compliance, and intelligence (no separate UI).",
  href: "/platform",
};

export default function Home() {
  const config = getActiveProductConfig();

  return (
    <main className="min-h-screen p-8 md:p-12">
      <div className="max-w-4xl mx-auto">
        <p className="text-emerald-400 text-sm font-medium tracking-wide uppercase mb-2">
          {config.displayName}
        </p>
        <h1 className="text-3xl md:text-4xl font-bold text-white mb-4">{config.tagline}</h1>
        <p className="text-slate-400 text-lg mb-8 leading-relaxed">
          A unified workspace for petroleum reporting, executive intelligence, production visibility,
          governance, TRD warehouse management, and compliance intelligence — one product shell,
          one entry point.
        </p>

        <Link
          href="/edip"
          className="inline-flex items-center gap-2 rounded-lg bg-emerald-600 px-6 py-3 text-base font-semibold text-white hover:bg-emerald-500 transition-colors mb-12"
        >
          Enter {config.workspaceName} →
        </Link>

        <h2 className="text-lg font-semibold text-white mb-4">Workspace areas</h2>
        <div className="grid gap-4 md:grid-cols-2">
          {config.decisionProducts.slice(0, 6).map((s) => (
            <Link
              key={s.href}
              href={s.href}
              className="rounded-xl border border-slate-700 bg-slate-900/50 p-5 hover:border-emerald-600/50 hover:bg-slate-900 transition-colors block"
            >
              <h3 className="text-white font-semibold mb-1">{s.label}</h3>
              <p className="text-sm text-slate-400">{s.description}</p>
            </Link>
          ))}
          <Link
            href={PLATFORM_CARD.href}
            className="rounded-xl border border-slate-700 bg-slate-900/50 p-5 hover:border-emerald-600/50 hover:bg-slate-900 transition-colors block"
          >
            <h3 className="text-white font-semibold mb-1">{PLATFORM_CARD.title}</h3>
            <p className="text-sm text-slate-400">{PLATFORM_CARD.description}</p>
          </Link>
        </div>
      </div>
    </main>
  );
}
