"use client";

import { useEffect, useState } from "react";

const API = process.env.NEXT_PUBLIC_API_URL || "http://localhost:8007";

type DqRow = { target_table: string; dq_score: number; certified_ind: boolean; computed_at?: string | null };
type LineageRow = {
  source_table_name: string;
  source_column_name: string;
  target_table_name: string;
  target_column_name: string;
  run_id: string | null;
  created_at: string | null;
};
type ExceptionRow = {
  exception_table_name: string;
  exception_column_name: string | null;
  exception_type: string | null;
  error_message: string | null;
  run_id: string | null;
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

export default function WarehousePage() {
  const [runs, setRuns] = useState<Array<{ run_id: string; status: string; started_at: string }>>([]);
  const [dq, setDq] = useState<DqRow[]>([]);
  const [lineage, setLineage] = useState<LineageRow[]>([]);
  const [exceptions, setExceptions] = useState<ExceptionRow[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const toJson = (r: Response) => {
      if (!r.ok) throw new Error(`Request failed (${r.status})`);
      return r.json();
    };
    Promise.all([
      fetch(`${API}/v1/jobs/runs`).then(toJson),
      fetch(`${API}/v1/admin/dq/scores`).then(toJson),
      fetch(`${API}/v1/admin/lineage`).then(toJson),
      fetch(`${API}/v1/admin/exceptions`).then(toJson),
    ])
      .then(([runsData, dqData, lineageData, excData]) => {
        setRuns(Array.isArray(runsData) ? runsData : []);
        const dqRows = Array.isArray(dqData) ? dqData : [];
        setDq(latestDqPerTable(dqRows));
        setLineage(Array.isArray(lineageData) ? lineageData.slice(0, 30) : []);
        setExceptions(Array.isArray(excData) ? excData.slice(0, 20) : []);
      })
      .catch(() => {})
      .finally(() => setLoading(false));
  }, []);

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold">Warehouse Core</h1>
      <section>
        <h2 className="text-lg font-semibold mb-2">Recent runs</h2>
        {loading ? (
          <p>Loading...</p>
        ) : (
          <table className="border table-auto w-full text-sm">
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
                  <td className="p-2 font-mono text-xs">{r.run_id.slice(0, 8)}...</td>
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
        <table className="border table-auto w-full text-sm">
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
        <table className="border table-auto w-full text-sm">
          <thead>
            <tr className="bg-slate-100">
              <th className="text-left p-2">Source table.column</th>
              <th className="text-left p-2">Target table.column</th>
              <th className="text-left p-2">Run</th>
            </tr>
          </thead>
          <tbody>
            {lineage.map((row, i) => (
              <tr key={`${row.source_table_name}-${row.source_column_name}-${row.target_table_name}-${row.target_column_name}-${i}`} className="border-t">
                <td className="p-2 font-mono text-xs">{row.source_table_name}.{row.source_column_name}</td>
                <td className="p-2 font-mono text-xs">{row.target_table_name}.{row.target_column_name}</td>
                <td className="p-2 font-mono text-xs">{row.run_id ? row.run_id.slice(0, 8) + "…" : "—"}</td>
              </tr>
            ))}
            {lineage.length === 0 && !loading && <tr><td colSpan={3} className="p-2 text-slate-500">No lineage records</td></tr>}
          </tbody>
        </table>
      </section>
      <section>
        <h2 className="text-lg font-semibold mb-2">Exceptions (recent)</h2>
        <table className="border table-auto w-full text-sm">
          <thead>
            <tr className="bg-slate-100">
              <th className="text-left p-2">Table</th>
              <th className="text-left p-2">Column</th>
              <th className="text-left p-2">Type</th>
              <th className="text-left p-2">Message</th>
              <th className="text-left p-2">Date</th>
            </tr>
          </thead>
          <tbody>
            {exceptions.map((row, i) => (
              <tr key={`${row.exception_table_name}-${i}`} className="border-t">
                <td className="p-2 font-mono text-xs">{row.exception_table_name}</td>
                <td className="p-2 font-mono text-xs">{row.exception_column_name ?? "—"}</td>
                <td className="p-2">{row.exception_type ?? "—"}</td>
                <td className="p-2 max-w-xs truncate" title={row.error_message ?? undefined}>{row.error_message ?? "—"}</td>
                <td className="p-2 text-slate-600">{row.exception_date ? new Date(row.exception_date).toLocaleString() : "—"}</td>
              </tr>
            ))}
            {exceptions.length === 0 && !loading && <tr><td colSpan={5} className="p-2 text-slate-500">No exceptions</td></tr>}
          </tbody>
        </table>
      </section>
    </div>
  );
}
