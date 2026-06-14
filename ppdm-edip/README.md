# EDIP — Energy Decision Intelligence Platform

PPDM Lite 1.1 consumption contract platform: Bronze → Silver → Gold (PPDM Lite) with three products:

- **Product A — Warehouse Core**: Publisher, DQ scoring (60/40 + essential cap), lineage, exceptions
- **Product B — Spatial Asset Explorer**: GIS browsing (PostGIS, GeoJSON)
- **Product C — Production & Asset Intelligence**: PDEN explorer, volumes, rollups, KPIs

## Architecture

```
Upstream Master Systems → Bronze (raw) → Silver (conformed) → ppdm_lite (Gold)
                                                                    ↓
                                    Warehouse Core | Spatial Explorer | Production Intelligence
```

## Tech Stack

- **Backend**: FastAPI, SQLAlchemy, Alembic, Pydantic
- **DB**: PostgreSQL + PostGIS
- **Frontend**: Next.js, TypeScript, Tailwind, Leaflet/Mapbox
- **Auth**: JWT + RBAC

## Quick Start

**Option A — Docker (DB only for local dev)**

```bash
cd ppdm-edip/infra/docker
docker compose up -d db
# DB runs on localhost:5432 (edip/edip_secret/edip). Init scripts run on first start (schemas + meta + ppdm_lite + contract seed + essential_policy).
```

**Option B — Full stack in Docker**

```bash
cd ppdm-edip/infra/docker
docker compose up -d
# API: http://localhost:8007, Web: http://localhost:3007
```

**Option C — Local API + Web (no Docker for app)**

```bash
# Start DB (Option A), then:
cd ppdm-edip/apps/api && pip install -r requirements.txt && uvicorn app.main:app --reload --port 8007
cd ppdm-edip/apps/web && npm install && npm run dev
```

**Demo data (optional, for UI with sample PDENs/volumes)**

```bash
cd ppdm-edip
set DATABASE_URL=postgresql://edip:edip_secret@localhost:5432/edip   # Windows
# export DATABASE_URL=postgresql://edip:edip_secret@localhost:5432/edip   # Linux/Mac
pip install psycopg2-binary
python scripts/seed/seed_demo_data.py
```

- API: http://localhost:8007
- Web: http://localhost:3007

## Auth (JWT + RBAC)

- **Login:** POST `/v1/auth/login` with `{"username": "...", "password": "..."}`. Returns `{ "access_token": "...", "token_type": "bearer" }`.
- **Demo users:** `admin` / `change-me` (admin role), `viewer` / `viewer` (viewer role).
- **Protected:** POST `/v1/jobs/run` requires a valid Bearer token with role `admin`.
- **Public read:** Production, Spatial, Reporting, Warehouse, and Admin browse endpoints work without signing in.
- **Web:** Optional sign-in at `/login` for running warehouse jobs (`admin` / `change-me`).

## Testing

```bash
cd ppdm-edip/apps/api
pip install -r requirements.txt
pytest tests/ -v
```
Without a running database, two tests are skipped (admin with token, production by-id). With DB up, all 7 run.

## Repo Structure

```
ppdm-edip/
  apps/
    api/          FastAPI backend
    web/          Next.js frontend
  packages/
    shared/       Shared types and constants
  infra/
    docker/       Docker Compose, init DDL
  scripts/
    seed/         Contract seeding, demo data
    dq/           DQ score computation SQL
  docs/           ADRs, PPDM notes
  data/           Optional local dev data
```

## Data Quality (100-point)

- **Essential tranche**: 60 points (PKs, required IDs, core measures)
- **Optional tranche**: 40 points (remarks, aliases)
- **Rule**: If essential coverage < 90%, score capped at 59, not certified.
