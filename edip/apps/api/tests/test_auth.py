"""Auth and API tests."""
import pytest
from httpx import ASGITransport, AsyncClient
from app.main import app


@pytest.fixture
def client():
    return AsyncClient(
        transport=ASGITransport(app=app),
        base_url="http://test",
    )


@pytest.mark.asyncio
async def test_health(client):
    r = await client.get("/health")
    assert r.status_code == 200
    assert r.json() == {"status": "ok"}


@pytest.mark.asyncio
async def test_login_fail(client):
    r = await client.post(
        "/v1/auth/login",
        json={"email": "nobody@test.com", "password": "wrong"},
    )
    assert r.status_code == 401


@pytest.mark.asyncio
async def test_me_unauthorized(client):
    r = await client.get("/v1/auth/me")
    assert r.status_code == 401  # no auth header
