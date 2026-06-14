"use client";

import { useCallback, useEffect, useState } from "react";
import Link from "next/link";
import { apiFetch } from "@/lib/api";

const API = process.env.NEXT_PUBLIC_API_URL || "http://localhost:8007";

type KpisResponse = {
  year: number;
  month: number;
  definitions: Array<{ id: string; name: string; definition: string; unit: string }>;
  values: {
    total_oil_mtd?: number;
    total_gas_mtd?: number;
    boe_mtd?: number;
    total_oil_ytd?: number;
    yoy_growth_pct_oil?: number | null;
    production_per_well?: number;
    top_10_pdens_oil?: Array<{ pden_id: string; pden_type: string; pden_source: string; oil_cum_volume: number }>;
    decline_rate_pct?: number | null;
    utilization_pct?: number;
    forecast_vs_actual_pct?: number | null;
    production_by_field?: Array<{ pool_id: string; field_id: string; oil_cum_volume: number; gas_cum_volume: number }>;
    production_by_operator?: Array<{ operator_id: string; operator_name: string; oil_cum_volume: number; gas_cum_volume: number }>;
  };
};

type CoverageResponse = {
  essential_points: number;
  enhanced_points: number;
  total_points: number;
  certified: boolean;
  rule: string;
};

type DataRow = {
  fact_production_key: number;
  pden_key: number;
  date_key: number;
  calendar_date: string | null;
  pden_id_natural: string;
  pden_type: string;
  pden_source: string;
  oil_cum_volume: number | null;
  gas_cum_volume: number | null;
  boe_cum_volume: number | null;
  volume_method: string;
  activity_type: string;
};

export default function ReportingPage() {
  const [kpis, setKpis] = useState<KpisResponse | null>(null);
  const [coverage, setCoverage] = useState<CoverageResponse | null>(null);
  const [data, setData] = useState<DataRow[]>([]);
  const [loading, setLoading] = useState(true);
  const [dataLoading, setDataLoading] = useState(false);
  const [year, setYear] = useState<number>(() => new Date().getFullYear());
  const [month, setMonth] = useState<number>(() => new Date().getMonth() + 1);
  const [operatorKey, setOperatorKey] = useState<string>("");
  const [fieldPoolKey, setFieldPoolKey] = useState<string>("");
  const [pdenId, setPdenId] = useState("");
  const [fromDate, setFromDate] = useState("");
  const [toDate, setToDate] = useState("");

  const loadKpis = useCallback(async () => {
    try {
      const r = await apiFetch(`/v1/marts/production/kpis?year=${year}&month=${month}`);
      if (r.ok) setKpis(await r.json());
    } catch {
      const r = await fetch(`${API}/v1/marts/production/kpis?year=${year}&month=${month}`);
      if (r.ok) setKpis(await r.json());
    }
  }, [year, month]);

  const loadCoverage = useCallback(async () => {
    try {
      const r = await apiFetch("/v1/marts/production/coverage");
      if (r.ok) setCoverage(await r.json());
    } catch {
      const r = await fetch(`${API}/v1/marts/production/coverage`);
      if (r.ok) setCoverage(await r.json());
    }
  }, []);

  const loadData = useCallback(async () => {
    setDataLoading(true);
    const params = new URLSearchParams();
    if (operatorKey) params.set("operator_key", operatorKey);
    if (fieldPoolKey) params.set("field_pool_key", fieldPoolKey);
    if (pdenId) params.set("pden_id", pdenId);
    if (fromDate) params.set("from", fromDate);
    if (toDate) params.set("to", toDate);
    params.set("limit", "500");
    try {
      const r = await apiFetch(`/v1/marts/production/data?${params}`);
      if (r.ok) setData(await r.json());
      else setData([]);
    } catch {
      const r = await fetch(`${API}/v1/marts/production/data?${params}`);
      if (r.ok) setData(await r.json());
      else setData([]);
    } finally {
      setDataLoading(false);
    }
  }, [operatorKey, fieldPoolKey, pdenId, fromDate, toDate]);

  useEffect(() => {
    Promise.all([loadKpis(), loadCoverage()]).finally(() => setLoading(false));
  }, [loadKpis, loadCoverage]);

  useEffect(() => {
    loadData();
  }, [loadData]);

  const exportCsv = () => {
    const params = new URLSearchParams();
    if (operatorKey) params.set("operator_key", operatorKey);
    if (fieldPoolKey) params.set("field_pool_key", fieldPoolKey);
    if (pdenId) params.set("pden_id", pdenId);
    if (fromDate) params.set("from", fromDate);
    if (toDate) params.set("to", toDate);
    const token = typeof window !== "undefined" ? localStorage.getItem("edip_token") : null;
    const url = `${API}/v1/marts/production/export/csv?${params}`;
    const a = document.createElement("a");
    a.href = token ? `${url}` : url;
    a.download = "production_mart_export.csv";
    a.target = "_blank";
    if (token) {
      fetch(url, { headers: { Authorization: `Bearer ${token}` } })
        .then((r) => r.blob())
        .then((blob) => {
          const u = URL.createObjectURL(blob);
          a.href = u;
          a.click();
          URL.revokeObjectURL(u);
        });
    } else {
      a.click();
    }
  };

  if (loading) {
    return (
      <div className="space-y-6">
        <h1 className="text-2xl font-bold">Executive BI — Reporting</h1>
        <p>Loading KPIs and coverage...</p>
      </div>
    );
  }

  return (
    <div className="space-y-8">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-bold">Production Performance Dashboard</h1>
        {coverage && (
          <div className="flex items-center gap-3">
            <span className="text-sm text-slate-600">
              Coverage: {coverage.total_points} pts (E: {coverage.essential_points} / Ex: {coverage.enhanced_points})
            </span>
            <span
              className={`px-2 py-1 rounded text-sm font-medium ${coverage.certified ? "bg-emerald-100 text-emerald-800" : "bg-amber-100 text-amber-800"}`}
            >
              {coverage.certified ? "Certified" : "Not certified"}
            </span>
          </div>
        )}
      </div>

      <section>
        <div className="flex flex-wrap gap-4 items-center mb-4">
          <label className="flex items-center gap-2">
            Year
            <select
              value={year}
              onChange={(e) => setYear(Number(e.target.value))}
              className="border rounded px-2 py-1"
            >
              {[2022, 2023, 2024, 2025, 2026].map((y) => (
                <option key={y} value={y}>{y}</option>
              ))}
            </select>
          </label>
          <label className="flex items-center gap-2">
            Month
            <select
              value={month}
              onChange={(e) => setMonth(Number(e.target.value))}
              className="border rounded px-2 py-1"
            >
              {Array.from({ length: 12 }, (_, i) => i + 1).map((m) => (
                <option key={m} value={m}>{m}</option>
              ))}
            </select>
          </label>
          <button
            type="button"
            onClick={() => loadKpis()}
            className="px-3 py-1 rounded bg-slate-200 hover:bg-slate-300"
          >
            Refresh KPIs
          </button>
        </div>

        <h2 className="text-lg font-semibold mb-3">KPI Tiles</h2>
        <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-4">
          {kpis?.definitions?.slice(0, 12).map((def) => (
            <div key={def.id} className="border rounded-lg p-4 bg-white shadow-sm">
              <div className="text-xs text-slate-500 uppercase tracking-wide">{def.name}</div>
              <div className="mt-1 text-xl font-bold">
                {def.id === "total_oil_mtd" && kpis.values.total_oil_mtd != null && kpis.values.total_oil_mtd.toLocaleString()}
                {def.id === "total_gas_mtd" && kpis.values.total_gas_mtd != null && kpis.values.total_gas_mtd.toLocaleString()}
                {def.id === "boe_mtd" && kpis.values.boe_mtd != null && kpis.values.boe_mtd.toLocaleString()}
                {def.id === "total_oil_ytd" && kpis.values.total_oil_ytd != null && kpis.values.total_oil_ytd.toLocaleString()}
                {def.id === "yoy_growth_pct_oil" && (kpis.values.yoy_growth_pct_oil != null ? `${kpis.values.yoy_growth_pct_oil}%` : "—")}
                {def.id === "production_per_well" && kpis.values.production_per_well != null && kpis.values.production_per_well.toLocaleString()}
                {def.id === "decline_rate_pct" && (kpis.values.decline_rate_pct != null ? `${kpis.values.decline_rate_pct}%` : "—")}
                {def.id === "utilization_pct" && (kpis.values.utilization_pct != null ? `${kpis.values.utilization_pct}%` : "—")}
                {def.id === "forecast_vs_actual_pct" && (kpis.values.forecast_vs_actual_pct != null ? `${kpis.values.forecast_vs_actual_pct}%` : "N/A")}
                {def.id === "top_10_pdens_oil" && (Array.isArray(kpis.values.top_10_pdens_oil) ? `${kpis.values.top_10_pdens_oil.length} PDENs` : "—")}
                {def.id === "production_by_field" && (Array.isArray(kpis.values.production_by_field) ? `${kpis.values.production_by_field.length} fields` : "—")}
                {def.id === "production_by_operator" && (Array.isArray(kpis.values.production_by_operator) ? `${kpis.values.production_by_operator.length} operators` : "—")}
              </div>
              <div className="text-xs text-slate-400 mt-1">{def.definition}</div>
            </div>
          ))}
        </div>
      </section>

      <section>
        <h2 className="text-lg font-semibold mb-3">Drill-down: Operator → Field/Pool → PDEN → Day</h2>
        <p className="text-sm text-slate-600 mb-3">
          Filter fact data and export CSV. Use Production list to <Link href="/production" className="text-blue-600 hover:underline">browse PDENs</Link> and open daily volumes.
        </p>
        <div className="flex flex-wrap gap-3 items-end mb-4">
          <label className="flex flex-col gap-1">
            <span className="text-xs text-slate-500">Operator key</span>
            <input
              type="text"
              value={operatorKey}
              onChange={(e) => setOperatorKey(e.target.value)}
              placeholder="e.g. 1"
              className="border rounded px-2 py-1 w-24"
            />
          </label>
          <label className="flex flex-col gap-1">
            <span className="text-xs text-slate-500">Field/Pool key</span>
            <input
              type="text"
              value={fieldPoolKey}
              onChange={(e) => setFieldPoolKey(e.target.value)}
              placeholder="e.g. 1"
              className="border rounded px-2 py-1 w-24"
            />
          </label>
          <label className="flex flex-col gap-1">
            <span className="text-xs text-slate-500">PDEN ID</span>
            <input
              type="text"
              value={pdenId}
              onChange={(e) => setPdenId(e.target.value)}
              placeholder="Natural key"
              className="border rounded px-2 py-1 w-32"
            />
          </label>
          <label className="flex flex-col gap-1">
            <span className="text-xs text-slate-500">From date</span>
            <input
              type="date"
              value={fromDate}
              onChange={(e) => setFromDate(e.target.value)}
              className="border rounded px-2 py-1"
            />
          </label>
          <label className="flex flex-col gap-1">
            <span className="text-xs text-slate-500">To date</span>
            <input
              type="date"
              value={toDate}
              onChange={(e) => setToDate(e.target.value)}
              className="border rounded px-2 py-1"
            />
          </label>
          <button
            type="button"
            onClick={loadData}
            className="px-3 py-1 rounded bg-slate-200 hover:bg-slate-300"
          >
            Apply
          </button>
          <button
            type="button"
            onClick={exportCsv}
            className="px-3 py-1 rounded bg-emerald-600 text-white hover:bg-emerald-700"
          >
            Export CSV
          </button>
        </div>
        {dataLoading ? (
          <p>Loading data...</p>
        ) : (
          <div className="overflow-x-auto">
            <table className="border table-auto w-full text-sm">
              <thead>
                <tr className="bg-slate-100">
                  <th className="text-left p-2">Date</th>
                  <th className="text-left p-2">PDEN ID</th>
                  <th className="text-left p-2">Type</th>
                  <th className="text-left p-2">Source</th>
                  <th className="text-right p-2">Oil</th>
                  <th className="text-right p-2">Gas</th>
                  <th className="text-right p-2">BOE</th>
                  <th className="text-left p-2">Method</th>
                  <th className="text-left p-2">Activity</th>
                </tr>
              </thead>
              <tbody>
                {data.map((row) => (
                  <tr key={row.fact_production_key} className="border-t">
                    <td className="p-2">{row.calendar_date ?? "—"}</td>
                    <td className="p-2 font-mono">
                      <Link href={`/production/${encodeURIComponent(row.pden_id_natural)}`} className="text-blue-600 hover:underline">
                        {row.pden_id_natural}
                      </Link>
                    </td>
                    <td className="p-2">{row.pden_type}</td>
                    <td className="p-2">{row.pden_source}</td>
                    <td className="p-2 text-right">{row.oil_cum_volume != null ? row.oil_cum_volume.toLocaleString() : "—"}</td>
                    <td className="p-2 text-right">{row.gas_cum_volume != null ? row.gas_cum_volume.toLocaleString() : "—"}</td>
                    <td className="p-2 text-right">{row.boe_cum_volume != null ? row.boe_cum_volume.toLocaleString() : "—"}</td>
                    <td className="p-2">{row.volume_method ?? "—"}</td>
                    <td className="p-2">{row.activity_type ?? "—"}</td>
                  </tr>
                ))}
              </tbody>
            </table>
            {data.length === 0 && !dataLoading && <p className="text-slate-500 py-4">No rows. Adjust filters or ensure Platinum mart is populated.</p>}
          </div>
        )}
      </section>

      {kpis?.values?.production_by_operator && kpis.values.production_by_operator.length > 0 && (
        <section>
          <h2 className="text-lg font-semibold mb-2">Production by Operator</h2>
          <table className="border table-auto w-full text-sm">
            <thead>
              <tr className="bg-slate-100">
                <th className="text-left p-2">Operator</th>
                <th className="text-right p-2">Oil</th>
                <th className="text-right p-2">Gas</th>
              </tr>
            </thead>
            <tbody>
              {kpis.values.production_by_operator.map((o) => (
                <tr key={o.operator_id} className="border-t">
                  <td className="p-2">{o.operator_name || o.operator_id}</td>
                  <td className="p-2 text-right">{o.oil_cum_volume?.toLocaleString()}</td>
                  <td className="p-2 text-right">{o.gas_cum_volume?.toLocaleString()}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </section>
      )}

      {kpis?.values?.top_10_pdens_oil && kpis.values.top_10_pdens_oil.length > 0 && (
        <section>
          <h2 className="text-lg font-semibold mb-2">Top 10 PDENs by Oil (MTD)</h2>
          <table className="border table-auto w-full text-sm">
            <thead>
              <tr className="bg-slate-100">
                <th className="text-left p-2">PDEN ID</th>
                <th className="text-left p-2">Type</th>
                <th className="text-left p-2">Source</th>
                <th className="text-right p-2">Oil cum</th>
              </tr>
            </thead>
            <tbody>
              {kpis.values.top_10_pdens_oil.map((p, i) => (
                <tr key={`${p.pden_id}-${i}`} className="border-t">
                  <td className="p-2 font-mono">
                    <Link href={`/production/${encodeURIComponent(p.pden_id)}`} className="text-blue-600 hover:underline">{p.pden_id}</Link>
                  </td>
                  <td className="p-2">{p.pden_type}</td>
                  <td className="p-2">{p.pden_source}</td>
                  <td className="p-2 text-right">{p.oil_cum_volume?.toLocaleString()}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </section>
      )}
    </div>
  );
}
