# Full PPDM Lite 1.1 DDL — consumption contract

The main EDIP spec (Step 1) requires:

> Execute the file: **edip_ppdm_lite11_postgres_ddl.sql**  
> This creates schema `ppdm_lite` and **all** PPDM Lite 1.1 tables + keys + indexes (Postgres-friendly).

## Current situation (Option B — full DDL in new environment)

- **Full DDL is the default.** The repo uses the full PPDM Lite 1.1 DDL; MVP table definitions are deprecated.
- **scripts/init/ppdm_lite11_postgres_ddl.sql** — canonical source (79 tables).
- **Docker init** runs in order: `01_schemas` → `02_meta` → **`03_ppdm_lite_full_ddl`** (full DDL with `SET search_path TO ppdm_lite`) → `04_ppdm_lite_catalog_columns` (add catalog columns to L_PPDM_TABLE/L_PPDM_COLUMN and lineage/exception columns) → `05_bronze_silver_landing` → `06_contract_seed` (from information_schema) → `07_essential_policy`.
- Old MVP-only files (`03_ppdm_lite_meta.sql`, `04_ppdm_lite_production_spatial.sql`) are in **infra/docker/migrations/init/_deprecated/** and are not run.

So the “full DDL” is the **missing** artifact that would define the complete PPDM Lite 1.1 consumption contract.

## When you have the full DDL file

1. **Where to put it**  
   Place the file in the repo, for example:
   - `infra/docker/migrations/init/edip_ppdm_lite11_postgres_ddl.sql`, or  
   - `scripts/init/edip_ppdm_lite11_postgres_ddl.sql`  
   and reference it from your runbooks/README.

2. **Order of execution**  
   - Create schemas first (`01_schemas.sql` already creates `ppdm_lite`).  
   - Run the full DDL **before** any seeds that depend on ppdm_lite tables (e.g. contract catalog, demo data).  
   - If the full DDL creates its own `ppdm_lite` schema, you can either merge that into `01_schemas.sql` or run the DDL right after it.

3. **Avoiding conflicts with MVP tables**  
   The current migrations already create these in ppdm_lite:
   - `l_ppdm_table`, `l_ppdm_column`, `l_ppdm_origin`, `l_ppdm_exception`
   - `l_pden`, `l_pden_vol_summary`, `l_sp_component`, `edip_feature_geom`  
   When you introduce the full DDL, either:
   - **Option A:** Have the full DDL define **all** ppdm_lite tables (including these), and remove the MVP table definitions from `03_ppdm_lite_meta.sql` and `04_ppdm_lite_production_spatial.sql` so they are not duplicated, or  
   - **Option B:** Run the full DDL in a **new** environment and migrate existing MVP data into the full schema as needed.

4. **Contract catalog after full DDL (Step 3)**  
   Once all PPDM Lite 1.1 tables exist, populate the contract from Postgres:
   - **L_PPDM_TABLE:** one row per table in `ppdm_lite` (e.g. from `information_schema.tables` where `table_schema = 'ppdm_lite'`).
   - **L_PPDM_COLUMN:** one row per column with `ordinal_position` as `column_sequence` (from `information_schema.columns`).  
   This gives 100% contract coverage for DQ (Step 4) across **all** ppdm_lite tables.

## If you don’t have an official PPDM Lite 1.1 DDL

- **PPDM Lite 1.1** is a specific rolled-up model; there is no single canonical “PPDM Lite 1.1 PostgreSQL DDL” in public search results.  
- You may get the DDL from:
  - Your organization’s data architecture / PPDM steward, or  
  - A vendor/partner PPDM Lite 1.1 package, or  
  - A conversion from the PPDM Lite 1.1 spec (e.g. PDF or another DB) to Postgres.

Until that file is available, the repo continues to use the **MVP subset** of ppdm_lite tables and partial DQ/pipeline coverage as described in **docs/SPEC_ALIGNMENT.md**.
