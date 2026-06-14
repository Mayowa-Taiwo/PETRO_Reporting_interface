FROM python:3.11-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    libpq-dev \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# PPDM-EDIP has apps/api only at build context (no dbt in this project)
COPY apps/api /app/apps/api

WORKDIR /app/apps/api
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
