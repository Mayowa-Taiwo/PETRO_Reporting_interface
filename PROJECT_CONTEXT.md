# PROJECT_CONTEXT.md

Factual extraction of the **PETRO Reporting Interface** repository as it exists in source. Generated from code inspection only.

---

## 1. Project Identity

| Field | Value |
|-------|--------|
| **Project name** | PETRO Reporting Interface (repo folder: `PETRO_Reporting_interface`) |
| **Main purpose (from code/README)** | Unified petroleum/oil-and-gas reporting workspace: executive BI, production intelligence, governance, TRD-aligned warehouse operations, metadata, spatial assets, and compliance-related tooling. Combines an EDIP stack (dbt marts, Alembic migrations) with a ppdm-edip stack (PPDM Lite consumption, ingest jobs, Platinum production marts). |
| **Main user-facing features** | Portal landing; EDIP workspace with Executive KPI dashboard, Production PDEN explorer, Reporting (KPI tiles, drill-down, CSV export), Governance (DQ/certification, lineage, exceptions, contract catalog), TRD Warehouse (ingest runs, DQ scores, job run), Compliance (spatial map + CLI reference), Data Products (metadata dictionary), Platform Services info page; optional admin sign-in for TRD job runs. |
| **System type** | **Full-stack platform** with **ETL/transform** (dbt, SQL init scripts, ingest jobs), **dashboard/reporting UI**, and **two separate FastAPI backends** proxied through one Next.js Portal. Not a standalone connector product. |

**Primary user entry (root Docker):** `http://localhost:3003` (`portal/` app).

**Legacy/alternate frontends (still in repo, not published in root compose by default):** `edip/apps/web`, `ppdm-edip/apps/web` (Docker profile `dev-legacy-ui`).

---

## 2. Tech Stack

| Layer | Technology |
|-------|------------|
| **Frontend (primary)** | Next.js 14.2.35, React 18, TypeScript, Tailwind CSS 3.4 (`portal/`) |
| **Frontend (legacy)** | Next.js 14.2 (`ppdm-edip/apps/web`), Next.js 16.1 (`edip/apps/web`) |
| **Backend** | FastAPI, Uvicorn, Python 3.11 |
| **Database** | PostgreSQL 15 with PostGIS (`postgis/postgis:15-3.3` in Docker) — **two separate DB instances** in root compose (`edip_db`, `ppdm_db`) |
| **Cache** | Redis 7 (`edip_redis`, `ppdm_redis`) — configured in compose; limited direct usage observed in API route handlers |
| **ORM** | SQLAlchemy 2.x async (`AsyncSession`, `create_async_engine`) in both APIs; **most endpoints use raw SQL via `sqlalchemy.text()`**, not declarative ORM models |
| **Migrations (EDIP)** | Alembic (`edip/apps/api/alembic/`) |
| **Migrations (ppdm-edip)** | SQL init scripts under `ppdm-edip/infra/docker/migrations/init/` (not Alembic in that tree) |
| **Transform / ETL** | dbt (`edip/dbt/edip_dbt/`), Python generator (`edip/scripts/generators/generate_dbt_sources_from_ddl.py`), ppdm-edip ingest job (`ppdm-edip/apps/api/app/api/jobs.py`), SQL seeds |
| **API style** | REST JSON under `/v1/*`; Portal exposes reverse proxies at `/api/edip/*` and `/api/governance/*` |
| **Styling** | Tailwind CSS; PostCSS; app-specific `globals.css` in each Next app |
| **Charts / maps** | Recharts (`portal`, `edip/apps/web`); Leaflet via dynamic import (`portal/components/Map.tsx`, `ppdm-edip/apps/web/components/Map.tsx`) |
| **Auth** | JWT (python-jose); EDIP API uses DB-backed users (`security.users`); ppdm-edip API uses in-memory demo users (`ppdm-edip/apps/api/app/auth.py`) |
| **Package managers** | npm (`portal/`, `edip/apps/web/`, `ppdm-edip/apps/web/`); pip + `requirements.txt` / `pyproject.toml` for Python APIs |
| **Build tools** | Next.js build; Docker multi-stage-ish image builds; Makefile in `edip/Makefile` |
| **Docker / deployment** | Root `docker-compose.yml`; `edip/infra/docker-compose.yml`; `ppdm-edip/infra/docker/docker-compose.yml`; Dockerfiles in `portal/`, `edip/apps/api`, `edip/apps/web`, `ppdm-edip/apps/api`, `ppdm-edip/apps/web` |

### Environment variables discovered

| Variable | Where used | Purpose |
|----------|------------|---------|
| `DATABASE_URL` | Both APIs (`app/config.py`), Docker compose | Async PostgreSQL connection string |
| `DATABASE_URL_SYNC` | `edip/scripts/init/entrypoint.sh`, compose | Sync URL for psql/Alembic init |
| `REDIS_URL` | EDIP compose, `edip/apps/api` config default | Redis connection |
| `SECRET_KEY` | Both APIs | JWT signing |
| `EDIP_API_PROXY_TARGET` | `portal/app/api/edip/[...path]/route.ts`, root compose | Upstream EDIP API for Portal proxy |
| `GOVERNANCE_API_PROXY_TARGET` | `portal/app/api/governance/[...path]/route.ts`, root compose | Upstream ppdm-edip API for Portal proxy |
| `NEXT_PUBLIC_API_URL` | Legacy web apps | Direct API URL (bypass proxy) |
| `EDIP_API_INTERNAL_URL` | `edip/apps/web/src/lib/api.ts` | Server-side fallback for EDIP web proxy |
| `RUN_GENERATOR` | `edip/scripts/init/entrypoint.sh` | Enable DDL→dbt generator |
| `RUN_MIGRATIONS` | Init entrypoint | Run Alembic |
| `RUN_SEEDS` | Init entrypoint | Run SQL seeds |
| `RUN_DBT` | Init entrypoint | Run dbt deps/build |
| `DDL_PATH` | Init entrypoint | Path to PPDM Lite DDL file |
| `DBT_TARGET_SCHEMA` | Init entrypoint | dbt target schema name |
| `PGHOST` | Init entrypoint | Postgres host for readiness check |
| `algorithm`, `access_token_expire_minutes` | `app/config.py` defaults | JWT settings |

Settings load from optional `.env` via pydantic-settings (`env_file = ".env"`).

---

## 3. Folder Structure

| Path | Role |
|------|------|
| **`portal/`** | Primary Next.js product shell. Routes `/`, `/platform`, `/edip/*`. Proxies to both backends. |
| **`edip/`** | EDIP monorepo: FastAPI API, legacy Next web, dbt project, Alembic migrations, init/seed/generator scripts, infra compose. |
| **`edip/apps/api/`** | EDIP FastAPI app (`app/main.py`), Alembic, tests. |
| **`edip/apps/web/`** | Legacy EDIP Next.js UI (`src/app/`). |
| **`edip/dbt/edip_dbt/`** | dbt models (staging ppdm_lite, marts_* schemas). |
| **`edip/scripts/`** | `init/entrypoint.sh`, `seed/`, `generators/`, `ddl/` (README only for DDL file). |
| **`edip/infra/`** | Standalone EDIP docker-compose (db, redis, init, api, web on host ports). |
| **`ppdm-edip/`** | Second stack: FastAPI API (governance/TRD/production/spatial), legacy Next web, SQL migrations, seeds, docs. |
| **`ppdm-edip/apps/api/`** | ppdm-edip FastAPI app. |
| **`ppdm-edip/apps/web/`** | Legacy ppdm-edip Next.js UI. |
| **`ppdm-edip/infra/docker/`** | Standalone compose + SQL init migrations. |
| **`ppdm-edip/scripts/`** | `seed/`, `dq/`, `init/ppdm_lite11_postgres_ddl.sql`. |
| **`ppdm-edip/docs/`** | Specification/requirements markdown (TRD, BI suite, ADRs). |
| **`ppdm-edip/packages/shared/`** | Placeholder README only. |
| **`ldv_platform/`** | Python package stub: `run_compliance.py`, `domain_products/*` — **missing `core/` and `domain_products/__init__.py` in repo**. |
| **`docs/`** | Empty at repo root (no files found). |
| **`docker-compose.yml`** | Root orchestration: portal + both backends + both DBs. |

---

## 4. Frontend Inventory

### 4.1 Primary app: `portal/`

**Routes / pages**

| Route | File |
|-------|------|
| `/` | `portal/app/page.tsx` |
| `/platform` | `portal/app/platform/page.tsx` |
| `/edip` | `portal/app/edip/page.tsx` |
| `/edip/executive` | `portal/app/edip/executive/page.tsx` |
| `/edip/production` | `portal/app/edip/production/page.tsx` |
| `/edip/production/[pdenId]` | `portal/app/edip/production/[pdenId]/page.tsx` |
| `/edip/reporting` | `portal/app/edip/reporting/page.tsx` |
| `/edip/governance` | `portal/app/edip/governance/page.tsx` |
| `/edip/trd` | `portal/app/edip/trd/page.tsx` |
| `/edip/compliance` | `portal/app/edip/compliance/page.tsx` |
| `/edip/data-products` | `portal/app/edip/data-products/page.tsx` |
| `/edip/platform-services` | `portal/app/edip/platform-services/page.tsx` |
| `/edip/login` | `portal/app/edip/login/page.tsx` |
| `/api/edip/[...path]` | `portal/app/api/edip/[...path]/route.ts` (API proxy, not UI) |
| `/api/governance/[...path]` | `portal/app/api/governance/[...path]/route.ts` (API proxy) |

**Layouts:** `portal/app/layout.tsx` (root), `portal/app/edip/layout.tsx` (EDIP shell + nav).

**Components:** `portal/components/EdipNav.tsx`, `portal/components/Map.tsx`.

**API clients:** `portal/lib/api.ts` — `edipFetch()`, `governanceFetch()`, token helpers (`localStorage` key `edip_token`).

**State management:** React `useState`/`useEffect` only; JWT in `localStorage`. No Redux, Zustand, or React Query.

**Styling:** `portal/app/globals.css`, `portal/tailwind.config.js`, `portal/postcss.config.js`.

**Hardcoded product / brand strings in UI:** `PETRO Reporting Interface`, `EDIP Workspace`, `EDIP`, `TRD Warehouse`, `Governance`, `Executive Intelligence`, `Production Intelligence`, `Reporting`, `Compliance`, `Data Products`, `Platform Services`, `PPDM` (in compliance/governance copy), `LDV Platform Core`.

**Mock / demo data files:** None in `portal/`. Demo credentials referenced in UI text (`admin` / `change-me` for governance login).

### 4.2 Legacy app: `edip/apps/web/`

| Route | File |
|-------|------|
| `/` | `edip/apps/web/src/app/page.tsx` |
| `/dashboard` | `edip/apps/web/src/app/dashboard/page.tsx` |
| `/login` | `edip/apps/web/src/app/login/page.tsx` |
| `/governance` | `edip/apps/web/src/app/governance/page.tsx` |
| `/metadata` | `edip/apps/web/src/app/metadata/page.tsx` |
| `/api/edip/[...path]` | `edip/apps/web/src/app/api/edip/[...path]/route.ts` |

**Components:** `edip/apps/web/src/components/ClientNav.tsx`.

**API client:** `edip/apps/web/src/lib/api.ts`.

**Brands:** `EDIP`, `Oil & Gas Executive BI Reporting Suite`.

**Login gate:** `/dashboard`, `/governance`, `/metadata` redirect to `/login` if no `edip_token`.

### 4.3 Legacy app: `ppdm-edip/apps/web/`

| Route | File |
|-------|------|
| `/` | `ppdm-edip/apps/web/app/page.tsx` |
| `/warehouse` | `ppdm-edip/apps/web/app/warehouse/page.tsx` |
| `/spatial` | `ppdm-edip/apps/web/app/spatial/page.tsx` |
| `/production` | `ppdm-edip/apps/web/app/production/page.tsx` |
| `/production/[pdenId]` | `ppdm-edip/apps/web/app/production/[pdenId]/page.tsx` |
| `/reporting` | `ppdm-edip/apps/web/app/reporting/page.tsx` |
| `/admin` | `ppdm-edip/apps/web/app/admin/page.tsx` |
| `/login` | `ppdm-edip/apps/web/app/login/page.tsx` |

**Components:** `ClientNav.tsx`, `Map.tsx`.

**API client:** `ppdm-edip/apps/web/lib/api.ts` — defaults to `NEXT_PUBLIC_API_URL` or `http://localhost:8007`.

**Brands:** `EDIP` (header in layout), product copy references PPDM Lite / warehouse / production.

---

## 5. Backend Inventory

### 5.1 EDIP API (`edip/apps/api/`)

**Entrypoint:** `uvicorn app.main:app` (Dockerfile CMD, port 8000).

**Routers registered in** `edip/apps/api/app/main.py`:

| Prefix | Module |
|--------|--------|
| `/v1/auth` | `app/api/auth.py` |
| `/v1/marts` | `app/api/marts.py` |
| `/v1/governance` | `app/api/governance.py` |
| `/v1/metadata` | `app/api/metadata.py` |
| `/health` | inline in `main.py` |

**Services:** `edip/apps/api/app/services/coverage.py` — mart coverage / DQ score computation.

**Schemas:** Pydantic models inline in route modules (e.g. `LoginRequest`, `TokenResponse` in auth).

**Database:** SQLAlchemy async session (`app/database.py`); Alembic migrations:

- `edip/apps/api/alembic/versions/001_schemas_meta_ref_security.py` — schemas `meta`, `ref`, `security`, `marts_*`; tables for mart registry, contract items, users, tenants, roles, RLS policies.
- `edip/apps/api/alembic/versions/002_governance_fact_dq_score.py` — `marts_governance.fact_dq_score`.

**Auth:** DB users in `security.users`; login expects `email` + `password` (`edip/apps/api/app/api/auth.py`); bcrypt password verify; JWT with `sub`, `tenant_id`, `roles`.

**Background jobs / ETL:** No Celery/worker. Init container runs Alembic, seeds, optional dbt via `edip/scripts/init/entrypoint.sh`.

**Tests:** `edip/apps/api/tests/test_auth.py`.

### 5.2 ppdm-edip API (`ppdm-edip/apps/api/`)

**Entrypoint:** `uvicorn app.main:app` (port 8000 inside container).

**Routers in** `ppdm-edip/apps/api/app/main.py`:

| Prefix | Module |
|--------|--------|
| `/v1/auth` | `app/api/auth.py` |
| `/v1/admin` | `app/api/admin.py` |
| `/v1/jobs` | `app/api/jobs.py` |
| `/v1/production` | `app/api/production.py` |
| `/v1/marts` | `app/api/marts.py` |
| `/v1/marts/governance` | `app/api/governance.py` |
| `/v1/metadata` | `app/api/metadata.py` |
| `/v1/spatial` | `app/api/spatial.py` |
| `/health` | inline |

**Auth:** In-memory users `admin`/`change-me`, `viewer`/`viewer` (`ppdm-edip/apps/api/app/auth.py`). POST `/v1/jobs/run` requires `admin` role.

**Jobs:** `jobs.py` — creates `meta.ingest_run`, publishes silver→`ppdm_lite`, writes lineage, computes DQ scores (embedded SQL).

**Database access:** Raw SQL against schemas `meta`, `ppdm_lite`, `silver`, Platinum mart tables (see migrations `08_platinum_production_mart.sql`).

**Tests:** `ppdm-edip/apps/api/tests/test_api.py`.

### 5.3 Python CLI (`ldv_platform/`)

**Entrypoint:** `python -m ldv_platform.run_compliance` — imports `ldv_platform.core` (**module not present in repo**).

### 5.4 ETL / init scripts (selected)

| Script | Path |
|--------|------|
| Docker init entrypoint | `edip/scripts/init/entrypoint.sh` |
| Role/tenant/user seed | `edip/scripts/seed/seed_roles_tenant_user.sql` |
| dbt source generator | `edip/scripts/generators/generate_dbt_sources_from_ddl.py` |
| Demo PDEN/volumes seed | `ppdm-edip/scripts/seed/seed_demo_data.py` |
| Contract seed SQL | `ppdm-edip/scripts/seed/seed_contract_from_schema.sql`, `seed_essential_policy.sql` |
| DQ SQL | `ppdm-edip/scripts/dq/compute_dq_scores.sql` |
| DB init SQL (ppdm) | `ppdm-edip/infra/docker/migrations/init/*.sql` |
| PPDM Lite DDL copy | `ppdm-edip/scripts/init/ppdm_lite11_postgres_ddl.sql` |

**Scheduler / workers:** None found (no Airflow, Celery, or cron in repo).

---

## 6. Data Flow (as implemented)

```
┌─────────────────────────────────────────────────────────────────────────┐
│  Browser → Portal (localhost:3003)                                      │
│    /api/edip/*  ──proxy──► edip_api:8000  ──► PostgreSQL (edip DB)     │
│    /api/governance/* ──proxy──► ppdm_api:8000 ──► PostgreSQL (ppdm_db) │
└─────────────────────────────────────────────────────────────────────────┘

EDIP path:
  Optional upstream sources (referenced in docs/seeds, not live connectors in code)
    → bronze/silver/ppdm_lite (partial; dbt staging models from ppdm_lite tables)
    → dbt (edip/dbt/edip_dbt) → marts_production, marts_shared, marts_governance, etc.
    → EDIP API reads marts_* / meta / ppdm_lite via SQL
    → Portal /edip/executive, /edip/data-products, /edip/governance (EDIP API arm)

ppdm-edip path:
  meta.ingest_source / mapping_registry (seeded)
    → POST /v1/jobs/run copies silver.pden_staging → ppdm_lite.l_pden, lineage, DQ scores
    → Platinum mart SQL (08_platinum_production_mart.sql) + API queries on marts/production/*
    → Portal /edip/production, /edip/reporting, /edip/trd, /edip/governance (governance API arm)
    → Spatial layers/features from ppdm_lite / PostGIS → /edip/compliance map

Auth tokens (optional):
  governance login → JWT in localStorage → Bearer on governanceFetch for job run only
  EDIP API login (email/password) used by legacy edip web, not wired to Portal executive pages
```

---

## 7. Existing Business Objects (present in code/schema/API)

| Category | Objects |
|----------|---------|
| **Production entities** | PDEN (`l_pden`, `dim_pden`, `pden_id`, `pden_type`, `pden_source`), volumes (`l_pden_vol_summary`, `fact_production`), pools, UWI, operators (dim/rollup groupings) |
| **Marts / metrics** | Production KPIs (oil/gas/water/boe MTD/YTD, YoY, decline, production per well), coverage scores, certification flags, timeseries BOE |
| **Governance** | DQ table scores (`meta.dq_table_score`, `marts_governance.fact_dq_score`), essential/enhanced coverage, certified_ind, mart_contract_item, mart_registry |
| **Lineage** | `ppdm_lite.l_ppdm_origin`, `meta.lineage_edge`, API lineage edges |
| **Exceptions** | `ppdm_lite.l_ppdm_exception`, `meta.data_exception` |
| **Metadata** | `l_ppdm_table`, `l_ppdm_column`, information_schema dictionary endpoints |
| **Ingest / jobs** | `meta.ingest_source`, `meta.ingest_run`, `meta.mapping_registry`, job run_id, modes `full_refresh` / `incremental` |
| **Spatial** | Layers, GeoJSON features, `edip_feature_geom`, PostGIS points |
| **Security** | Users, tenants, roles (EDIP DB); demo users/roles (ppdm-edip in-memory) |
| **Reference** | UOM conversion, FX rates (EDIP Alembic `ref` schema) |
| **Reports / dashboards** | UI pages for executive dashboard, reporting workspace, production explorer — no separate report entity model in DB |
| **Files** | Referenced in ingest_source types (`file_drop`); no file upload API in routes inspected |
| **Connectors** | None implemented as live integration code; connection_ref column on ingest_source |

---

## 8. API / Route Map

### 8.1 EDIP API (`edip/apps/api`)

| Method | Path | File | Purpose | Status |
|--------|------|------|---------|--------|
| GET | `/health` | `app/main.py` | Health check | Implemented |
| POST | `/v1/auth/login` | `app/api/auth.py` | Email/password → JWT | Implemented (requires DB user) |
| GET | `/v1/auth/me` | `app/api/auth.py` | Current user | Implemented |
| GET | `/v1/marts/production/kpis` | `app/api/marts.py` | Production KPI aggregates | Implemented (SQL; may error if tables empty) |
| GET | `/v1/marts/production/pdens` | `app/api/marts.py` | PDEN list | Implemented |
| GET | `/v1/marts/production/timeseries` | `app/api/marts.py` | BOE timeseries | Implemented |
| GET | `/v1/governance/dq-scores` | `app/api/governance.py` | Mart DQ scores | Implemented |
| GET | `/v1/metadata/dictionary/tables` | `app/api/metadata.py` | Table dictionary | Implemented |
| GET | `/v1/metadata/dictionary/tables/{table_name}/columns` | `app/api/metadata.py` | Column dictionary | Implemented |
| GET | `/v1/metadata/lineage` | `app/api/metadata.py` | Lineage edges | Implemented |
| GET | `/v1/metadata/exceptions` | `app/api/metadata.py` | Data exceptions | Implemented |

### 8.2 ppdm-edip API (`ppdm-edip/apps/api`)

| Method | Path | File | Purpose | Status |
|--------|------|------|---------|--------|
| GET | `/health` | `app/main.py` | Health check | Implemented |
| POST | `/v1/auth/login` | `app/api/auth.py` | Username/password → JWT | Implemented (in-memory users) |
| GET | `/v1/admin/contract/tables` | `app/api/admin.py` | PPDM contract tables | Implemented |
| GET | `/v1/admin/contract/tables/{table_name}/columns` | `app/api/admin.py` | Contract columns | Implemented |
| GET | `/v1/admin/dq/scores` | `app/api/admin.py` | DQ scores | Implemented |
| GET | `/v1/admin/exceptions` | `app/api/exceptions` path in admin.py | Warehouse exceptions | Implemented |
| GET | `/v1/admin/lineage` | `app/api/admin.py` | Lineage records | Implemented |
| GET | `/v1/admin/sources` | `app/api/admin.py` | Ingest sources | Implemented |
| POST | `/v1/jobs/run` | `app/api/jobs.py` | Start ingest job | Implemented (admin auth required) |
| GET | `/v1/jobs/runs` | `app/api/jobs.py` | List ingest runs | Implemented |
| GET | `/v1/jobs/runs/{run_id}` | `app/api/jobs.py` | Single run | Implemented |
| GET | `/v1/production/pdens` | `app/api/production.py` | PDEN list | Implemented |
| GET | `/v1/production/pdens/by-id/{pden_id}` | `app/api/production.py` | PDEN by natural key | Implemented |
| GET | `/v1/production/pdens/{pden_id}` | `app/api/production.py` | PDEN detail | Implemented |
| GET | `/v1/production/pdens/{pden_id}/volumes` | `app/api/production.py` | Volume series | Implemented |
| GET | `/v1/production/rollups` | `app/api/production.py` | Rollups by pool/field | Implemented |
| GET | `/v1/production/kpis` | `app/api/production.py` | Production KPIs | Implemented |
| GET | `/v1/marts/production/kpis` | `app/api/marts.py` | Platinum mart KPIs (12+ definitions) | Implemented |
| GET | `/v1/marts/production/coverage` | `app/api/marts.py` | Coverage certification | Implemented |
| GET | `/v1/marts/production/data` | `app/api/marts.py` | Fact production rows | Implemented |
| GET | `/v1/marts/production/export/csv` | `app/api/marts.py` | CSV export | Implemented |
| GET | `/v1/marts/governance/lineage` | `app/api/governance.py` | Governance lineage | Implemented |
| GET | `/v1/metadata/dictionary` | `app/api/metadata.py` | Metadata dictionary | Implemented |
| GET | `/v1/metadata/lineage` | `app/api/metadata.py` | Metadata lineage | Implemented |
| GET | `/v1/metadata/exceptions` | `app/api/metadata.py` | Exception aggregates | Implemented |
| GET | `/v1/spatial/layers` | `app/api/spatial.py` | Spatial layers | Implemented |
| GET | `/v1/spatial/layers/{layer_id}/features` | `app/api/spatial.py` | GeoJSON features | Implemented |
| GET | `/v1/spatial/features/{feature_id}` | `app/api/spatial.py` | Single feature | Implemented |
| GET | `/v1/spatial/search` | `app/api/spatial.py` | Spatial search | Implemented |

### 8.3 Portal proxies

| Method | Path | File | Forwards to | Status |
|--------|------|------|-------------|--------|
| * | `/api/edip/*` | `portal/app/api/edip/[...path]/route.ts` | `EDIP_API_PROXY_TARGET` | Implemented |
| * | `/api/governance/*` | `portal/app/api/governance/[...path]/route.ts` | `GOVERNANCE_API_PROXY_TARGET` | Implemented |

---

## 9. UI Page Map

### 9.1 Portal (primary)

| Route | File | Purpose | Data source | Status |
|-------|------|---------|-------------|--------|
| `/` | `portal/app/page.tsx` | Product landing | Static | Implemented |
| `/platform` | `portal/app/platform/page.tsx` | Platform core info | Static | Implemented (informational) |
| `/edip` | `portal/app/edip/page.tsx` | Workspace overview | Static links | Implemented |
| `/edip/executive` | `portal/app/edip/executive/page.tsx` | Executive KPI dashboard | `/api/edip/v1/marts/production/*` | Implemented |
| `/edip/production` | `portal/app/edip/production/page.tsx` | PDEN list, rollups | `/api/governance/v1/production/*` | Implemented |
| `/edip/production/[pdenId]` | `portal/app/edip/production/[pdenId]/page.tsx` | PDEN volumes | `/api/governance/v1/production/*` | Implemented |
| `/edip/reporting` | `portal/app/edip/reporting/page.tsx` | Reporting dashboard, CSV export | `/api/governance/v1/marts/production/*` | Implemented |
| `/edip/governance` | `portal/app/edip/governance/page.tsx` | DQ, lineage, exceptions, catalog | Both APIs | Implemented |
| `/edip/trd` | `portal/app/edip/trd/page.tsx` | Warehouse runs, DQ, job run | `/api/governance/v1/admin/*`, `/v1/jobs/*` | Implemented |
| `/edip/compliance` | `portal/app/edip/compliance/page.tsx` | Spatial map + CLI text | `/api/governance/v1/spatial/*` | Implemented |
| `/edip/data-products` | `portal/app/edip/data-products/page.tsx` | Metadata table list | `/api/edip/v1/metadata/dictionary/tables` | Implemented |
| `/edip/platform-services` | `portal/app/edip/platform-services/page.tsx` | Services description | Static | Implemented (informational) |
| `/edip/login` | `portal/app/edip/login/page.tsx` | Admin sign-in | `/api/governance/v1/auth/login` | Implemented |

### 9.2 Legacy EDIP web

| Route | File | Purpose | Data source | Status |
|-------|------|---------|-------------|--------|
| `/` | `edip/apps/web/src/app/page.tsx` | Home blurb | Static | Implemented |
| `/dashboard` | `edip/apps/web/src/app/dashboard/page.tsx` | Production dashboard | `/api/edip/v1/marts/production/*` | Implemented (login required) |
| `/login` | `edip/apps/web/src/app/login/page.tsx` | Login | `/api/edip/v1/auth/login` | Implemented |
| `/governance` | `edip/apps/web/src/app/governance/page.tsx` | DQ scores | `/api/edip/v1/governance/dq-scores` | Implemented (login required) |
| `/metadata` | `edip/apps/web/src/app/metadata/page.tsx` | Dictionary + lineage | `/api/edip/v1/metadata/*` | Implemented (login required) |

### 9.3 Legacy ppdm-edip web

| Route | File | Purpose | Data source | Status |
|-------|------|---------|-------------|--------|
| `/` | `ppdm-edip/apps/web/app/page.tsx` | Product links | Static | Implemented |
| `/warehouse` | `ppdm-edip/apps/web/app/warehouse/page.tsx` | Runs, DQ, lineage | Direct governance API URL | Implemented |
| `/spatial` | `ppdm-edip/apps/web/app/spatial/page.tsx` | Map | Direct API | Implemented |
| `/production` | `ppdm-edip/apps/web/app/production/page.tsx` | PDEN explorer | Direct API | Implemented |
| `/production/[pdenId]` | `ppdm-edip/apps/web/app/production/[pdenId]/page.tsx` | PDEN detail | Direct API | Implemented |
| `/reporting` | `ppdm-edip/apps/web/app/reporting/page.tsx` | Reporting | Direct API | Implemented |
| `/admin` | `ppdm-edip/apps/web/app/admin/page.tsx` | Sources, contract, job run | Direct API | Implemented |
| `/login` | `ppdm-edip/apps/web/app/login/page.tsx` | Login | Direct API | Implemented |

---

## 10. Configuration and Runtime

### Root Docker (documented in `README.md`, `docker-compose.yml`)

```bash
docker compose up --build
```

| Service | Host port | Internal port | Notes |
|---------|-----------|---------------|-------|
| `portal` | **3003** | 3000 | Only published frontend |
| `edip_api` | (none) | 8000 | Internal |
| `ppdm_api` | (none) | 8000 | Internal |
| `edip_db`, `ppdm_db` | (none) | 5432 | Internal |
| `edip_redis`, `ppdm_redis` | (none) | 6379 | Internal |
| `edip_web`, `ppdm_web` | (none) | 3000 | Profile `dev-legacy-ui` only |

### Standalone compose files

| File | Published ports (typical) |
|------|---------------------------|
| `edip/infra/docker-compose.yml` | 5432, 6379, 8000, 3000 |
| `ppdm-edip/infra/docker/docker-compose.yml` | 5432, 6379, 8007, 3007 |

### npm commands

| App | Command | Port |
|-----|---------|------|
| Portal | `cd portal && npm install && npm run dev` | 3003 |
| Portal prod | `npm run build && npm start` | 3000 in container |
| EDIP web | `cd edip/apps/web && npm run dev` | 3000 default |
| ppdm-edip web | `cd ppdm-edip/apps/web && npm run dev` | 3007 (`package.json`) |

### Backend start commands

| API | Command |
|-----|---------|
| EDIP | `cd edip/apps/api && pip install -r requirements.txt && uvicorn app.main:app --reload --port 8000` |
| ppdm-edip | `cd ppdm-edip/apps/api && pip install -r requirements.txt && uvicorn app.main:app --reload --port 8007` |
| EDIP (Makefile) | `make api` from `edip/` |

### Other

| Task | Command |
|------|---------|
| EDIP migrations | `cd edip/apps/api && alembic upgrade head` or `make migrate` |
| dbt | `cd edip/dbt/edip_dbt && dbt run` or `make dbt-run` |
| ppdm-edip tests | `cd ppdm-edip/apps/api && pytest tests/ -v` |
| Demo seed (ppdm) | `python ppdm-edip/scripts/seed/seed_demo_data.py` with `DATABASE_URL` set |

---

## 11. Gaps and Unknowns

| Gap | Evidence |
|-----|----------|
| **Missing EDIP DDL file** | `edip/scripts/ddl/` contains only `README.md`; root compose sets `DDL_PATH: scripts/ddl/ppdm_lite11_postgres_ddl.sql` and `RUN_GENERATOR: "0"`. Generator cannot run without file. |
| **ppdm-edip DB init not in root compose** | Root `docker-compose.yml` has no init service/migration mount for `ppdm_db`; API expects `meta`, `ppdm_lite`, Platinum schemas from SQL in `ppdm-edip/infra/docker/migrations/init/`. Fresh `ppdm_db` volume may lack schema unless populated elsewhere. |
| **ppdm-edip standalone compose init mismatch** | `ppdm-edip/infra/docker/docker-compose.yml` `init` service runs `scripts/init/entrypoint.sh` from EDIP context but builds ppdm-edip API image — path may not exist in ppdm-edip build context. |
| **Incomplete `ldv_platform` package** | `run_compliance.py` imports `ldv_platform.core`; `domain_products/*` imports `ldv_platform.domain_products.get_domain_tables` — no `core/` or `domain_products/__init__.py` in repo. CLI likely fails on import. |
| **Missing sample schema for compliance CLI** | `run_compliance.py` references `ldv_platform/examples/sample_client_schema.json` — not found in repo listing. |
| **Two backends, overlapping domains** | Both APIs expose production/marts/governance/metadata with different schemas and auth models; Portal calls both. Behavior when one DB is empty is partial UI. |
| **Redis configured but unused in route code** | `REDIS_URL` in compose and EDIP settings; no cache usage found in inspected API handlers. |
| **No ORM entity models** | `Base = declarative_base()` exists but business logic uses raw SQL; no centralized Pydantic schema package beyond inline models. |
| **Legacy frontends duplicate Portal** | `edip/apps/web` and `ppdm-edip/apps/web` remain with overlapping features and different auth/URL patterns. |
| **EDIP executive vs legacy dashboard** | Portal `/edip/executive` does not require login; legacy `/dashboard` redirects to login without token. |
| **Auth payload mismatch** | EDIP login uses `email`; ppdm-edip login uses `username`; Portal login uses governance API (username). Token stored as shared `edip_token` for both proxy paths. |
| **`docs/` at repo root** | Directory empty. |
| **`ppdm-edip/packages/shared/`** | README only; no shared code consumed by apps. |
| **API errors at runtime** | Several marts/production SQL queries fail if Platinum/fact tables not created (observed 500s when DB not fully migrated). |
| **No project-source TODO/FIXME** | No TODO/FIXME in application source (excluding `node_modules`). |
| **dbt disabled in root compose** | `RUN_DBT: "0"` in root `edip_init`; marts tables may not exist unless dbt run manually or via `edip/infra` compose (`RUN_DBT: "1"`). |
| **Full PPDM Lite DDL** | Documented as gap in `ppdm-edip/docs/SPEC_ALIGNMENT.md`; repo has subset SQL migrations + one DDL file under `ppdm-edip/scripts/init/`. |

---

*Document reflects repository state at extraction time. File paths are relative to repo root `PETRO_Reporting_interface/`.*
