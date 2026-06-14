import Link from "next/link";

const SECTIONS = [
  {
    title: "Executive Intelligence",
    description: "Executive BI, KPI tiles, trends, and production dashboards.",
    href: "/edip/executive",
  },
  {
    title: "Production Intelligence",
    description: "PDEN explorer, volumes, rollups, and petroleum production visibility.",
    href: "/edip/production",
  },
  {
    title: "Reporting",
    description: "Reporting workflows, drill-downs, exports, and performance dashboards.",
    href: "/edip/reporting",
  },
  {
    title: "Governance",
    description: "DQ certification, lineage, exceptions, and metadata stewardship.",
    href: "/edip/governance",
  },
  {
    title: "TRD Warehouse",
    description: "TRD-aligned warehouse core, ingest runs, contract catalog, and job stewardship.",
    href: "/edip/trd",
  },
  {
    title: "Compliance",
    description: "Regulatory intelligence, spatial assets, and schema compliance workflows.",
    href: "/edip/compliance",
  },
  {
    title: "LDV Platform Core",
    description: "Shared Python services for domain logic, compliance, and intelligence (no separate UI).",
    href: "/platform",
  },
];

export default function Home() {
  return (
    <main className="min-h-screen p-8 md:p-12">
      <div className="max-w-4xl mx-auto">
        <p className="text-emerald-400 text-sm font-medium tracking-wide uppercase mb-2">
          PETRO Reporting Interface
        </p>
        <h1 className="text-3xl md:text-4xl font-bold text-white mb-4">
          Unified petroleum reporting &amp; executive intelligence
        </h1>
        <p className="text-slate-400 text-lg mb-8 leading-relaxed">
          A unified workspace for petroleum reporting, executive intelligence, production visibility,
          governance, TRD warehouse management, and compliance intelligence — one product shell,
          one entry point.
        </p>

        <Link
          href="/edip"
          className="inline-flex items-center gap-2 rounded-lg bg-emerald-600 px-6 py-3 text-base font-semibold text-white hover:bg-emerald-500 transition-colors mb-12"
        >
          Enter EDIP Workspace →
        </Link>

        <h2 className="text-lg font-semibold text-white mb-4">Workspace areas</h2>
        <div className="grid gap-4 md:grid-cols-2">
          {SECTIONS.map((s) => (
            <Link
              key={s.href}
              href={s.href}
              className="rounded-xl border border-slate-700 bg-slate-900/50 p-5 hover:border-emerald-600/50 hover:bg-slate-900 transition-colors block"
            >
              <h3 className="text-white font-semibold mb-1">{s.title}</h3>
              <p className="text-sm text-slate-400">{s.description}</p>
            </Link>
          ))}
        </div>

        <p className="mt-10 text-sm text-slate-500">
          Run <code className="text-slate-400 bg-slate-800 px-1.5 py-0.5 rounded">docker compose up --build</code>{" "}
          from the repo root, then use this URL only — no separate frontend ports for normal product use.
        </p>
      </div>
    </main>
  );
}
