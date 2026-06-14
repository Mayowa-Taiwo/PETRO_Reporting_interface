FROM python:3.11-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    curl \
    wget \
    gcc \
    g++ \
    make \
    libpq-dev \
    postgresql-client \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY apps/api /app/apps/api
COPY dbt /app/dbt
COPY scripts /app/scripts

WORKDIR /app/apps/api
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
