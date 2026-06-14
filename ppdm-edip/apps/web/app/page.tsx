export default function Home() {
  return (
    <div className="max-w-3xl mx-auto space-y-6">
      <h1 className="text-2xl font-bold">Energy Decision Intelligence Platform</h1>
      <p className="text-slate-600">
        PPDM Lite 1.1 consumption contract: Bronze → Silver → Gold with three products.
      </p>
      <ul className="list-disc list-inside space-y-2">
        <li><a href="/warehouse" className="text-blue-600 hover:underline">Warehouse Core</a> — Jobs, DQ scores, lineage, exceptions</li>
        <li><a href="/spatial" className="text-blue-600 hover:underline">Spatial Explorer</a> — GIS layers and features</li>
        <li><a href="/production" className="text-blue-600 hover:underline">Production Intelligence</a> — PDEN explorer, volumes, rollups</li>
        <li><a href="/admin" className="text-blue-600 hover:underline">Admin</a> — Contract, sources, runs</li>
      </ul>
    </div>
  );
}
