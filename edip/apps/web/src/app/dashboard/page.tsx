"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { apiFetch } from "@/lib/api";
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
} from "recharts";

export default function DashboardPage() {
  const [kpis, setKpis] = useState<Record<string, unknown> | null>(null);
  const [pdens, setPdens] = useState<Array<Record<string, unknown>>>([]);
  const [timeseries, setTimeseries] = useState<Array<{ date: string; oil: number; gas: number; boe: number }>>([]);
  const [loading, setLoading] = useState(true);
  const [explainKpi, setExplainKpi] = useState<string | null>(null);

  useEffect(() => {
    const token = typeof window !== "undefined" ? localStorage.getItem("edip_token") : null;
    if (!token) {
      window.location.href = "/login";
      return;
    }
    Promise.all([
      apiFetch("/v1/marts/production/kpis").then((r) => (r.ok ? r.json() : null)),
      apiFetch("/v1/marts/production/pdens").then((r) => (r.ok ? r.json() : [])),
      apiFetch("/v1/marts/production/timeseries").then((r) => (r.ok ? r.json() : [])),
    ])
      .then(([k, p, t]) => {
        setKpis(k || {});
        setPdens(Array.isArray(p) ? p : []);
        setTimeseries(Array.isArray(t) ? t : []);
      })
      .catch(() => {})
      .finally(() => setLoading(false));
  }, []);

  if (loading) return <p className="p-4">Loading…</p>;

  const kpiList = kpis
    ? [
        { id: "oil_mtd", label: "Oil MTD", value: kpis.oil_mtd },
        { id: "gas_mtd", label: "Gas MTD", value: kpis.gas_mtd },
        { id: "water_mtd", label: "Water MTD", value: kpis.water_mtd },
        { id: "boe_mtd", label: "BOE MTD", value: kpis.boe_mtd },
        { id: "oil_ytd", label: "Oil YTD", value: kpis.oil_ytd },
        { id: "gas_ytd", label: "Gas YTD", value: kpis.gas_ytd },
        { id: "boe_ytd", label: "BOE YTD", value: kpis.boe_ytd },
        { id: "yoy_growth_pct", label: "YoY Growth %", value: kpis.yoy_growth_pct },
        { id: "decline_rate_pct", label: "Decline Rate %", value: kpis.decline_rate_pct },
        { id: "production_per_well", label: "Production per Well", value: kpis.production_per_well },
      ]
    : [];

  return (
    <div className="space-y-8">
      <h1 className="text-2xl font-bold">Production Dashboard</h1>

      <section>
        <h2 className="text-lg font-semibold mb-3">KPI Tiles</h2>
        <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-5 gap-4">
          {kpiList.map((k) => (
            <div
              key={k.id}
              className="border rounded-lg p-4 bg-white shadow-sm cursor-pointer"
              onClick={() => setExplainKpi(explainKpi === k.id ? null : k.id)}
            >
              <div className="text-xs text-slate-500">{k.label}</div>
              <div className="text-xl font-bold mt-1">
                {typeof k.value === "number" ? (k.value as number).toLocaleString() : String(k.value ?? "—")}
              </div>
              {explainKpi === k.id && (
                <div className="mt-2 text-xs text-slate-400 border-t pt-2">
                  Definition, formula, lineage, DQ, last refresh (KPI Explain)
                </div>
              )}
            </div>
          ))}
        </div>
      </section>

      {timeseries.length > 0 && (
        <section>
          <h2 className="text-lg font-semibold mb-3">Trend (BOE)</h2>
          <div className="h-64 bg-white rounded border p-2">
            <ResponsiveContainer width="100%" height="100%">
              <LineChart data={timeseries}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="date" tick={{ fontSize: 10 }} />
                <YAxis tick={{ fontSize: 10 }} />
                <Tooltip />
                <Line type="monotone" dataKey="boe" stroke="#0ea5e9" name="BOE" />
              </LineChart>
            </ResponsiveContainer>
          </div>
        </section>
      )}

      <section>
        <h2 className="text-lg font-semibold mb-3">PDEN Explorer</h2>
        <div className="overflow-x-auto border rounded bg-white">
          <table className="w-full text-sm">
            <thead>
              <tr className="bg-slate-100">
                <th className="text-left p-2">PDEN ID</th>
                <th className="text-left p-2">Type</th>
                <th className="text-left p-2">Name</th>
                <th className="text-left p-2">Product</th>
                <th className="text-left p-2">UWI</th>
              </tr>
            </thead>
            <tbody>
              {pdens.slice(0, 50).map((p: Record<string, unknown>, i: number) => (
                <tr key={i} className="border-t">
                  <td className="p-2 font-mono">{String(p.pden_id ?? "")}</td>
                  <td className="p-2">{String(p.pden_type ?? "")}</td>
                  <td className="p-2">{String(p.pden_name ?? "")}</td>
                  <td className="p-2">{String(p.primary_product ?? "")}</td>
                  <td className="p-2">{String(p.uwi ?? "")}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
        <p className="text-sm text-slate-500 mt-2">Drill-down: Operator → Field/Pool → PDEN → Day (filters in API)</p>
      </section>
    </div>
  );
}
