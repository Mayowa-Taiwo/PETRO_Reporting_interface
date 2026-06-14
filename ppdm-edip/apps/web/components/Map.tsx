"use client";

import { useEffect, useRef } from "react";

/** Local type for API GeoJSON; avoids conflicting with global GeoJSON types. */
export type MapFeatureCollection = {
  type: "FeatureCollection";
  features: Array<{
    type: "Feature";
    geometry?: { type: string; coordinates: number[] | number[][] };
    properties?: Record<string, unknown>;
  }>;
};

export default function Map({
  geojson,
}: {
  geojson: MapFeatureCollection | null;
}) {
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!ref.current || typeof window === "undefined") return;
    const L = require("leaflet");
    const map = L.map(ref.current).setView([9.0, 8.0], 5);
    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution: "© OpenStreetMap",
    }).addTo(map);

    const layers: L.Layer[] = [];
    if (geojson?.features?.length) {
      geojson.features.forEach((f) => {
        const geom = f.geometry;
        if (!geom) return;
        if (geom.type === "Point" && Array.isArray(geom.coordinates)) {
          const [lng, lat] = geom.coordinates;
          const m = L.marker([lat, lng]).addTo(map);
          if (f.properties?.source_pk) m.bindPopup(String(f.properties.source_pk));
          layers.push(m);
        }
      });
    }
    return () => {
      map.remove();
    };
  }, [geojson]);

  return <div ref={ref} className="w-full h-full" />;
}
