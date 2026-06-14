"""API tests: health, auth login, and protected routes (admin/jobs)."""
import pytest
from fastapi.testclient import TestClient

from app.main import app


@pytest.fixture
def client():
    return TestClient(app)


def test_health(client: TestClient):
    r = client.get("/health")
    assert r.status_code == 200
    assert r.json() == {"status": "ok"}


def test_login_success(client: TestClient):
    r = client.post(
        "/v1/auth/login",
        json={"username": "admin", "password": "change-me"},
    )
    assert r.status_code == 200
    data = r.json()
    assert "access_token" in data
    assert data.get("token_type") == "bearer"


def test_login_invalid(client: TestClient):
    r = client.post(
        "/v1/auth/login",
        json={"username": "admin", "password": "wrong"},
    )
    assert r.status_code == 401
    assert "detail" in r.json()


def test_admin_without_token_is_public(client: TestClient):
    try:
        r = client.get("/v1/admin/sources")
    except (OSError, ConnectionError) as e:
        pytest.skip(f"Database not running: {e}")
    assert r.status_code == 200
    assert isinstance(r.json(), list)


def test_admin_with_token(client: TestClient):
    login = client.post(
        "/v1/auth/login",
        json={"username": "admin", "password": "change-me"},
    )
    assert login.status_code == 200
    token = login.json()["access_token"]
    try:
        r = client.get(
            "/v1/admin/sources",
            headers={"Authorization": f"Bearer {token}"},
        )
    except (OSError, ConnectionError) as e:
        pytest.skip(f"Database not running: {e}")
    # 200 with list (may be empty if DB has no sources)
    assert r.status_code == 200
    assert isinstance(r.json(), list)


def test_jobs_run_without_token_returns_401(client: TestClient):
    r = client.post(
        "/v1/jobs/run",
        json={"source_id": "00000000-0000-0000-0000-000000000000", "mode": "full_refresh"},
    )
    assert r.status_code == 401


def test_production_pdens_by_id_public(client: TestClient):
    """Production by-id is public (no auth required)."""
    try:
        r = client.get("/v1/production/pdens/by-id/nonexistent-id")
    except (OSError, ConnectionError) as e:
        pytest.skip(f"Database not running: {e}")
    # 200 with detail "PDEN not found" or 404 depending on impl
    assert r.status_code in (200, 404)
    if r.status_code == 200:
        assert "detail" in r.json() or "pden_id" in r.json()
