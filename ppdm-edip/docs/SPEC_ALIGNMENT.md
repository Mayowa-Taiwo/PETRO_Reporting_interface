# EDIP — Spec alignment to main prompt

This document maps the **main prompt** (EDIP build spec: PPDM Lite 1.1 consumption contract + full DDL + 60/40 DQ certification) to the current repo state and gaps.

---

## Step 1 — Apply full PPDM Lite DDL (consumption contract)

| Requirement | Status | Notes |
|-------------|--------|--------|
| Execute **edip_ppdm_lite11_postgres_ddl.sql** | **Gap** | File **not in repo**. Spec says this creates schema `ppdm_lite` and **all** PPDM Lite 1.1 tables. |
| Do not edit ppdm_lite from UI; publish-only via jobs | OK | No UI writes to ppdm_lite. |

**Current state:** Migrations in `infra/docker/migrations/init/` create only an **MVP subset** of ppdm_lite:

- `03_ppdm_lite_meta.sql`: `l_ppdm_table`, `l_ppdm_column`, `l_ppdm_origin`, `l_ppdm_exception`
- `04_ppdm_lite_production_spatial.sql`: `l_pden`, `l_pden_vol_summary`, `l_sp_component`, `edip_feature_geom`

So we have **subset DDL**, not the **full PPDM Lite 1.1** consumption contract. See **docs/FULL_PPDM_LITE_DDL.md** for where to place and how to run the full DDL file when you have it.

---

## Step 2 — Platform operational tables (meta + policy)

| Table | Status | Location |
|-------|--------|----------|
| meta.ingest_source | OK | `02_meta.sql` |
| meta.ingest_run | OK | `02_meta.sql` |
| meta.mapping_registry | OK | `02_meta.sql` |
| meta.essential_policy | OK | `02_meta.sql` |
| meta.dq_table_score | OK | `02_meta.sql` |

All meta tables exist. Policy seed: `07_essential_policy.sql`.

---

## Step 3 — Auto-contract catalog (L_PPDM_TABLE, L_PPDM_COLUMN)

| Requirement | Status | Notes |
|-------------|--------|--------|
| Populate from information_schema OR PPDM PDF parsing | Partial | Manual seed in `06_contract_seed.sql` for **current MVP tables only**. |
| Prefer query Postgres information_schema for ppdm_lite | Not done | No script yet that auto-builds L_PPDM_TABLE / L_PPDM_COLUMN from `information_schema.columns` for schema `ppdm_lite`. |

**Recommendation:** When full DDL is applied, add a script that seeds the contract from `information_schema` so **all** ppdm_lite tables/columns are in the catalog for 60/40 DQ coverage.

---

## Step 4 — Two-tranche DQ certification (100 points, essential cap)

| Requirement | Status | Notes |
|-------------|--------|--------|
| Essential 60 pts, optional 40 pts, essential &lt; 90% → cap at 59, certified_ind | Logic in script | `scripts/dq/compute_dq_scores.sql` implements 60/40 + essential cap. |
| Column “accounted for” = mapped + produced + no critical exception | Partial | DQ script uses mapping_registry + lineage (l_ppdm_origin). Exceptions can be integrated. |
| essential_policy + fallback heuristics | Partial | Script uses meta.essential_policy; fallback heuristics can be added. |
| Compute DQ for **all** ppdm_lite tables after publish | Partial | Job currently writes a **placeholder** DQ row for one table. Need to run real DQ for every target table. |

---

## Step 5 — Ingestion + publish pipeline (Bronze → Silver → ppdm_lite)

| Requirement | Status | Notes |
|-------------|--------|--------|
| Bronze: land raw, append-only, log ingest_run | Partial | Bronze schema + ingest_file exist; job does not read from bronze. |
| Silver: standardize, conform, validate, exceptions | Partial | silver.pden_staging / pden_vol_staging exist. Job reads from silver and publishes. No separate bronze→silver step in job. |
| Publish: mapping_registry, full_refresh/incremental, lineage, exceptions | Partial | Job writes to l_pden, l_ppdm_origin, l_ppdm_exception; single table. Not driven by full mapping_registry for all tables. |
| After publish, compute DQ for **all** ppdm_lite tables → meta.dq_table_score | Partial | Placeholder only; need to call compute_dq_scores (or equivalent) per table. |

---

## Step 6 — Three products (UI + API)

### Product A — Warehouse Core

| Item | Status | Notes |
|------|--------|--------|
| Sources CRUD | Gap | Only list (GET). No create/update/delete. |
| Mapping registry CRUD | Gap | No UI or API for mapping_registry. |
| Run job + run history | OK | Admin: run button; GET /v1/jobs/runs, /v1/jobs/runs/{run_id}. |
| Contract coverage dashboard (per table %) | Gap | Not in UI. |
| DQ certification dashboard (per table) | OK | Warehouse page: DQ scores, latest per table. |
| Exceptions explorer | OK | Warehouse: exceptions section. |
| Lineage explorer | OK | Warehouse: lineage section. |
| API paths | OK | Under /v1/admin/* and /v1/jobs/* (spec used /v1/contract, /v1/runs; we use /v1/admin/contract, /v1/jobs/runs). |

### Product B — Spatial Asset Explorer

| Item | Status |
|------|--------|
| GET /v1/spatial/layers | OK |
| GET /v1/spatial/layers/{layer}/features (GeoJSON) | OK |
| Map, layer toggles, feature detail | OK (basic). Cross-links to assets/production: optional. |

### Product C — Production & Asset Intelligence

| Item | Status |
|------|--------|
| GET /v1/production/pdens, pdens/{id}, volumes, rollups | OK |
| PDEN explorer, volume trends, rollups, KPIs | OK |
| Certification badges from meta.dq_table_score | Optional; not on production UI yet. |

---

## MVP acceptance (from main prompt)

| Criterion | Status |
|-----------|--------|
| Full ppdm_lite schema from DDL file | **Gap** — MVP subset only; full DDL file not in repo. |
| One ingest_run executes Bronze→Silver→Publish | Partial — Publish from Silver→ppdm_lite; no Bronze→Silver in same run. |
| DQ computed for **all** ppdm_lite tables with 60/40 + essential cap | Partial — Script exists; job uses placeholder. |
| Exceptions and lineage visible in UI | OK |
| At least one spatial layer + one production dashboard | OK |

---

## Stack and repo structure

- Backend (FastAPI + SQLAlchemy + Alembic + Pydantic), DB (PostgreSQL + PostGIS), Frontend (Next.js + TS + Tailwind + Leaflet), Auth (JWT + RBAC), monorepo layout: as per spec. **Auth not implemented yet.**

---

## Summary: what “full DDL tables” means

The main prompt **Step 1** requires executing **edip_ppdm_lite11_postgres_ddl.sql** to create the **full** PPDM Lite 1.1 consumption schema. Right now:

- That file is **not** in the repo.
- Only an **MVP subset** of ppdm_lite tables is created by init migrations.

So “full DDL tables” = once you have the official (or organization-specific) **full** PPDM Lite 1.1 Postgres DDL file, it should be run to create the complete consumption contract; then the contract catalog (Step 3) and DQ (Step 4) should cover **all** those tables. Until then, the repo remains on the MVP subset with partial DQ and pipeline coverage.

See **docs/FULL_PPDM_LITE_DDL.md** for where to put the DDL file and how to run it.
