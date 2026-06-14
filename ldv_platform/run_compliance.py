#!/usr/bin/env python3
"""
Run PPDM Lite schema compliance on a client schema (JSON file or built-in sample).
Outputs: score, findings, optional markdown report and migration stub.

Usage:
  python -m ldv_platform.run_compliance
  python -m ldv_platform.run_compliance --schema path/to/client_schema.json
  python -m ldv_platform.run_compliance --schema path/to/schema.json --report report.md --migration migration.sql
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path

# Run from repo root: python -m ldv_platform.run_compliance
from ldv_platform.core import (
    ClientSchema,
    check_schema_compliance,
    generate_compliance_report_md,
    generate_migration_stub_add_governance_columns,
)


def main() -> None:
    ap = argparse.ArgumentParser(description="PPDM Lite schema compliance check")
    ap.add_argument(
        "--schema",
        type=Path,
        default=None,
        help="Path to client schema JSON (default: use built-in sample)",
    )
    ap.add_argument("--report", type=Path, default=None, help="Write markdown report to file")
    ap.add_argument("--migration", type=Path, default=None, help="Write migration stub SQL to file")
    ap.add_argument("--dialect", choices=["postgresql", "oracle"], default="postgresql")
    args = ap.parse_args()

    if args.schema and args.schema.exists():
        client = ClientSchema.from_json_file(args.schema)
        print(f"Loaded schema from {args.schema} ({len(client.tables)} tables)")
    else:
        sample = Path(__file__).parent / "examples" / "sample_client_schema.json"
        if not sample.exists():
            print("No schema file and no sample found. Create examples/sample_client_schema.json or pass --schema.")
            return
        client = ClientSchema.from_json_file(sample)
        print(f"Using sample schema ({len(client.tables)} tables)")

    report = check_schema_compliance(client)
    print(f"\nCompliance score: {report.score:.1f}/100")
    print(f"  Errors: {report.summary.get('error', 0)}, Warnings: {report.summary.get('warning', 0)}, Info: {report.summary.get('info', 0)}")
    if report.findings:
        print("\nFindings (first 10):")
        for f in report.findings[:10]:
            print(f"  [{f.severity}] {f.table}: {f.message}")

    if args.report:
        generate_compliance_report_md(report, args.report)
        print(f"\nReport written to {args.report}")

    if args.migration:
        generate_migration_stub_add_governance_columns(report, dialect=args.dialect, output_path=args.migration)
        print(f"Migration stub written to {args.migration}")


if __name__ == "__main__":
    main()
