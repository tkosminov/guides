#!/usr/bin/env bash

set -eo pipefail

if [[ "$DATABASE_DIALECT" == postgres* ]] && [ "$(whoami)" = "root" ]; then
    # older images may not have the postgres dev requirements installed
    echo "1" "Installing postgres requirements"
    if command -v uv > /dev/null 2>&1; then
        # Use uv in newer images
        uv pip install -e .[postgres]
    else
        # Use pip in older images
        pip install -e .[postgres]
    fi
fi

echo "2" "Starting web app..."

HYPHEN_SYMBOL='-'

gunicorn \
    --bind "${SUPERSET_BIND_ADDRESS:-0.0.0.0}:${SUPERSET_PORT:-8088}" \
    --access-logfile "${ACCESS_LOG_FILE:-$HYPHEN_SYMBOL}" \
    --error-logfile "${ERROR_LOG_FILE:-$HYPHEN_SYMBOL}" \
    --workers ${SERVER_WORKER_AMOUNT:-1} \
    --worker-class ${SERVER_WORKER_CLASS:-gthread} \
    --threads ${SERVER_THREADS_AMOUNT:-20} \
    --log-level "${GUNICORN_LOGLEVEL:info}" \
    --timeout ${GUNICORN_TIMEOUT:-60} \
    --keep-alive ${GUNICORN_KEEPALIVE:-2} \
    --max-requests ${WORKER_MAX_REQUESTS:-0} \
    --max-requests-jitter ${WORKER_MAX_REQUESTS_JITTER:-0} \
    --limit-request-line ${SERVER_LIMIT_REQUEST_LINE:-0} \
    --limit-request-field_size ${SERVER_LIMIT_REQUEST_FIELD_SIZE:-0} \
    "${FLASK_APP}"
