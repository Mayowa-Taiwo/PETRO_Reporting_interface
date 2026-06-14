"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { useParams } from "next/navigation";
import { governanceFetch } from "@/lib/api";

export default function PdenDetailPage() {
  const params = useParams();
  const pdenId = params.pdenId as string;
  const [pden, setPden] = useState<Record<string, unknown> | null>(null);
  const [volumes, setVolumes] = useState<Array<{ volume_date: string; oil_cum_volume: number | null; gas_cum_volume: number | null }>>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!pdenId) return;
    (async () => {
      try {
        const pRes = await governanceFetch(`/v1/production/pdens/by-id/${encodeURIComponent(pdenId)}`);
        const p = await pRes.json();
        if (p.detail) {
          setPden(null);
          return;
        }
        setPden(p);
        const ptype = encodeURIComponent(String(p.pden_type || "WELL"));
        const psrc = encodeURIComponent(String(p.pden_source || "DEMO"));
        const vRes = await governanceFetch(
          `/v1/production/pdens/${encodeURIComponent(pdenId)}/volumes?pden_type=${ptype}&pden_source=${psrc}`,
        );
        const v = await vRes.json();
        setVolumes(Array.isArray(v) ? v : []);
      } catch {
        setPden(null);
      } finally {
        setLoading(false);
      }
    })();
  }, []);

  if (loading) return <p>Loading…</p>;
  if (!pden) {
    return (
      <p>
        PDEN not found.{" "}
        <Link href="/edip/production" className="text-blue-600">
          Back to production
        </Link>
      </p>
    );
  }

  return (
    <div className="space-y-6">
      <Link href="/edip/production" className="text-blue-600 hover:underline">
        ← Production
      </Link>
      <h1 className="text-2xl font-bold">{String(pden.pden_name || pdenId)}</h1>
      <dl className="grid grid-cols-2 gap-2 text-sm bg-white border rounded p-4">
        <dt className="text-slate-600">PDEN ID</dt>
        <dd className="font-mono">{String(pden.pden_id)}</dd>
        <dt className="text-slate-600">Type</dt>
        <dd>{String(pden.pden_type)}</dd>
        <dt className="text-slate-600">Source</dt>
        <dd>{String(pden.pden_source)}</dd>
        <dt className="text-slate-600">Primary product</dt>
        <dd>{String(pden.primary_product)}</dd>
        <dt className="text-slate-600">UWI</dt>
        <dd>{String(pden.uwi)}</dd>
      </dl>
      <section>
        <h2 className="text-lg font-semibold mb-2">Volume trend</h2>
        <table className="border table-auto w-full text-sm bg-white">
          <thead>
            <tr className="bg-slate-100">
              <th className="text-left p-2">Date</th>
              <th className="text-right p-2">Oil cum</th>
              <th className="text-right p-2">Gas cum</th>
            </tr>
          </thead>
          <tbody>
            {volumes.map((v) => (
              <tr key={v.volume_date} className="border-t">
                <td className="p-2">{v.volume_date}</td>
                <td className="p-2 text-right">{v.oil_cum_volume != null ? v.oil_cum_volume.toLocaleString() : "—"}</td>
                <td className="p-2 text-right">{v.gas_cum_volume != null ? v.gas_cum_volume.toLocaleString() : "—"}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </section>
    </div>
  );
}
