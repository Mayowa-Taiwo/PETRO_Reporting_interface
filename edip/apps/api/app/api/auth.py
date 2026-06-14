from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncSession

from app.auth import create_access_token, get_current_user, verify_password
from app.database import get_db

router = APIRouter()


class LoginRequest(BaseModel):
    email: str
    password: str


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"


@router.post("/login", response_model=TokenResponse)
async def login(body: LoginRequest, db: AsyncSession = Depends(get_db)):
    r = await db.execute(
        text("""
            SELECT u.user_id, u.tenant_id, u.hashed_password,
                   (SELECT array_agg(ur.role_id) FROM security.user_roles ur WHERE ur.user_id = u.user_id) AS roles
            FROM security.users u
            WHERE u.email = :email AND u.is_active = true
        """),
        {"email": body.email},
    )
    row = r.fetchone()
    if not row:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid credentials")
    if not verify_password(body.password, row[2]):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid credentials")
    roles = list(row[3]) if row[3] else []
    token = create_access_token(
        data={"sub": str(row[0]), "tenant_id": str(row[1]), "roles": roles}
    )
    return TokenResponse(access_token=token)


@router.get("/me")
async def me(user: dict = Depends(get_current_user)):
    return user
