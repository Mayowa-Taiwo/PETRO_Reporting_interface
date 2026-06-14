"use client";

import { useEffect, useState } from "react";
import { apiFetch } from "@/lib/api";

export default function GovernancePage() {
  const [scores, setScores] = useState<Array<Record<string, unknown>>>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const token = typeof window !== "undefined" ? localStorage.getItem("edip_token") : null;
    if (!token) {
      window.location.href = "/login";
      return;
    }
    apiFetch("/v1/governance/dq-scores")
      .then((r) => (r.ok ? r.json() : []))
      .then((d) => setScores(Array.isArray(d) ? d : []))
      .finally(() => setLoading(false));
  }, []);

  if (loading) return <p className="p-4">Loading…</p>;

  return (
    <div className="space-y-8">
      <h1 className="text-2xl font-bold">Governance</h1>
      <section>
        <h2 className="text-lg font-semibold mb-3">Certification & DQ Scores</h2>
        <div className="grid gap-4 md:grid-cols-2">
          {scores.length === 0 ? (
            <p className="text-slate-500">No DQ scores yet. Run coverage scoring for marts.</p>
          ) : (
            scores.map((s: Record<string, unknown>, i: number) => (
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
                <div className="text-xs text-slate-400 mt-1">{String(s.computed_at ?? "")}</div>
              </div>
            ))
          )}
        </div>
      </section>
      <section>
        <h2 className="text-lg font-semibold mb-2">Coverage breakdown</h2>
        <p className="text-sm text-slate-600">
          Essential vs enhanced columns per mart contract (meta.mart_contract_item). Certified when DQ ≥ 80 and essential ≥ 90%.
        </p>
      </section>
    </div>
  );
}
