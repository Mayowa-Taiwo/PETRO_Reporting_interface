"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { governanceFetch, getToken } from "@/lib/api";

type DqRow = { target_table: string; dq_score: number; certified_ind: boolean };
type LineageRow = {
  source_table_name: string;
  source_column_name: string;
  target_table_name: string;
  target_column_name: string;
  run_id: string | null;
};
type ExceptionRow = {
  exception_table_name: string;
  exception_column_name: string | null;
  exception_type: string | null;
  error_message: string | null;
  exception_date: string | null;
};

function latestDqPerTable(rows: DqRow[]): DqRow[] {
  const seen = new Set<string>();
  return rows.filter((r) => {
    if (seen.has(r.target_table)) return false;
    seen.add(r.target_table);
    return true;
  });
}

export default function TrdWarehousePage() {
  const [runs, setRuns] = useState<Array<{ run_id: string; status: string; started_at: string }>>([]);
  const [dq, setDq] = useState<DqRow[]>([]);
  const [lineage, setLineage] = useState<LineageRow[]>([]);
  const [exceptions, setExceptions] = useState<ExceptionRow[]>([]);
  const [sources, setSources] = useState<Array<{ source_id: string; source_name: string; source_type: string }>>([]);
  const [runBody, setRunBody] = useState({ source_id: "", mode: "full_refresh" });
  const [runResult, setRunResult] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const toJson = (r: Response) => (r.ok ? r.json() : []);
    Promise.all([
      governanceFetch("/v1/jobs/runs").then(toJson),
      governanceFetch("/v1/admin/dq/scores").then(toJson),
      governanceFetch("/v1/admin/lineage").then(toJson),
      governanceFetch("/v1/admin/exceptions").then(toJson),
      governanceFetch("/v1/admin/sources").then(toJson),
    ])
      .then(([runsData, dqData, lineageData, excData, srcData]) => {
        setRuns(Array.isArray(runsData) ? runsData : []);
        setDq(latestDqPerTable(Array.isArray(dqData) ? dqData : []));
        setLineage(Array.isArray(lineageData) ? lineageData.slice(0, 30) : []);
        setExceptions(Array.isArray(excData) ? excData.slice(0, 20) : []);
        const src = Array.isArray(srcData) ? srcData : [];
        setSources(src);
        if (src[0]) setRunBody((prev) => ({ ...prev, source_id: src[0].source_id }));
      })
      .finally(() => setLoading(false));
  }, []);

  const runJob = () => {
    if (!getToken()) {
      setRunResult("Sign in as admin to run ingest jobs.");
      return;
    }
    setRunResult(null);
    governanceFetch("/v1/jobs/run", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(runBody),
    })
      .then((r) => {
        if (r.status === 401 || r.status === 403) {
          setRunResult("Admin sign-in required.");
          return null;
        }
        return r.json();
      })
      .then((data) => {
        if (!data) return;
        setRunResult(data.run_id ? `Run started: ${data.run_id}` : JSON.stringify(data));
      })
      .catch((e) => setRunResult(`Error: ${e.message}`));
  };

  return (
    <div className="space-y-8">
      <div>
        <h1 className="text-2xl font-bold">TRD Warehouse</h1>
        <p className="text-slate-600 mt-1">
          TRD-aligned warehouse core — ingest runs, DQ scoring, lineage, exceptions, and stewardship jobs.
        </p>
      </div>

      <section className="rounded-lg border bg-white p-4">
        <h2 className="text-lg font-semibold mb-2">Run ingest job</h2>
        <p className="text-sm text-slate-600 mb-3">
          Browsing is open. Starting jobs requires admin sign-in —{" "}
          <Link href="/edip/login" className="text-blue-600 hover:underline">sign in</Link>.
        </p>
        <div className="flex flex-wrap gap-2 items-end">
          <label>
            Source
            <select
              className="ml-2 border rounded px-2 py-1"
              value={runBody.source_id}
              onChange={(e) => setRunBody((prev) => ({ ...prev, source_id: e.target.value }))}
            >
              {sources.map((s) => (
                <option key={s.source_id} value={s.source_id}>{s.source_name}</option>
              ))}
            </select>
          </label>
          <label>
            Mode
            <select
              className="ml-2 border rounded px-2 py-1"
              value={runBody.mode}
              onChange={(e) => setRunBody((prev) => ({ ...prev, mode: e.target.value }))}
            >
              <option value="full_refresh">Full refresh</option>
              <option value="incremental">Incremental</option>
            </select>
          </label>
          <button type="button" onClick={runJob} className="bg-slate-900 text-white px-4 py-2 rounded hover:bg-slate-700">
            Run
          </button>
        </div>
        {runResult && <p className="mt-2 text-sm text-slate-600">{runResult}</p>}
      </section>

      <section>
        <h2 className="text-lg font-semibold mb-2">Recent runs</h2>
        {loading ? (
          <p>Loading…</p>
        ) : (
          <table className="border table-auto w-full text-sm bg-white">
            <thead>
              <tr className="bg-slate-100">
                <th className="text-left p-2">Run ID</th>
                <th className="text-left p-2">Status</th>
                <th className="text-left p-2">Started</th>
              </tr>
            </thead>
            <tbody>
              {runs.map((r) => (
                <tr key={r.run_id} className="border-t">
                  <td className="p-2 font-mono text-xs">{r.run_id.slice(0, 8)}…</td>
                  <td className="p-2">{r.status}</td>
                  <td className="p-2">{r.started_at ? new Date(r.started_at).toLocaleString() : ""}</td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </section>

      <section>
        <h2 className="text-lg font-semibold mb-2">DQ scores (latest per table)</h2>
        <table className="border table-auto w-full text-sm bg-white">
          <thead>
            <tr className="bg-slate-100">
              <th className="text-left p-2">Table</th>
              <th className="text-left p-2">Score</th>
              <th className="text-left p-2">Certified</th>
            </tr>
          </thead>
          <tbody>
            {dq.map((r) => (
              <tr key={r.target_table} className="border-t">
                <td className="p-2">{r.target_table}</td>
                <td className="p-2">{r.dq_score}</td>
                <td className="p-2">{r.certified_ind ? "Yes" : "No"}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </section>

      <section>
        <h2 className="text-lg font-semibold mb-2">Lineage (recent)</h2>
        <table className="border table-auto w-full text-sm bg-white">
          <thead>
            <tr className="bg-slate-100">
              <th className="text-left p-2">Source</th>
              <th className="text-left p-2">Target</th>
              <th className="text-left p-2">Run</th>
            </tr>
          </thead>
          <tbody>
            {lineage.map((row, i) => (
              <tr key={i} className="border-t">
                <td className="p-2 font-mono text-xs">{row.source_table_name}.{row.source_column_name}</td>
                <td className="p-2 font-mono text-xs">{row.target_table_name}.{row.target_column_name}</td>
                <td className="p-2 font-mono text-xs">{row.run_id ? row.run_id.slice(0, 8) + "…" : "—"}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </section>

      <section>
        <h2 className="text-lg font-semibold mb-2">Exceptions (recent)</h2>
        <table className="border table-auto w-full text-sm bg-white">
          <thead>
            <tr className="bg-slate-100">
              <th className="text-left p-2">Table</th>
              <th className="text-left p-2">Type</th>
              <th className="text-left p-2">Message</th>
              <th className="text-left p-2">Date</th>
            </tr>
          </thead>
          <tbody>
            {exceptions.map((row, i) => (
              <tr key={i} className="border-t">
                <td className="p-2 font-mono text-xs">{row.exception_table_name}</td>
                <td className="p-2">{row.exception_type ?? "—"}</td>
                <td className="p-2 max-w-xs truncate">{row.error_message ?? "—"}</td>
                <td className="p-2">{row.exception_date ? new Date(row.exception_date).toLocaleString() : "—"}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </section>
    </div>
  );
}
