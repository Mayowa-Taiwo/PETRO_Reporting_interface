"use client";

import { useEffect, useState } from "react";
import { edipFetch } from "@/lib/api";

export default function DataProductsPage() {
  const [tables, setTables] = useState<Array<{ schema: string; table: string }>>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    edipFetch("/v1/metadata/dictionary/tables")
      .then((r) => (r.ok ? r.json() : []))
      .then((t) => setTables(Array.isArray(t) ? t : []))
      .finally(() => setLoading(false));
  }, []);

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold">Data Products</h1>
        <p className="text-slate-600 mt-1">
          Published marts, Platinum layers, and metadata dictionary entries available through EDIP.
        </p>
      </div>
      {loading ? (
        <p>Loading…</p>
      ) : (
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
          {tables.length === 0 && <p className="p-4 text-slate-500">No dictionary entries yet.</p>}
        </div>
      )}
    </div>
  );
}
