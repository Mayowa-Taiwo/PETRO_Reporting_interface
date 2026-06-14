"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { apiFetch, getToken } from "@/lib/api";

const API = process.env.NEXT_PUBLIC_API_URL || "http://localhost:8007";

export default function AdminPage() {
  const [sources, setSources] = useState<Array<{ source_id: string; source_name: string; source_type: string }>>([]);
  const [tables, setTables] = useState<Array<{ table_name: string; table_comment: string | null }>>([]);
  const [runBody, setRunBody] = useState({ source_id: "", mode: "full_refresh" });
  const [runResult, setRunResult] = useState<string | null>(null);

  useEffect(() => {
    const toJson = (r: Response) => {
      if (!r.ok) throw new Error(`Request failed (${r.status})`);
      return r.json();
    };
    Promise.all([
      fetch(`${API}/v1/admin/sources`).then(toJson),
      fetch(`${API}/v1/admin/contract/tables`).then(toJson),
    ])
      .then(([s, t]) => {
        setSources(Array.isArray(s) ? s : []);
        setTables(Array.isArray(t) ? t : []);
        if (Array.isArray(s) && s[0]) setRunBody((prev) => ({ ...prev, source_id: s[0].source_id }));
      })
      .catch(() => {});
  }, []);

  const runJob = () => {
    if (!getToken()) {
      setRunResult("Sign in as admin to run jobs.");
      return;
    }
    setRunResult(null);
    apiFetch("/v1/jobs/run", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(runBody),
    })
      .then((r) => {
        if (r.status === 401 || r.status === 403) {
          setRunResult("Admin sign-in required to run jobs.");
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
    <div className="space-y-6">
      <h1 className="text-2xl font-bold">Admin</h1>
      <section>
        <h2 className="text-lg font-semibold mb-2">Run job</h2>
        <p className="text-sm text-slate-600 mb-2">
          Browsing is open; starting a job requires an admin account.{" "}
          <Link href="/login" className="text-blue-600 hover:underline">Sign in</Link>
        </p>
        <div className="flex gap-2 items-end">
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
          <button onClick={runJob} className="bg-slate-900 text-white px-4 py-2 rounded hover:bg-slate-700">Run</button>
        </div>
        {runResult && <p className="mt-2 text-sm text-slate-600">{runResult}</p>}
      </section>
      <section>
        <h2 className="text-lg font-semibold mb-2">Sources</h2>
        <table className="border table-auto w-full text-sm">
          <thead>
            <tr className="bg-slate-100">
              <th className="text-left p-2">Name</th>
              <th className="text-left p-2">Type</th>
              <th className="text-left p-2">ID</th>
            </tr>
          </thead>
          <tbody>
            {sources.map((s) => (
              <tr key={s.source_id} className="border-t">
                <td className="p-2">{s.source_name}</td>
                <td className="p-2">{s.source_type}</td>
                <td className="p-2 font-mono text-xs">{s.source_id.slice(0, 8)}...</td>
              </tr>
            ))}
          </tbody>
        </table>
      </section>
      <section>
        <h2 className="text-lg font-semibold mb-2">Contract tables (PPDM Lite)</h2>
        <table className="border table-auto w-full text-sm">
          <thead>
            <tr className="bg-slate-100">
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
      </section>
    </div>
  );
}
