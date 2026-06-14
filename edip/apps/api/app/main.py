from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.api import auth, marts, governance, metadata

app = FastAPI(
    title="EDIP API",
    description="Oil & Gas Executive BI Reporting Suite",
    version="0.1.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:3000",
        "http://127.0.0.1:3000",
        "http://localhost:3001",
        "http://127.0.0.1:3001",
    ],
    allow_origin_regex=r"https?://(localhost|127\.0\.0\.1|\[::1\])(:\d+)?",
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router, prefix="/v1/auth", tags=["Auth"])
app.include_router(marts.router, prefix="/v1/marts", tags=["Marts"])
app.include_router(governance.router, prefix="/v1/governance", tags=["Governance"])
app.include_router(metadata.router, prefix="/v1/metadata", tags=["Metadata"])


@app.get("/health")
def health():
    return {"status": "ok"}
