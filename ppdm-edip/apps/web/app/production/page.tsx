"use client";

import { useEffect, useState } from "react";
import Link from "next/link";

const API = process.env.NEXT_PUBLIC_API_URL || "http://localhost:8007";

export default function ProductionPage() {
  const [pdens, setPdens] = useState<Array<{ pden_id: string; pden_name: string; primary_product: string; uwi: string }>>([]);
  const [kpis, setKpis] = useState<{ pden_count: number; oil_cum_total: number; gas_cum_total: number } | null>(null);
  const [rollups, setRollups] = useState<Array<{ group_key: string; pden_count: number; oil_total: number; gas_total: number }>>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    Promise.all([
      fetch(`${API}/v1/production/pdens`).then((r) => r.json()),
      fetch(`${API}/v1/production/kpis`).then((r) => r.json()),
      fetch(`${API}/v1/production/rollups?group_by=pool`).then((r) => r.json()),
    ])
      .then(([p, k, ru]) => {
        setPdens(Array.isArray(p) ? p : []);
        setKpis(k && typeof k.pden_count === "number" ? k : null);
        setRollups(Array.isArray(ru) ? ru : []);
      })
      .catch(() => {})
      .finally(() => setLoading(false));
  }, []);

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold">Production & Asset Intelligence</h1>
      {kpis && (
        <div className="grid grid-cols-3 gap-4">
          <div className="border rounded p-4 bg-white">
            <div className="text-2xl font-bold">{kpis.pden_count}</div>
            <div className="text-slate-600">PDENs</div>
          </div>
          <div className="border rounded p-4 bg-white">
            <div className="text-2xl font-bold">{kpis.oil_cum_total.toLocaleString()}</div>
            <div className="text-slate-600">Oil cum total</div>
          </div>
          <div className="border rounded p-4 bg-white">
            <div className="text-2xl font-bold">{kpis.gas_cum_total.toLocaleString()}</div>
            <div className="text-slate-600">Gas cum total</div>
          </div>
        </div>
      )}
      <section>
        <h2 className="text-lg font-semibold mb-2">PDEN list</h2>
        {loading ? (
          <p>Loading...</p>
        ) : (
          <table className="border table-auto w-full text-sm">
            <thead>
              <tr className="bg-slate-100">
                <th className="text-left p-2">PDEN ID</th>
                <th className="text-left p-2">Name</th>
                <th className="text-left p-2">Product</th>
                <th className="text-left p-2">UWI</th>
                <th className="text-left p-2"></th>
              </tr>
            </thead>
            <tbody>
              {pdens.map((p) => (
                <tr key={p.pden_id} className="border-t">
                  <td className="p-2 font-mono">{p.pden_id}</td>
                  <td className="p-2">{p.pden_name}</td>
                  <td className="p-2">{p.primary_product}</td>
                  <td className="p-2">{p.uwi}</td>
                  <td className="p-2">
                    <Link href={`/production/${encodeURIComponent(p.pden_id)}`} className="text-blue-600 hover:underline">Volumes</Link>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </section>
      <section>
        <h2 className="text-lg font-semibold mb-2">Rollups by pool</h2>
        <table className="border table-auto w-full text-sm">
          <thead>
            <tr className="bg-slate-100">
              <th className="text-left p-2">Pool</th>
              <th className="text-left p-2">PDEN count</th>
              <th className="text-left p-2">Oil total</th>
              <th className="text-left p-2">Gas total</th>
            </tr>
          </thead>
          <tbody>
            {rollups.map((r) => (
              <tr key={r.group_key || "n/a"} className="border-t">
                <td className="p-2">{r.group_key || "—"}</td>
                <td className="p-2">{r.pden_count}</td>
                <td className="p-2">{r.oil_total?.toLocaleString()}</td>
                <td className="p-2">{r.gas_total?.toLocaleString()}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </section>
    </div>
  );
}
