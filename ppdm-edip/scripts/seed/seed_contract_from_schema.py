"""
Seed L_PPDM_TABLE and L_PPDM_COLUMN from PostgreSQL information_schema for schema ppdm_lite.
Run from repo root: python scripts/seed/seed_contract_from_schema.py
Requires: DATABASE_URL or env for Postgres connection.
"""
from pathlib import Path
import os
import re

# Optional: use psycopg2 or sqlalchemy
try:
    import psycopg2
    from psycopg2.extras import RealDictCursor
    HAS_PG = True
except ImportError:
    HAS_PG = False


def get_connection():
    url = os.environ.get("DATABASE_URL", "postgresql://edip:edip_secret@localhost:5432/edip")
    # asyncpg URL -> psycopg2 style
    if url.startswith("postgresql+asyncpg"):
        url = url.replace("postgresql+asyncpg", "postgresql", 1)
    return psycopg2.connect(url)


def seed_from_information_schema(conn) -> tuple[int, int]:
    tables_seen = set()
    columns_seen = set()
    with conn.cursor(cursor_factory=RealDictCursor) as cur:
        cur.execute("""
            SELECT table_name FROM information_schema.tables
            WHERE table_schema = 'ppdm_lite' AND table_type = 'BASE TABLE'
            ORDER BY table_name
        """)
        for row in cur.fetchall():
            t = row["table_name"]
            tables_seen.add(t)
            cur.execute("""
                INSERT INTO ppdm_lite.l_ppdm_table (table_name, table_comment)
                VALUES (%s, 'Seeded from schema')
                ON CONFLICT (table_name) DO NOTHING
            """, (t,))
        conn.commit()

        for t in sorted(tables_seen):
            cur.execute("""
                SELECT column_name, ordinal_position
                FROM information_schema.columns
                WHERE table_schema = 'ppdm_lite' AND table_name = %s
                ORDER BY ordinal_position
            """, (t,))
            for row in cur.fetchall():
                col = row["column_name"]
                seq = row["ordinal_position"]
                key = (t, col)
                if key in columns_seen:
                    continue
                columns_seen.add(key)
                cur.execute("""
                    INSERT INTO ppdm_lite.l_ppdm_column (table_name, column_name, column_sequence, column_comment)
                    VALUES (%s, %s, %s, NULL)
                    ON CONFLICT (table_name, column_name) DO NOTHING
                """, (t, col, seq))
        conn.commit()
    return len(tables_seen), len(columns_seen)


def main():
    if not HAS_PG:
        print("Install psycopg2 to run this script. Alternatively run scripts/seed/seed_contract_from_schema.sql manually.")
        return
    conn = get_connection()
    try:
        n_t, n_c = seed_from_information_schema(conn)
        print(f"Contract seeded: {n_t} tables, {n_c} columns.")
    finally:
        conn.close()


if __name__ == "__main__":
    main()
