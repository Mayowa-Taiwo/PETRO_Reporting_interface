# PETRO Reporting Interface

The PETRO Reporting Interface is a unified product shell for EDIP reporting, petroleum production intelligence, governance, TRD warehouse management, and compliance workflows.

**Main entry point:** [http://localhost:3003](http://localhost:3003)

There is one user-facing frontend. EDIP workspace routes and governance/TRD capabilities live under the Portal — not on separate host ports.

## Product structure

| Area | Route | Description |
|------|-------|-------------|
| Portal | `/` | Main landing page and product shell |
| EDIP Workspace | `/edip` | Primary executive intelligence and reporting workspace |
| Executive Intelligence | `/edip/executive` | BI, marts, and executive reporting |
| Production | `/edip/production` | Production monitoring and petroleum reporting |
| Reporting | `/edip/reporting` | Reporting workflows and outputs |
| Governance | `/edip/governance` | DQ certification, lineage, exceptions, contract catalog |
| TRD Warehouse | `/edip/trd` | TRD warehouse, ingest runs, and stewardship jobs |
| Compliance | `/edip/compliance` | Spatial assets and regulatory / schema compliance |
| Data Products | `/edip/data-products` | Mart and metadata dictionary |
| Platform Services | `/edip/platform-services` | How LDV Platform Core supports EDIP |
| LDV Platform Core | `/platform` | Python core services (no separate web app) |

## Architecture

```
PETRO Reporting Interface (Portal :3003)
├── EDIP Workspace (/edip/*)
│   ├── Executive, Production, Reporting  → EDIP API (proxied /api/edip)
│   └── Governance, TRD, Compliance       → Governance API (proxied /api/governance)
└── LDV Platform Core (Python, no web UI)
```

The `ppdm-edip/` folder remains in the repo as the **governance/TRD backend** implementation. It is not a separate product module in the UI.

## Run locally

From the repo root:

```bash
docker compose up --build
```

Then open:

```bash
http://localhost:3003
```

Do **not** open separate frontend ports (3000, 3001, 3007) for normal product use.

### Optional: legacy standalone UIs (development only)

```bash
docker compose --profile dev-legacy-ui up --build
```

This starts internal EDIP and governance web containers without publishing them to the host. Use the Portal for all user-facing work.

### Run Portal only (local dev)

```bash
cd portal
npm install
npm run dev
```

Requires EDIP and Governance APIs reachable (via Docker or local uvicorn). Set in `.env.local`:

```
EDIP_API_PROXY_TARGET=http://localhost:8000
GOVERNANCE_API_PROXY_TARGET=http://localhost:8007
```

## Folders

| Folder | Role |
|--------|------|
| `portal/` | **Product shell** — only user-facing Next.js app |
| `edip/` | EDIP API, dbt, init, legacy web (dev) |
| `ppdm-edip/` | Governance / TRD **backend** (API + legacy web for dev) |
| `ldv_platform/` | Python core: compliance CLI, domain logic |
| `docs/` | Shared documentation |

## Sign-in

Browsing the workspace is open. Running TRD ingest jobs requires admin sign-in at `/edip/login` (demo: `admin` / `change-me`).
