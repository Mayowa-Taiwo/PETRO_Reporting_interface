"use client";

import { useEffect, useState } from "react";
import dynamic from "next/dynamic";
import Link from "next/link";
import { governanceFetch } from "@/lib/api";
import type { MapFeatureCollection } from "@/components/Map";

const Map = dynamic(() => import("@/components/Map"), { ssr: false });

export default function CompliancePage() {
  const [layers, setLayers] = useState<Array<{ layer_id: string; source_table: string; geom_type: string }>>([]);
  const [selectedLayer, setSelectedLayer] = useState<string | null>(null);
  const [geojson, setGeojson] = useState<MapFeatureCollection | null>(null);

  useEffect(() => {
    governanceFetch("/v1/spatial/layers")
      .then((r) => r.json())
      .then((data) => {
        setLayers(Array.isArray(data) ? data : []);
        if (data?.[0]) setSelectedLayer(data[0].layer_id);
      })
      .catch(() => {});
  }, []);

  useEffect(() => {
    if (!selectedLayer) return;
    governanceFetch(`/v1/spatial/layers/${selectedLayer}/features`)
      .then((r) => r.json())
      .then((data) => setGeojson(data))
      .catch(() => setGeojson({ type: "FeatureCollection", features: [] }));
  }, [selectedLayer]);

  return (
    <div className="space-y-8">
      <div>
        <h1 className="text-2xl font-bold">Compliance &amp; Regulatory Intelligence</h1>
        <p className="text-slate-600 mt-1">
          Spatial asset visibility and schema compliance workflows powered by the governance backend and LDV Platform core.
        </p>
      </div>

      <section className="rounded-lg border bg-white p-5">
        <h2 className="text-lg font-semibold mb-2">LDV Platform compliance CLI</h2>
        <p className="text-sm text-slate-600 mb-2">
          Run PPDM Lite schema compliance checks from the repository (no separate web UI):
        </p>
        <pre className="text-xs bg-slate-950 text-slate-200 p-3 rounded overflow-x-auto">
          python -m ldv_platform.run_compliance
        </pre>
        <Link href="/platform" className="text-sm text-blue-600 hover:underline mt-2 inline-block">
          Learn about LDV Platform Core →
        </Link>
      </section>

      <section>
        <h2 className="text-lg font-semibold mb-3">Spatial asset explorer</h2>
        <div className="flex gap-4 flex-col md:flex-row">
          <div className="w-full md:w-56 border rounded p-2 bg-white shrink-0">
            <h3 className="font-semibold mb-2 text-sm">Layers</h3>
            {layers.map((l) => (
              <label key={l.layer_id} className="flex items-center gap-2 cursor-pointer text-sm">
                <input
                  type="radio"
                  name="layer"
                  checked={selectedLayer === l.layer_id}
                  onChange={() => setSelectedLayer(l.layer_id)}
                />
                {l.layer_id}
              </label>
            ))}
            {layers.length === 0 && <p className="text-sm text-slate-500">No layers or API offline</p>}
          </div>
          <div className="flex-1 h-[400px] border rounded overflow-hidden bg-slate-100">
            <Map geojson={geojson} />
          </div>
        </div>
      </section>
    </div>
  );
}
