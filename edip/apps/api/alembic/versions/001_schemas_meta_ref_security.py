"""schemas meta ref security

Revision ID: 001
Revises:
Create Date: 2025-01-01 00:00:00

"""
from typing import Sequence, Union
from alembic import op
import sqlalchemy as sa

revision: str = "001"
down_revision: Union[str, None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.execute("CREATE SCHEMA IF NOT EXISTS meta")
    op.execute("CREATE SCHEMA IF NOT EXISTS ref")
    op.execute("CREATE SCHEMA IF NOT EXISTS security")
    for name in [
        "marts_shared", "marts_production", "marts_asset", "marts_reserves",
        "marts_contract", "marts_finance", "marts_facility", "marts_spatial",
        "marts_governance", "marts_jv", "marts_regulatory",
    ]:
        op.execute(f"CREATE SCHEMA IF NOT EXISTS {name}")

    # meta
    op.create_table(
        "mart_registry",
        sa.Column("mart_id", sa.String(60), primary_key=True),
        sa.Column("mart_name", sa.String(120), nullable=False),
        sa.Column("schema_name", sa.String(60), nullable=False),
        sa.Column("description", sa.Text()),
        sa.Column("is_enabled", sa.Boolean(), server_default="true"),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.text("now()")),
        schema="meta",
    )
    op.create_table(
        "mart_contract_item",
        sa.Column("contract_item_id", sa.Integer(), autoincrement=True, primary_key=True),
        sa.Column("mart_id", sa.String(60), sa.ForeignKey("meta.mart_registry.mart_id"), nullable=False),
        sa.Column("source_schema", sa.String(60), nullable=False),
        sa.Column("source_table", sa.String(60), nullable=False),
        sa.Column("source_column", sa.String(60), nullable=False),
        sa.Column("points", sa.Integer(), nullable=False),
        sa.Column("is_essential", sa.Boolean(), nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.text("now()")),
        sa.UniqueConstraint("mart_id", "source_schema", "source_table", "source_column", name="uq_mart_contract_item"),
        schema="meta",
    )
    op.create_table(
        "mart_run",
        sa.Column("run_id", sa.Uuid(), primary_key=True),
        sa.Column("mart_id", sa.String(60), nullable=False),
        sa.Column("started_at", sa.DateTime(timezone=True), server_default=sa.text("now()")),
        sa.Column("finished_at", sa.DateTime(timezone=True)),
        sa.Column("status", sa.String(20), nullable=False),
        sa.Column("rows_affected", sa.Integer()),
        schema="meta",
    )
    op.create_table(
        "data_exception",
        sa.Column("exception_id", sa.BigInteger(), autoincrement=True, primary_key=True),
        sa.Column("run_id", sa.Uuid()),
        sa.Column("table_name", sa.String(60), nullable=False),
        sa.Column("column_name", sa.String(60)),
        sa.Column("exception_type", sa.String(40)),
        sa.Column("error_message", sa.Text()),
        sa.Column("exception_date", sa.DateTime(timezone=True), server_default=sa.text("now()")),
        schema="meta",
    )
    op.create_table(
        "lineage_edge",
        sa.Column("edge_id", sa.BigInteger(), autoincrement=True, primary_key=True),
        sa.Column("source_schema", sa.String(60), nullable=False),
        sa.Column("source_table", sa.String(60), nullable=False),
        sa.Column("source_column", sa.String(60)),
        sa.Column("target_schema", sa.String(60), nullable=False),
        sa.Column("target_table", sa.String(60), nullable=False),
        sa.Column("target_column", sa.String(60)),
        sa.Column("run_id", sa.Uuid()),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.text("now()")),
        schema="meta",
    )

    # ref
    op.create_table(
        "uom_conversion",
        sa.Column("from_uom", sa.String(20), primary_key=True),
        sa.Column("to_uom", sa.String(20), primary_key=True),
        sa.Column("conversion_factor", sa.Numeric(18, 8), nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.text("now()")),
        schema="ref",
    )
    op.create_table(
        "fx_rates",
        sa.Column("from_currency", sa.String(6), primary_key=True),
        sa.Column("to_currency", sa.String(6), primary_key=True),
        sa.Column("rate_date", sa.Date(), primary_key=True),
        sa.Column("rate", sa.Numeric(18, 8), nullable=False),
        schema="ref",
    )
    op.create_table(
        "domain_values",
        sa.Column("domain_id", sa.String(60), primary_key=True),
        sa.Column("value_code", sa.String(60), primary_key=True),
        sa.Column("value_name", sa.String(120)),
        sa.Column("sort_order", sa.Integer()),
        schema="ref",
    )

    # security
    op.create_table(
        "tenants",
        sa.Column("tenant_id", sa.Uuid(), primary_key=True),
        sa.Column("tenant_name", sa.String(120), nullable=False),
        sa.Column("is_active", sa.Boolean(), server_default="true"),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.text("now()")),
        schema="security",
    )
    op.create_table(
        "users",
        sa.Column("user_id", sa.Uuid(), primary_key=True),
        sa.Column("tenant_id", sa.Uuid(), sa.ForeignKey("security.tenants.tenant_id"), nullable=False),
        sa.Column("email", sa.String(255), nullable=False),
        sa.Column("hashed_password", sa.String(255), nullable=False),
        sa.Column("full_name", sa.String(120)),
        sa.Column("is_active", sa.Boolean(), server_default="true"),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.text("now()")),
        schema="security",
    )
    op.create_table(
        "roles",
        sa.Column("role_id", sa.String(40), primary_key=True),
        sa.Column("role_name", sa.String(60), nullable=False),
        schema="security",
    )
    op.create_table(
        "user_roles",
        sa.Column("user_id", sa.Uuid(), sa.ForeignKey("security.users.user_id"), primary_key=True),
        sa.Column("role_id", sa.String(40), sa.ForeignKey("security.roles.role_id"), primary_key=True),
        schema="security",
    )
    op.create_table(
        "api_keys",
        sa.Column("key_id", sa.Uuid(), primary_key=True),
        sa.Column("tenant_id", sa.Uuid(), sa.ForeignKey("security.tenants.tenant_id"), nullable=False),
        sa.Column("key_hash", sa.String(255), nullable=False),
        sa.Column("name", sa.String(60)),
        sa.Column("role_id", sa.String(40), sa.ForeignKey("security.roles.role_id")),
        sa.Column("expires_at", sa.DateTime(timezone=True)),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.text("now()")),
        schema="security",
    )


def downgrade() -> None:
    op.drop_table("api_keys", schema="security")
    op.drop_table("user_roles", schema="security")
    op.drop_table("roles", schema="security")
    op.drop_table("users", schema="security")
    op.drop_table("tenants", schema="security")
    op.drop_table("domain_values", schema="ref")
    op.drop_table("fx_rates", schema="ref")
    op.drop_table("uom_conversion", schema="ref")
    op.drop_table("lineage_edge", schema="meta")
    op.drop_table("data_exception", schema="meta")
    op.drop_table("mart_run", schema="meta")
    op.drop_table("mart_contract_item", schema="meta")
    op.drop_table("mart_registry", schema="meta")
    for name in [
        "marts_regulatory", "marts_jv", "marts_governance", "marts_spatial",
        "marts_facility", "marts_finance", "marts_contract", "marts_reserves",
        "marts_asset", "marts_production", "marts_shared",
    ]:
        op.execute(f"DROP SCHEMA IF EXISTS {name} CASCADE")
    op.execute("DROP SCHEMA IF EXISTS security CASCADE")
    op.execute("DROP SCHEMA IF EXISTS ref CASCADE")
    op.execute("DROP SCHEMA IF EXISTS meta CASCADE")
