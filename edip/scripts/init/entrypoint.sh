#!/usr/bin/env bash
set -euo pipefail

echo "=== EDIP init starting ==="

DDL_PATH="${DDL_PATH:-scripts/ddl/ppdm_lite11_postgres_ddl.sql}"
PGHOST="${PGHOST:-db}"
DB_URL_SYNC="${DATABASE_URL_SYNC:-postgresql://edip:edip_secret@${PGHOST}:5432/edip}"
DBT_TARGET_SCHEMA="${DBT_TARGET_SCHEMA:-marts_shared}"

require_file () {
  local f="$1"
  if [[ ! -f "$f" ]]; then
    echo "ERROR: Required file not found: $f"
    echo "Fix: ensure it exists in the container at the same path."
    exit 1
  fi
}

wait_for_db () {
  echo "==> Waiting for DB to be reachable..."
  for i in {1..30}; do
    if pg_isready -h "$PGHOST" -U edip -d edip >/dev/null 2>&1; then
      echo "==> DB is ready."
      return 0
    fi
    sleep 2
  done
  echo "ERROR: DB not ready after waiting."
  exit 1
}

wait_for_db

# 0) Generate dbt sources/staging from DDL (idempotent via checksum)
if [[ "${RUN_GENERATOR:-0}" == "1" ]]; then
  echo "==> Generator enabled"
  require_file "$DDL_PATH"

  CHECKSUM_DIR="scripts/ddl/.checksums"
  mkdir -p "$CHECKSUM_DIR"
  DDL_SUM="$(sha256sum "$DDL_PATH" | awk '{print $1}')"
  SUM_FILE="$CHECKSUM_DIR/ppdm_lite11_postgres_ddl.sha256"

  if [[ -f "$SUM_FILE" ]] && grep -q "$DDL_SUM" "$SUM_FILE"; then
    echo "==> DDL checksum unchanged; skipping generator."
  else
    echo "==> Running generator from DDL: $DDL_PATH"
    python scripts/generators/generate_dbt_sources_from_ddl.py "$DDL_PATH"
    echo "$DDL_SUM" > "$SUM_FILE"
  fi
fi

# 1) Migrations
if [[ "${RUN_MIGRATIONS:-0}" == "1" ]]; then
  echo "==> Running Alembic migrations"
  cd /app/apps/api
  alembic upgrade head
  cd /app
fi

# 2) Seeds (idempotent SQL: ON CONFLICT DO NOTHING)
if [[ "${RUN_SEEDS:-0}" == "1" ]]; then
  echo "==> Running seed SQL"
  require_file "scripts/seed/seed_roles_tenant_user.sql"
  psql "$DB_URL_SYNC" -v ON_ERROR_STOP=1 -f scripts/seed/seed_roles_tenant_user.sql
fi

# 3) dbt build (dims + production mart MVP)
if [[ "${RUN_DBT:-0}" == "1" ]]; then
  echo "==> Running dbt deps + dbt build"
  require_file "dbt/edip_dbt/dbt_project.yml"

  export DBT_PROFILES_DIR="/app/dbt/edip_dbt"
  export DBT_TARGET_SCHEMA="$DBT_TARGET_SCHEMA"

  cd /app/dbt/edip_dbt
  dbt deps
  dbt build
  cd /app
fi

echo "=== EDIP init completed successfully ==="
