#!/usr/bin/env bash
set -euo pipefail

wait_for_db() {
  local attempts=30
  local delay=2

  for ((i=1; i<=attempts; i++)); do
    if python - <<'PY'
import os
import psycopg2

try:
    psycopg2.connect(
        dbname=os.getenv("POSTGRES_DB"),
        user=os.getenv("POSTGRES_USER"),
        password=os.getenv("POSTGRES_PASSWORD"),
        host=os.getenv("POSTGRES_HOST"),
        port=int(os.getenv("POSTGRES_PORT", "5432")),
    )
    raise SystemExit(0)
except Exception:
    raise SystemExit(1)
PY
    then
      return 0
    fi
    sleep "$delay"
  done

  return 1
}

if ! wait_for_db; then
  echo "[entrypoint] Database is not ready" >&2
  exit 1
fi

python manage.py migrate --noinput

exec "$@"
