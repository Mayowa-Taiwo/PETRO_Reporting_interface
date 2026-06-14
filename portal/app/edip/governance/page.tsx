"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { edipFetch, governanceFetch } from "@/lib/api";

export default function GovernancePage() {
  const [edipScores, setEdipScores] = useState<Array<Record<string, unknown>>>([]);
  const [lineage, setLineage] = useState<Array<Record<string, unknown>>>([]);
  const [exceptions, setExceptions] = useState<Array<Record<string, unknown>>>([]);
  const [tables, setTables] = useState<Array<{ table_name: string; table_comment: string | null }>>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    Promise.all([
      edipFetch("/v1/governance/dq-scores").then((r) => (r.ok ? r.json() : [])),
      governanceFetch("/v1/marts/governance/lineage").then((r) => (r.ok ? r.json() : { edges: [] })),
      governanceFetch("/v1/metadata/exceptions").then((r) => (r.ok ? r.json() : [])),
      governanceFetch("/v1/admin/contract/tables").then((r) => (r.ok ? r.json() : [])),
    ])
      .then(([scores, lin, exc, tbl]) => {
        setEdipScores(Array.isArray(scores) ? scores : []);
        const edges = lin?.edges ?? [];
        setLineage(Array.isArray(edges) ? edges : []);
        setExceptions(Array.isArray(exc) ? exc.slice(0, 30) : []);
        setTables(Array.isArray(tbl) ? tbl : []);
      })
      .finally(() => setLoading(false));
  }, []);

  if (loading) return <p className="text-slate-600">Loading governance…</p>;

  return (
    <div className="space-y-8">
      <div>
        <h1 className="text-2xl font-bold">Governance</h1>
        <p className="text-slate-600 mt-1">
          EDIP Governance Layer — DQ certification, lineage, exceptions, and PPDM contract catalog.
        </p>
      </div>

      <section>
        <h2 className="text-lg font-semibold mb-3">Mart certification &amp; DQ scores</h2>
        {edipScores.length === 0 ? (
          <p className="text-slate-500">No mart DQ scores yet. Run coverage scoring for Platinum marts.</p>
        ) : (
          <div className="grid gap-4 md:grid-cols-2">
            {edipScores.map((s, i) => (
              <div key={i} className="border rounded-lg p-4 bg-white shadow-sm">
                <div className="flex justify-between items-center">
                  <span className="font-mono">{String(s.mart_id)}</span>
                  <span
                    className={`px-2 py-1 rounded text-sm ${s.certified_ind ? "bg-emerald-100 text-emerald-800" : "bg-amber-100 text-amber-800"}`}
                  >
                    {s.certified_ind ? "Certified" : "Not certified"}
                  </span>
                </div>
                <div className="mt-2 grid grid-cols-3 gap-2 text-sm">
                  <div>Essential: {Number(s.essential_coverage_pct ?? 0).toFixed(1)}%</div>
                  <div>Enhanced: {Number(s.enhanced_coverage_pct ?? 0).toFixed(1)}%</div>
                  <div>DQ: {Number(s.dq_score ?? 0).toFixed(1)}</div>
                </div>
              </div>
            ))}
          </div>
        )}
      </section>

      <section>
        <h2 className="text-lg font-semibold mb-2">Lineage (source → target)</h2>
        <div className="overflow-x-auto border rounded bg-white">
          <table className="w-full text-sm">
            <thead>
              <tr className="bg-slate-100">
                <th className="text-left p-2">Source</th>
                <th className="text-left p-2">Target</th>
                <th className="text-left p-2">Run</th>
              </tr>
            </thead>
            <tbody>
              {lineage.slice(0, 50).map((e, i) => (
                <tr key={i} className="border-t">
                  <td className="p-2 font-mono text-xs">
                    {String(e.source_table ?? e.source_table_name)}.{String(e.source_column ?? e.source_column_name)}
                  </td>
                  <td className="p-2 font-mono text-xs">
                    {String(e.target_table ?? e.target_table_name)}.{String(e.target_column ?? e.target_column_name)}
                  </td>
                  <td className="p-2 font-mono text-xs">{e.run_id ? String(e.run_id).slice(0, 8) + "…" : "—"}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </section>

      <section>
        <h2 className="text-lg font-semibold mb-2">Exception monitor</h2>
        <div className="overflow-x-auto border rounded bg-white">
          <table className="w-full text-sm">
            <thead>
              <tr className="bg-slate-100">
                <th className="text-left p-2">Table</th>
                <th className="text-left p-2">Type</th>
                <th className="text-left p-2">Message</th>
              </tr>
            </thead>
            <tbody>
              {exceptions.map((e, i) => (
                <tr key={i} className="border-t">
                  <td className="p-2 font-mono text-xs">{String(e.exception_table_name ?? e.table ?? "—")}</td>
                  <td className="p-2">{String(e.exception_type ?? "—")}</td>
                  <td className="p-2 max-w-md truncate">{String(e.error_message ?? "—")}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </section>

      <section>
        <h2 className="text-lg font-semibold mb-2">PPDM contract catalog</h2>
        <p className="text-sm text-slate-600 mb-2">
          Warehouse governance tables from the TRD consumption contract. For ingest stewardship see{" "}
          <Link href="/edip/trd" className="text-blue-600 hover:underline">TRD Warehouse</Link>.
        </p>
        <div className="overflow-x-auto border rounded bg-white max-h-64 overflow-y-auto">
          <table className="w-full text-sm">
            <thead>
              <tr className="bg-slate-100 sticky top-0">
                <th className="text-left p-2">Table</th>
                <th className="text-left p-2">Comment</th>
              </tr>
            </thead>
            <tbody>
              {tables.map((t) => (
                <tr key={t.table_name} className="border-t">
                  <td className="p-2 font-mono">{t.table_name}</td>
                  <td className="p-2 text-slate-600">{t.table_comment || "—"}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </section>
    </div>
  );
}
