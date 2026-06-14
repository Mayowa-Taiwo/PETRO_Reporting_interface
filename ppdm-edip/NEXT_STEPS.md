# EDIP — Next Steps

Summary of where the project stands and suggested next steps (continuation from current state).  
**Spec reference:** Main build prompt (PPDM Lite 1.1 consumption contract + full DDL + 60/40 DQ).  
**Full alignment:** See **docs/SPEC_ALIGNMENT.md**. **Full DDL:** See **docs/FULL_PPDM_LITE_DDL.md**.

## Current state

- **Done**: Home, Warehouse Core (runs + DQ table), Spatial Explorer (layers + map), Production (list, KPIs, rollups, PDEN detail with volumes), Admin (sources, contract tables, run job). API: admin (contract, DQ, exceptions, lineage, sources), jobs (run, list runs, get run), production, spatial. DB init, migrations, seed scripts, DQ computation SQL script.
- **README claims but not implemented**: **Auth (JWT + RBAC)** — no login or role checks anywhere.
- **Main prompt Step 1:** Full PPDM Lite 1.1 DDL file **edip_ppdm_lite11_postgres_ddl.sql** is **not in repo**. Current migrations create only an MVP subset of ppdm_lite tables. See **docs/FULL_PPDM_LITE_DDL.md**.

## Prioritized next steps

### 1. Warehouse Core: lineage & exceptions in the UI (high impact, low effort)

The API already exposes `GET /v1/admin/lineage` and `GET /v1/admin/exceptions`. The Warehouse page only shows runs and DQ scores. Add two sections (or tabs) on the Warehouse page to display lineage and exceptions, with optional filters (e.g. run, table).

### 2. Warehouse: “latest DQ score per table” (high impact, low effort)

DQ scores API returns multiple rows per table (one per run). The Warehouse table is more useful if it shows the **latest score per target table** (e.g. by `computed_at` DESC, one row per `target_table`). Either:

- Add a query param or endpoint like `GET /v1/admin/dq/scores?latest_per_table=true`, or  
- Deduplicate in the frontend (e.g. take first occurrence per `target_table` when response is ordered by `computed_at DESC`).

### 3. Authentication (JWT + RBAC) (high impact, medium effort)

README lists “JWT + RBAC”. To align with that:

- Add login (e.g. POST /auth/login with user/password or API key), issue JWT.
- Protect API routes: verify JWT and optionally check roles (e.g. admin-only for `/v1/admin/*` and `/v1/jobs/run`).
- Optionally add a simple login page and store token in the frontend (e.g. localStorage or cookie) and send in `Authorization` header.

### 4. Production detail: robust PDEN lookup (medium impact, low effort)

Detail page hardcodes `pden_type=WELL` and `pden_source=DEMO`. If data uses other type/source, the detail page can 404. Options:

- Pass `pden_type` and `pden_source` in the list (e.g. query params or in the link), or  
- Add an API that resolves PDEN by `pden_id` only (e.g. first match or primary key) and use that on the detail page.

### 5. Run job: real DQ computation (medium impact, medium effort)

The job in `apps/api/app/api/jobs.py` currently inserts a **placeholder** DQ row (score 100, certified). The real 60/40 + essential-cap logic lives in `scripts/dq/compute_dq_scores.sql`. Wire that in:

- After publishing from silver to ppdm_lite, for each target table call the DQ computation (or equivalent in Python) and insert/update `meta.dq_table_score` instead of the placeholder.

### 6. Bronze → Silver → Gold flow (medium impact, higher effort)

Job today copies from `silver.pden_staging WHERE run_id = :run_id`. Typically silver is populated by a prior bronze → silver step. Either:

- Document that silver must be pre-populated (e.g. by external ETL or manual load), or  
- Add a minimal bronze → silver step (e.g. read from bronze landing, validate, write to silver) so a single “Run” does full pipeline for demo.

### 7. Spatial: empty state and UX (low impact, low effort)

When there are no layers or the API is down, show a clear message or placeholder in the map area instead of an empty tile.

### 8. Tests (ongoing)

- Add API tests (e.g. pytest for FastAPI) for main endpoints (health, admin, jobs, production, spatial).
- Optionally add frontend tests (e.g. Playwright or React Testing Library) for critical flows.

---

**Suggested order to continue from here:**  
Do **(1)** and **(2)** on the Warehouse page first (quick wins), then **(3)** Auth, then **(5)** real DQ in the job and **(4)** PDEN lookup as needed.

---

## From the main build prompt (spec-driven gaps)

To fully meet the main prompt, also consider:

- **Full PPDM Lite DDL:** Obtain and run **edip_ppdm_lite11_postgres_ddl.sql** (Step 1). See **docs/FULL_PPDM_LITE_DDL.md**.
- **Contract catalog from information_schema:** After full DDL, seed L_PPDM_TABLE and L_PPDM_COLUMN from `information_schema` for schema `ppdm_lite` (Step 3).
- **Product A — Warehouse Core:** Sources **CRUD** (not just list), **Mapping registry CRUD** (UI + API), **Contract coverage dashboard** (per-table %).
- **Pipeline:** Wire real 60/40 DQ for **all** ppdm_lite tables after publish; optionally add Bronze→Silver step so one “Run” does full pipeline (Steps 4–5).
- **MVP acceptance:** Full ppdm_lite from DDL + one run Bronze→Silver→Publish + DQ for all tables — see **docs/SPEC_ALIGNMENT.md** for current vs target.
