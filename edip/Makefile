.PHONY: up down api web dbt-run dbt-test migrate generate-sources

up:
	docker compose -f infra/docker-compose.yml up -d

down:
	docker compose -f infra/docker-compose.yml down

api:
	cd apps/api && uv run uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

web:
	cd apps/web && npm run dev

dbt-run:
	cd dbt/edip_dbt && dbt run

dbt-test:
	cd dbt/edip_dbt && dbt test

migrate:
	cd apps/api && uv run alembic upgrade head

migrate-revision:
	cd apps/api && uv run alembic revision --autogenerate -m "$(msg)"

generate-sources:
	python scripts/generators/generate_dbt_sources_from_ddl.py
