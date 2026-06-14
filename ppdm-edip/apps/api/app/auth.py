"""JWT + RBAC: token creation/verification and role-based dependencies."""
from datetime import datetime, timedelta, timezone
from typing import Annotated

from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from jose import JWTError, jwt
from passlib.context import CryptContext

from app.config import settings

pwd_context = CryptContext(schemes=["pbkdf2_sha256", "bcrypt"], deprecated="auto")
security = HTTPBearer(auto_error=False)

# In-memory user store (MVP). Replace with DB (e.g. meta.app_user) later.
# Lazy-init to avoid bcrypt at import (e.g. test collection).
_DEMO_USERS: dict | None = None


def _get_demo_users() -> dict:
    global _DEMO_USERS
    if _DEMO_USERS is None:
        _DEMO_USERS = {
            "admin": {
                "password_hash": pwd_context.hash("change-me"),
                "roles": ["admin"],
            },
            "viewer": {
                "password_hash": pwd_context.hash("viewer"),
                "roles": ["viewer"],
            },
        }
    return _DEMO_USERS


def verify_password(plain: str, hashed: str) -> bool:
    return pwd_context.verify(plain, hashed)


def create_access_token(subject: str, roles: list[str]) -> str:
    expire = datetime.now(timezone.utc) + timedelta(minutes=settings.access_token_expire_minutes)
    payload = {"sub": subject, "roles": roles, "exp": expire}
    return jwt.encode(payload, settings.secret_key, algorithm=settings.algorithm)


def decode_token(token: str) -> dict:
    try:
        return jwt.decode(token, settings.secret_key, algorithms=[settings.algorithm])
    except JWTError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired token",
            headers={"WWW-Authenticate": "Bearer"},
        )


async def get_current_user_optional(
    credentials: Annotated[HTTPAuthorizationCredentials | None, Depends(security)],
) -> dict | None:
    if not credentials or credentials.scheme != "Bearer":
        return None
    try:
        payload = jwt.decode(credentials.credentials, settings.secret_key, algorithms=[settings.algorithm])
    except JWTError:
        return None
    sub = payload.get("sub")
    roles = payload.get("roles") or []
    if not sub:
        return None
    return {"username": sub, "roles": roles}


async def get_current_user(
    user: Annotated[dict | None, Depends(get_current_user_optional)],
) -> dict:
    if user is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Not authenticated",
            headers={"WWW-Authenticate": "Bearer"},
        )
    return user


def require_roles(allowed_roles: list[str]):
    """Dependency that requires the current user to have at least one of allowed_roles."""

    async def _check(
        user: Annotated[dict, Depends(get_current_user)],
    ) -> dict:
        if not allowed_roles:
            return user
        user_roles = user.get("roles") or []
        if not any(r in allowed_roles for r in user_roles):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Insufficient permissions",
            )
        return user

    return _check


def authenticate_user(username: str, password: str) -> dict | None:
    """Return user dict with username and roles if credentials are valid."""
    u = _get_demo_users().get(username)
    if not u or not verify_password(password, u["password_hash"]):
        return None
    return {"username": username, "roles": u["roles"]}
