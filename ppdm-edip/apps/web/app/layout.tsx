import type { Metadata } from "next";
import "./globals.css";
import Link from "next/link";
import ClientNav from "@/components/ClientNav";

export const metadata: Metadata = {
  title: "EDIP — Energy Decision Intelligence Platform",
  description: "PPDM Lite 1.1 consumption contract platform",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className="min-h-screen flex flex-col">
        <header className="border-b bg-slate-900 text-white px-4 py-3 flex items-center justify-between">
          <Link href="/" className="font-bold text-lg">EDIP</Link>
          <ClientNav />
        </header>
        <main className="flex-1 p-4">{children}</main>
      </body>
    </html>
  );
}
