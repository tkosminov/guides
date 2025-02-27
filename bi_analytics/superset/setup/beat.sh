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

echo "2" "Starting Celery beat..."
rm -f /tmp/celerybeat.pid

celery --app=superset.tasks.celery_app:app beat --pidfile /tmp/celerybeat.pid -l INFO -s "${SUPERSET_HOME}"/celerybeat-schedule
