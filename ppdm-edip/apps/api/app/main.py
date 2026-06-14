from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.api import admin, auth, governance, jobs, marts, metadata, production, spatial

app = FastAPI(
    title="EDIP API",
    description="Energy Decision Intelligence Platform — PPDM Lite 1.1 consumption",
    version="0.1.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:3003",
        "http://127.0.0.1:3003",
        "http://localhost:3007",
        "http://127.0.0.1:3007",
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router, prefix="/v1/auth", tags=["Auth"])
app.include_router(admin.router, prefix="/v1/admin", tags=["Admin"])
app.include_router(jobs.router, prefix="/v1/jobs", tags=["Jobs"])
app.include_router(production.router, prefix="/v1/production", tags=["Production"])
app.include_router(marts.router, prefix="/v1/marts", tags=["Marts"])
app.include_router(governance.router, prefix="/v1/marts/governance", tags=["Governance"])
app.include_router(metadata.router, prefix="/v1/metadata", tags=["Metadata"])
app.include_router(spatial.router, prefix="/v1/spatial", tags=["Spatial"])


@app.get("/health")
def health():
    return {"status": "ok"}
