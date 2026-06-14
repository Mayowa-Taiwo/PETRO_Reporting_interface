"""
Coverage scoring: uses meta.mart_contract_item, computes essential/enhanced coverage,
dq_score, certified_ind (dq_score >= 80 AND essential_coverage_pct >= 90).
Stores in marts_governance.fact_dq_score.
"""
from decimal import Decimal
from uuid import UUID
from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncSession


async def compute_mart_coverage(
    db: AsyncSession,
    tenant_id: UUID,
    mart_id: str,
    run_id: UUID | None,
    source_schema: str = "ppdm_lite",
) -> dict:
    """Compute coverage for one mart from meta.mart_contract_item and actual column presence."""
    r = await db.execute(
        text("""
            SELECT source_table, source_column, points, is_essential
            FROM meta.mart_contract_item
            WHERE mart_id = :mart_id
        """),
        {"mart_id": mart_id},
    )
    contract_rows = r.fetchall()
    if not contract_rows:
        return {
            "essential_coverage_pct": Decimal("0"),
            "enhanced_coverage_pct": Decimal("0"),
            "dq_score": Decimal("0"),
            "certified_ind": False,
        }
    essential_total = sum(row[2] for row in contract_rows if row[3])
    enhanced_total = sum(row[2] for row in contract_rows if not row[3])
    essential_valid = 0
    enhanced_valid = 0
    for source_table, source_column, points, is_essential in contract_rows:
        try:
            check = await db.execute(
                text("""
                    SELECT 1 FROM information_schema.columns
                    WHERE table_schema = :sch AND table_name = :tbl AND column_name = :col
                """),
                {"sch": source_schema, "tbl": source_table, "col": source_column},
            )
            if check.scalar():
                if is_essential:
                    essential_valid += points
                else:
                    enhanced_valid += points
        except Exception:
            pass
    essential_pct = (Decimal(essential_valid) / Decimal(essential_total or 1)) * 100
    enhanced_pct = (Decimal(enhanced_valid) / Decimal(enhanced_total or 1)) * 100
    dq_score = (essential_pct * Decimal("0.6")) + (enhanced_pct * Decimal("0.4"))
    certified = dq_score >= 80 and essential_pct >= 90
    await db.execute(
        text("""
            INSERT INTO marts_governance.fact_dq_score
            (tenant_id, mart_id, run_id, essential_coverage_pct, enhanced_coverage_pct, dq_score, certified_ind)
            VALUES (:tid, :mart_id, :run_id, :e_pct, :x_pct, :dq, :cert)
        """),
        {
            "tid": tenant_id, "mart_id": mart_id, "run_id": run_id,
            "e_pct": essential_pct, "x_pct": enhanced_pct, "dq": dq_score, "cert": certified,
        },
    )
    await db.commit()
    return {
        "essential_coverage_pct": essential_pct,
        "enhanced_coverage_pct": enhanced_pct,
        "dq_score": dq_score,
        "certified_ind": certified,
    }
