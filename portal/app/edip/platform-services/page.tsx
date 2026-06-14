import Link from "next/link";

export default function PlatformServicesPage() {
  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold">Platform Services</h1>
        <p className="text-slate-600 mt-1">
          Shared Python capabilities from LDV Platform Core that underpin EDIP reporting and governance.
        </p>
      </div>
      <ul className="space-y-4">
        <li className="border rounded-lg bg-white p-4">
          <h2 className="font-semibold">Compliance engine</h2>
          <p className="text-sm text-slate-600 mt-1">PPDM Lite schema compliance scoring via <code className="text-xs bg-slate-100 px-1">ldv_platform.run_compliance</code>.</p>
        </li>
        <li className="border rounded-lg bg-white p-4">
          <h2 className="font-semibold">Domain products</h2>
          <p className="text-sm text-slate-600 mt-1">Master and contract domain modules in <code className="text-xs bg-slate-100 px-1">ldv_platform/domain_products/</code>.</p>
        </li>
        <li className="border rounded-lg bg-white p-4">
          <h2 className="font-semibold">Governance API</h2>
          <p className="text-sm text-slate-600 mt-1">TRD warehouse, production marts, and spatial services (proxied at <code className="text-xs bg-slate-100 px-1">/api/governance</code>).</p>
        </li>
      </ul>
      <Link href="/platform" className="text-blue-600 hover:underline text-sm">
        Full LDV Platform Core overview →
      </Link>
    </div>
  );
}
