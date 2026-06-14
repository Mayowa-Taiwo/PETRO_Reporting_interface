import Link from "next/link";

export default function PlatformPage() {
  return (
    <main className="min-h-screen p-8 md:p-12">
      <div className="max-w-3xl mx-auto">
        <Link href="/" className="text-sm text-slate-400 hover:text-white mb-6 inline-block">
          ← PETRO Reporting Interface
        </Link>
        <h1 className="text-3xl font-bold text-white mb-4">LDV Platform Core</h1>
        <p className="text-slate-400 mb-8 leading-relaxed">
          LDV Platform is the shared Python foundation beneath the PETRO Reporting Interface. It provides
          domain logic, compliance checks, and intelligence capabilities — not a separate web application.
        </p>

        <section className="space-y-6 text-slate-300">
          <div className="rounded-xl border border-slate-700 bg-slate-900/50 p-5">
            <h2 className="text-white font-semibold mb-2">Core services</h2>
            <p className="text-sm text-slate-400">
              Schema compliance, PPDM Lite governance helpers, and shared utilities in{" "}
              <code className="text-slate-300">ldv_platform/core/</code>.
            </p>
          </div>
          <div className="rounded-xl border border-slate-700 bg-slate-900/50 p-5">
            <h2 className="text-white font-semibold mb-2">Domain products</h2>
            <p className="text-sm text-slate-400">
              Master data and contract domain modules in{" "}
              <code className="text-slate-300">ldv_platform/domain_products/</code>.
            </p>
          </div>
          <div className="rounded-xl border border-slate-700 bg-slate-900/50 p-5">
            <h2 className="text-white font-semibold mb-2">Compliance CLI</h2>
            <p className="text-sm text-slate-400 mb-3">
              Run PPDM Lite schema compliance from the repo root:
            </p>
            <pre className="text-xs bg-slate-950 p-3 rounded overflow-x-auto text-slate-300">
              python -m ldv_platform.run_compliance
            </pre>
          </div>
        </section>

        <Link
          href="/edip/platform-services"
          className="inline-block mt-8 text-emerald-400 hover:text-emerald-300 text-sm"
        >
          View in EDIP workspace →
        </Link>
      </div>
    </main>
  );
}
