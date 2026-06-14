"""marts_governance fact_dq_score

Revision ID: 002
Revises: 001
Create Date: 2025-01-01 00:01:00

"""
from typing import Sequence, Union
from alembic import op
import sqlalchemy as sa

revision: str = "002"
down_revision: Union[str, None] = "001"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.create_table(
        "fact_dq_score",
        sa.Column("tenant_id", sa.Uuid(), nullable=False),
        sa.Column("mart_id", sa.String(60), nullable=False),
        sa.Column("run_id", sa.Uuid(), nullable=True),
        sa.Column("essential_coverage_pct", sa.Numeric(6, 2), nullable=False),
        sa.Column("enhanced_coverage_pct", sa.Numeric(6, 2), nullable=False),
        sa.Column("dq_score", sa.Numeric(6, 2), nullable=False),
        sa.Column("certified_ind", sa.Boolean(), nullable=False),
        sa.Column("computed_at", sa.DateTime(timezone=True), server_default=sa.text("now()")),
        sa.PrimaryKeyConstraint("tenant_id", "mart_id", "computed_at"),
        schema="marts_governance",
    )
    op.execute("ALTER TABLE marts_governance.fact_dq_score ENABLE ROW LEVEL SECURITY")
    op.execute("""
        CREATE POLICY fact_dq_score_tenant ON marts_governance.fact_dq_score
        FOR ALL USING (tenant_id = current_setting('app.tenant_id', true)::uuid)
    """)


def downgrade() -> None:
    op.drop_table("fact_dq_score", schema="marts_governance")
