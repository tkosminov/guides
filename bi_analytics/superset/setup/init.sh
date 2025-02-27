#!/usr/bin/env bash

set -e

if [[ "$DATABASE_DIALECT" == postgres* ]] && [ "$(whoami)" = "root" ]; then
    # older images may not have the postgres dev requirements installed
    echo "1" "Installing postgres requirements"
    if command -v uv > /dev/null 2>&1; then
        # Use uv in newer images
        uv pip install .[postgres]
    else
        # Use pip in older images
        pip install .[postgres]
    fi
fi

STEP_CNT=3

echo "1" "Starting" "Applying DB migrations"
superset db upgrade

echo "2" "Starting" "Setting up admin user"
superset fab create-admin \
        --username $ADMIN_USERNAME \
        --email $ADMIN_EMAIL \
        --password "$ADMIN_PASSWORD" \
        --firstname Superset \
        --lastname Admin

echo "3" "Starting" "Setting up roles and perms"
superset init
