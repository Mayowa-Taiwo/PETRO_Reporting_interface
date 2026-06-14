"""
Seed demo ingest source, mappings, and one run with sample PDEN + volumes.
Run after DB init and contract seed. Requires DATABASE_URL.
"""
import os
import uuid
from datetime import date, timedelta

try:
    import psycopg2
    from psycopg2.extras import execute_values
    HAS_PG = True
except ImportError:
    HAS_PG = False


def get_connection():
    url = os.environ.get("DATABASE_URL", "postgresql://edip:edip_secret@localhost:5432/edip")
    if url.startswith("postgresql+asyncpg"):
        url = url.replace("postgresql+asyncpg", "postgresql", 1)
    return psycopg2.connect(url)


def main():
    if not HAS_PG:
        print("Install psycopg2 to run this script.")
        return
    conn = get_connection()
    try:
        cur = conn.cursor()
        # Source
        cur.execute("""
            INSERT INTO meta.ingest_source (source_name, source_type, connection_ref, is_enabled)
            SELECT 'Demo Upstream', 'file_drop', NULL, true
            WHERE NOT EXISTS (SELECT 1 FROM meta.ingest_source WHERE source_name = 'Demo Upstream')
        """)
        cur.execute("SELECT source_id FROM meta.ingest_source WHERE source_name = 'Demo Upstream' LIMIT 1")
        row = cur.fetchone()
        if not row:
            conn.rollback()
            print("Could not get or create source.")
            return
        source_id = row[0]

        # Mappings (skip if already present for this source)
        cur.execute("SELECT COUNT(*) FROM meta.mapping_registry WHERE source_id = %s", (source_id,))
        if cur.fetchone()[0] == 0:
            for col, essential in [
                ("pden_id", True), ("pden_type", True), ("pden_source", True),
                ("pden_name", False), ("data_source", True), ("ppdm_guid", True), ("remark", False),
            ]:
                cur.execute("""
                    INSERT INTO meta.mapping_registry (source_id, source_table, source_column, target_table, target_column, is_essential, is_enabled)
                    VALUES (%s, 'pden_staging', %s, 'l_pden', %s, %s, true)
                """, (source_id, col, col, essential))
            for col, essential in [
                ("pden_id", True), ("pden_type", True), ("pden_source", True),
                ("volume_date", True), ("volume_method", True), ("activity_type", True),
                ("oil_cum_volume", False), ("gas_cum_volume", False), ("data_source", True), ("ppdm_guid", True),
            ]:
                cur.execute("""
                    INSERT INTO meta.mapping_registry (source_id, source_table, source_column, target_table, target_column, is_essential, is_enabled)
                    VALUES (%s, 'pden_vol_staging', %s, 'l_pden_vol_summary', %s, %s, true)
                """, (source_id, col, col, essential))

        # Demo PDEN rows in ppdm_lite (so UI has data)
        pden_rows = [
            ("PDEN-001", "WELL", "DEMO", "Demo Well 1", None, "OIL", "POOL-A", "UWI-001", "PRJ-1", "DEMO", None, None),
            ("PDEN-002", "WELL", "DEMO", "Demo Well 2", None, "GAS", "POOL-B", "UWI-002", None, "DEMO", None, None),
        ]
        for r in pden_rows:
            cur.execute("""
                INSERT INTO ppdm_lite.l_pden (pden_id, pden_type, pden_source, pden_name, other_name, primary_product, pool_id, uwi, project_id, data_source, ppdm_guid, remark)
                VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
                ON CONFLICT (pden_id, pden_type, pden_source) DO NOTHING
            """, r)

        # Demo volumes
        base = date.today().replace(day=1) - timedelta(days=60)
        vol_rows = []
        for i in range(12):
            d = base + timedelta(days=30 * i)
            vol_rows.append(("PDEN-001", "WELL", "DEMO", d, "ACTUAL", "PRODUCTION", "OIL", 1000.0 + i * 50, 200.0 + i * 10, 50.0, None, "DEMO", None, None))
            vol_rows.append(("PDEN-002", "WELL", "DEMO", d, "ACTUAL", "PRODUCTION", "GAS", None, 5000.0 + i * 100, None, None, "DEMO", None, None))
        execute_values(cur, """
            INSERT INTO ppdm_lite.l_pden_vol_summary (pden_id, pden_type, pden_source, volume_date, volume_method, activity_type, primary_product, oil_cum_volume, gas_cum_volume, water_cum_volume, boe_cum_volume, data_source, ppdm_guid, remark)
            VALUES %s ON CONFLICT (pden_id, pden_type, pden_source, volume_date, volume_method, activity_type) DO NOTHING
        """, vol_rows)

        # One ingest_run and sample lineage + dq_table_score for demo
        cur.execute("""
            INSERT INTO meta.ingest_run (run_id, source_id, started_at, finished_at, status, mode, notes)
            VALUES (%s, %s, now() - interval '1 hour', now(), 'succeeded', 'full_refresh', 'Demo run')
        """, (uuid.uuid4(), source_id))
        cur.execute("SELECT run_id FROM meta.ingest_run ORDER BY started_at DESC LIMIT 1")
        run_id = cur.fetchone()[0]
        for target_table in ["l_pden", "l_pden_vol_summary"]:
            cur.execute("SELECT column_name FROM ppdm_lite.l_ppdm_column WHERE table_name = %s", (target_table,))
            cols = [r[0] for r in cur.fetchall()]
            for col in cols[:6]:  # first 6 as "valid" for demo
                cur.execute("""
                    INSERT INTO ppdm_lite.l_ppdm_origin (source_table_name, source_column_name, target_table_name, target_column_name, run_id)
                    VALUES ('silver', %s, %s, %s, %s)
                """, (col, target_table, col, run_id))
            # DQ score row
            ess = min(6, len([c for c in cols if c in ('pden_id','pden_type','pden_source','data_source','ppdm_guid','volume_date','volume_method','activity_type')]))
            cur.execute("""
                INSERT INTO meta.dq_table_score (run_id, target_table, essential_total, essential_valid, optional_total, optional_valid, essential_coverage_pct, optional_coverage_pct, dq_score, certified_ind)
                VALUES (%s, %s, 5, 5, 2, 1, 100, 50, 80, true)
                ON CONFLICT (run_id, target_table) DO UPDATE SET dq_score = 80, certified_ind = true
            """, (run_id, target_table))

        conn.commit()
        print("Demo data seeded: source, mappings, 2 PDENs, volumes, one run with lineage and DQ scores.")
    finally:
        conn.close()


if __name__ == "__main__":
    main()
