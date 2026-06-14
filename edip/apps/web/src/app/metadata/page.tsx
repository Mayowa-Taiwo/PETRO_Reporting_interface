"use client";

import { useEffect, useState } from "react";
import { apiFetch } from "@/lib/api";

export default function MetadataPage() {
  const [tables, setTables] = useState<Array<{ schema: string; table: string }>>([]);
  const [lineage, setLineage] = useState<{ edges: Array<Record<string, unknown>> }>({ edges: [] });
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const token = typeof window !== "undefined" ? localStorage.getItem("edip_token") : null;
    if (!token) {
      window.location.href = "/login";
      return;
    }
    Promise.all([
      apiFetch("/v1/metadata/dictionary/tables").then((r) => (r.ok ? r.json() : [])),
      apiFetch("/v1/metadata/lineage").then((r) => (r.ok ? r.json() : { edges: [] })),
    ])
      .then(([t, l]) => {
        setTables(Array.isArray(t) ? t : []);
        setLineage(l && l.edges ? l : { edges: [] });
      })
      .finally(() => setLoading(false));
  }, []);

  if (loading) return <p className="p-4">Loading…</p>;

  return (
    <div className="space-y-8">
      <h1 className="text-2xl font-bold">Metadata</h1>
      <section>
        <h2 className="text-lg font-semibold mb-3">Dictionary — Tables</h2>
        <div className="overflow-x-auto border rounded bg-white max-h-96 overflow-y-auto">
          <table className="w-full text-sm">
            <thead>
              <tr className="bg-slate-100 sticky top-0">
                <th className="text-left p-2">Schema</th>
                <th className="text-left p-2">Table</th>
              </tr>
            </thead>
            <tbody>
              {tables.map((r, i) => (
                <tr key={i} className="border-t">
                  <td className="p-2 font-mono">{r.schema}</td>
                  <td className="p-2 font-mono">{r.table}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </section>
      <section>
        <h2 className="text-lg font-semibold mb-3">Lineage (source → target)</h2>
        <div className="overflow-x-auto border rounded bg-white max-h-64 overflow-y-auto">
          <table className="w-full text-sm">
            <thead>
              <tr className="bg-slate-100">
                <th className="text-left p-2">Source Table</th>
                <th className="text-left p-2">Source Column</th>
                <th className="text-left p-2">Target Table</th>
                <th className="text-left p-2">Target Column</th>
              </tr>
            </thead>
            <tbody>
              {(lineage.edges as Array<Record<string, unknown>>).slice(0, 100).map((e, i) => (
                <tr key={i} className="border-t">
                  <td className="p-2">{String(e.source_table ?? "")}</td>
                  <td className="p-2">{String(e.source_column ?? "")}</td>
                  <td className="p-2">{String(e.target_table ?? "")}</td>
                  <td className="p-2">{String(e.target_column ?? "")}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </section>
    </div>
  );
}
