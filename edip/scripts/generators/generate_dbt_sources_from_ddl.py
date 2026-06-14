#!/usr/bin/env python3
"""
Generate dbt sources + staging models from PPDM Lite 1.1 Postgres DDL.
Parses CREATE TABLE blocks; extracts columns from both active and commented lines.
Run from repo root: python scripts/generators/generate_dbt_sources_from_ddl.py
"""
from __future__ import annotations

import argparse
import re
from pathlib import Path


def to_snake_case(name: str) -> str:
    return name.lower()


def parse_ddl(content: str) -> dict[str, list[tuple[str, str | None]]]:
    """Parse DDL and return {table_name: [(column_name, data_type), ...]}."""
    tables: dict[str, list[tuple[str, str | None]]] = {}
    # Match CREATE table <name> ( ... );  (case-insensitive, multiline)
    pattern = re.compile(
        r"CREATE\s+table\s+(\w+)\s*\((.*?)\)\s*;",
        re.IGNORECASE | re.DOTALL,
    )
    for m in pattern.finditer(content):
        table_name = m.group(1).strip().lower()
        body = m.group(2)
        columns: list[tuple[str, str | None]] = []
        seen = set()
        for line in body.splitlines():
            line = line.strip().rstrip(",").strip()
            if not line:
                continue
            col_name: str | None = None
            col_type: str | None = None
            if line.startswith("--"):
                # Commented column: -- COL_NAME  TYPE ...
                rest = line[2:].strip()
                parts = rest.split(None, 1)
                if parts:
                    col_name = parts[0].strip().upper()
                    col_type = parts[1].strip() if len(parts) > 1 else None
            else:
                # Active column: COL_NAME  TYPE ...
                parts = line.split(None, 1)
                if parts:
                    col_name = parts[0].strip().upper()
                    col_type = parts[1].strip() if len(parts) > 1 else None
            if col_name and col_name not in seen:
                seen.add(col_name)
                columns.append((col_name, col_type))
        if table_name and columns:
            tables[table_name] = columns
    return tables


def main() -> None:
    repo_root = Path(__file__).resolve().parents[2]
    default_ddl = repo_root / "scripts" / "ddl" / "ppdm_lite11_postgres_ddl.sql"
    parser = argparse.ArgumentParser(description="Generate dbt sources and staging from PPDM Lite DDL")
    parser.add_argument(
        "ddl_path",
        nargs="?",
        type=Path,
        default=default_ddl,
        help=f"Path to DDL file (default: {default_ddl})",
    )
    parser.add_argument(
        "--output-dir",
        type=Path,
        default=repo_root / "dbt" / "edip_dbt",
        help="dbt project root",
    )
    args = parser.parse_args()
    ddl_path = args.ddl_path if args.ddl_path.is_absolute() else repo_root / args.ddl_path
    if not ddl_path.exists():
        # Fallback: try ppdm-edip copy
        fallback = repo_root.parent / "ppdm-edip" / "scripts" / "init" / "ppdm_lite11_postgres_ddl.sql"
        if fallback.exists():
            ddl_path = fallback
        else:
            raise FileNotFoundError(f"DDL not found: {ddl_path}")
    content = ddl_path.read_text(encoding="utf-8", errors="replace")
    tables = parse_ddl(content)

    output_dir = args.output_dir if args.output_dir.is_absolute() else repo_root / args.output_dir
    sources_dir = output_dir / "models" / "sources"
    staging_dir = output_dir / "models" / "staging" / "ppdm_lite"
    sources_dir.mkdir(parents=True, exist_ok=True)
    staging_dir.mkdir(parents=True, exist_ok=True)

    # A) ppdm_lite_sources.yml
    sources_lines = [
        "version: 2",
        "",
        "sources:",
        "  - name: ppdm_lite",
        "    schema: ppdm_lite",
        "    description: PPDM Lite 1.1 integration layer (Silver), publish-only",
        "    tables:",
    ]
    for table_name in sorted(tables.keys()):
        cols = tables[table_name]
        sources_lines.append(f"      - name: {table_name}")
        sources_lines.append(f"        description: PPDM Lite table {table_name}")
        if cols:
            sources_lines.append("        columns:")
            for col_name, _ in cols:
                sources_lines.append(f"          - name: {to_snake_case(col_name)}")
        sources_lines.append("")
    (sources_dir / "ppdm_lite_sources.yml").write_text("\n".join(sources_lines), encoding="utf-8")

    # B) stg_ppdm_lite__<table>.sql
    for table_name in sorted(tables.keys()):
        cols = tables[table_name]
        sel_parts = []
        for col_name, _ in cols:
            snaked = to_snake_case(col_name)
            sel_parts.append(f"    {snaked}")
        sql = f"""-- Staging for ppdm_lite.{table_name} (generated)
select
{",\n".join(sel_parts)}
from {{{{ source('ppdm_lite', '{table_name}') }}}}
"""
        (staging_dir / f"stg_ppdm_lite__{table_name}.sql").write_text(sql, encoding="utf-8")

    # C) stg_ppdm_lite__schema_manifest.sql — (table_name, column_name) for auditing/coverage
    manifest_unions = []
    for table_name in sorted(tables.keys()):
        cols = tables[table_name]
        for col_name, _ in cols:
            snaked = to_snake_case(col_name)
            manifest_unions.append(f"    select '{table_name}' as table_name, '{snaked}' as column_name")
    manifest_sql = """-- Schema manifest: (table_name, column_name) for governance and coverage scoring (generated)
with base as (
""" + "\nunion all\n".join(manifest_unions) + """
)
select * from base
order by table_name, column_name
"""
    (staging_dir / "stg_ppdm_lite__schema_manifest.sql").write_text(manifest_sql, encoding="utf-8")

    print(f"Parsed {len(tables)} tables from {ddl_path}")
    print(f"Wrote sources: {sources_dir / 'ppdm_lite_sources.yml'}")
    print(f"Wrote {len(tables)} staging models + schema_manifest in {staging_dir}")


if __name__ == "__main__":
    main()
