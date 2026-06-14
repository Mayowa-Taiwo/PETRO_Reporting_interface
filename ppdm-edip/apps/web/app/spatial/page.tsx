"use client";

import { useEffect, useState } from "react";
import dynamic from "next/dynamic";
import type { MapFeatureCollection } from "@/components/Map";

const API = process.env.NEXT_PUBLIC_API_URL || "http://localhost:8007";

const Map = dynamic(() => import("@/components/Map"), { ssr: false });

export default function SpatialPage() {
  const [layers, setLayers] = useState<Array<{ layer_id: string; source_table: string; geom_type: string }>>([]);
  const [selectedLayer, setSelectedLayer] = useState<string | null>(null);
  const [geojson, setGeojson] = useState<MapFeatureCollection | null>(null);

  useEffect(() => {
    fetch(`${API}/v1/spatial/layers`)
      .then((r) => r.json())
      .then((data) => {
        setLayers(Array.isArray(data) ? data : []);
        if (data?.[0]) setSelectedLayer(data[0].layer_id);
      })
      .catch(() => {});
  }, []);

  useEffect(() => {
    if (!selectedLayer) return;
    fetch(`${API}/v1/spatial/layers/${selectedLayer}/features`)
      .then((r) => r.json())
      .then((data) => setGeojson(data))
      .catch(() => setGeojson({ type: "FeatureCollection", features: [] }));
  }, [selectedLayer]);

  return (
    <div className="space-y-4">
      <h1 className="text-2xl font-bold">Spatial Asset Explorer</h1>
      <div className="flex gap-4">
        <div className="w-56 border rounded p-2 bg-white">
          <h2 className="font-semibold mb-2">Layers</h2>
          {layers.map((l) => (
            <label key={l.layer_id} className="flex items-center gap-2 cursor-pointer">
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
    </div>
  );
}
