import Link from "next/link";

const AREAS = [
  { href: "/edip/executive", title: "Executive Intelligence", blurb: "KPI tiles, trends, and executive BI dashboards." },
  { href: "/edip/production", title: "Production", blurb: "PDEN explorer, volumes, and production rollups." },
  { href: "/edip/reporting", title: "Reporting", blurb: "Performance dashboards, drill-downs, and CSV export." },
  { href: "/edip/governance", title: "Governance", blurb: "DQ certification, lineage, exceptions, and metadata." },
  { href: "/edip/trd", title: "TRD Warehouse", blurb: "Ingest runs, contract catalog, DQ scores, and stewardship jobs." },
  { href: "/edip/compliance", title: "Compliance", blurb: "Spatial intelligence and regulatory compliance workflows." },
];

export default function EdipOverviewPage() {
  return (
    <div className="space-y-8">
      <div>
        <h1 className="text-2xl font-bold text-slate-900">EDIP Workspace</h1>
        <p className="mt-2 text-slate-600 max-w-2xl">
          Primary executive intelligence and reporting workspace for the PETRO Reporting Interface.
          Governance and TRD warehouse capabilities are integrated here — not separate products.
        </p>
      </div>

      <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
        {AREAS.map((a) => (
          <Link
            key={a.href}
            href={a.href}
            className="rounded-lg border border-slate-200 bg-white p-5 shadow-sm hover:border-emerald-500 hover:shadow transition-all"
          >
            <h2 className="font-semibold text-slate-900">{a.title}</h2>
            <p className="text-sm text-slate-500 mt-1">{a.blurb}</p>
          </Link>
        ))}
      </div>
    </div>
  );
}
