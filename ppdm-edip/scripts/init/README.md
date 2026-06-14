# PPDM Lite 1.1 full DDL

**File:** `ppdm_lite11_postgres_ddl.sql` — official PPDM Lite 1.1 tables (79 tables), PKs, FKs, indexes, comments.

## How to run

The DDL uses unqualified table names. Create the schema and run the script with `search_path` set to `ppdm_lite`:

```bash
# From repo root, with psql connected to your DB:
psql -h localhost -U edip -d edip -v ON_ERROR_STOP=1 -c "CREATE SCHEMA IF NOT EXISTS ppdm_lite; SET search_path TO ppdm_lite; \i scripts/init/ppdm_lite11_postgres_ddl.sql"
```

Or from within `psql`:

```sql
CREATE SCHEMA IF NOT EXISTS ppdm_lite;
SET search_path TO ppdm_lite;
\i scripts/init/ppdm_lite11_postgres_ddl.sql
```

**Note:** If you already ran the EDIP MVP migrations (`03_ppdm_lite_meta.sql`, `04_ppdm_lite_production_spatial.sql`), some tables (e.g. `l_pden`, `l_ppdm_origin`) already exist. For a clean full-DDL run, use a fresh database or drop the ppdm_lite schema first. See **docs/FULL_PPDM_LITE_DDL.md**.
