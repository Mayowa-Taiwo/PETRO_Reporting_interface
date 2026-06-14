"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { getToken, removeToken } from "@/lib/api";

export default function ClientNav() {
  const router = useRouter();
  const [hasToken, setHasToken] = useState(false);

  useEffect(() => {
    setHasToken(!!getToken());
  }, []);

  const handleLogout = () => {
    removeToken();
    setHasToken(false);
    router.push("/login");
    router.refresh();
  };

  return (
    <nav className="flex gap-4 items-center">
      <Link href="/warehouse" className="hover:underline">Warehouse Core</Link>
      <Link href="/spatial" className="hover:underline">Spatial Explorer</Link>
      <Link href="/production" className="hover:underline">Production</Link>
      <Link href="/reporting" className="hover:underline">Reporting</Link>
      <Link href="/admin" className="hover:underline">Admin</Link>
      {hasToken ? (
        <button type="button" onClick={handleLogout} className="hover:underline text-sm">
          Logout
        </button>
      ) : (
        <Link href="/login" className="hover:underline">Login</Link>
      )}
    </nav>
  );
}
