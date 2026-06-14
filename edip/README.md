# EDIP — Oil & Gas Executive BI Reporting Suite

Monorepo: **Silver** = `ppdm_lite` (PPDM Lite 1.1, publish-only), **Platinum** = star-schema marts (`marts_*`). No Bronze.

## Tech stack

- **Backend:** FastAPI, Pydantic v2, SQLAlchemy 2.0, Alembic, PostgreSQL + PostGIS, Redis
- **dbt:** Marts + tests + docs
- **Frontend:** Next.js, TypeScript, Tailwind, Recharts, TanStack Table
- **Infra:** Docker Compose (api, web, postgres-postgis, redis)

## Repo layout

```
edip/
  apps/
    api/          # FastAPI (auth, marts, governance, metadata)
    web/          # Next.js reporting portal
  dbt/
    edip_dbt/     # dbt project (staging + marts_shared + marts_*)
  infra/
    docker-compose.yml
  scripts/
    ddl/          # Place PPDM Lite 1.1 DDL here (or use ../ppdm-edip/scripts/init/)
    generators/   # generate_dbt_sources_from_ddl.py
    seed/         # SQL seeds (roles, tenant, user, mart contract)
  docs/
```

## 1. Generate dbt sources and staging from DDL

From repo root:

```bash
python scripts/generators/generate_dbt_sources_from_ddl.py
```

- **Input:** `scripts/ddl/ppdm_lite11_postgres_ddl.sql` or `../ppdm-edip/scripts/init/ppdm_lite11_postgres_ddl.sql`
- **Output:**
  - `dbt/edip_dbt/models/sources/ppdm_lite_sources.yml` (all tables + columns)
  - `dbt/edip_dbt/models/staging/ppdm_lite/stg_ppdm_lite__<table>.sql` (all 79 tables)
  - `dbt/edip_dbt/models/staging/ppdm_lite/stg_ppdm_lite__schema_manifest.sql` (table/column registry for coverage)

## 2. Run infrastructure

```bash
make up
```

Starts Postgres (port 5433), Redis (6379), API (8000), Web (3000).

## 3. Database migrations and seed

```bash
make migrate
```

Then seed roles, demo tenant, and demo user (and Production mart contract):

```bash
psql -h localhost -p 5433 -U postgres -d edip -f scripts/seed/seed_roles_tenant_user.sql
```

**Demo login:** `admin@demo.edip.local` / `demo123` (if the seed hash matches; otherwise set password in DB).

## 4. dbt

Set DB connection (default: localhost:5433, edip):

```bash
export DB_HOST=localhost DB_PORT=5433 DB_USER=postgres DB_PASSWORD=postgres DB_NAME=edip
cd dbt/edip_dbt && dbt deps && dbt run
make dbt-run
make dbt-test
```

Requires `ppdm_lite` schema and tables to exist (deploy PPDM Lite 1.1 DDL separately; do not recreate via migrations).

## 5. Run app locally (without Docker)

```bash
make api    # FastAPI on :8000
make web    # Next.js on :3000
```

## 6. Add a new mart module

1. Create schema in Alembic if needed (`marts_*`).
2. Add dbt models under `dbt/edip_dbt/models/marts_<name>/` (fact + dims, with `tenant_id` and RLS).
3. Register mart in `meta.mart_registry` and contract in `meta.mart_contract_item`.
4. Add coverage scoring and API endpoints as needed.

## API (MVP)

- `POST /v1/auth/login` — JWT
- `GET /v1/auth/me` — current user
- `GET /v1/marts/production/kpis` — ≥12 KPIs
- `GET /v1/marts/production/pdens` — PDEN list
- `GET /v1/marts/production/timeseries` — time series
- `GET /v1/governance/dq-scores` — DQ and certification
- `GET /v1/metadata/dictionary/tables` — table list
- `GET /v1/metadata/dictionary/tables/{table}/columns` — columns (schema query param)
- `GET /v1/metadata/lineage` — lineage edges
- `GET /v1/metadata/exceptions` — exceptions

## Database rules

- Do **not** recreate `ppdm_lite` tables in migrations; treat as external contract.
- You may create: `meta`, `ref`, `security`, `marts_*`.
- Every marts_* fact/dim includes `tenant_id` and is protected by RLS.

## Tests

- **API:** `cd apps/api && uv run pytest`
- **Auth / RLS / coverage:** unit tests as in `apps/api/tests/`.
