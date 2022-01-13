#!/bin/bash

source /var/lib/postgresql/base-config.sh

su - postgres -c "/usr/local/bin/wal-g delete before FIND_FULL \$(date -d '-7 days' '+\\%FT\\%TZ') --config /var/lib/postgresql/.walg.json --confirm >> /var/log/postgresql/walg_delete.log 2>&1"

if [ ! -z "$TELEGRAM_CHAT_ID" ] && [ ! -z "$TELEGRAM_TOKEN" ]; then
  curl -X POST \
    -H 'Content-Type: application/json' \
    -d "{\"chat_id\": \"${TELEGRAM_CHAT_ID}\", \"text\": \"✅ Физический бэкап базы данных ${BACKUP_PROJECT_NAME} успешно удален\", \"disable_notification\": true}" \
    https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage
else
  echo "Physical Delete chat_id and token not provided"
fi
