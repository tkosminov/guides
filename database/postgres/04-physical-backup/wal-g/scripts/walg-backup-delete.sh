#!/bin/bash

source /var/lib/postgresql/base-config.sh

trap 'catch $? $LINENO' ERR
set -e
catch() {
  echo "Error in ${BASH_SOURCE[1]}:${BASH_LINENO[0]}. '${BASH_COMMAND}' exited with status $1"

  if [ ! -z "$TELEGRAM_CHAT_ID" ] && [ ! -z "$TELEGRAM_TOKEN" ]; then
    curl -X POST \
      -H 'Content-Type: application/json' \
      -d "{\"chat_id\": \"${TELEGRAM_CHAT_ID}\", \"text\": \"🆘 При удалении физического бэкапа базы данных ${BACKUP_PROJECT_NAME} возникли ошибки\nError in ${BASH_SOURCE[1]}:${BASH_LINENO[0]}. ${BASH_COMMAND} exited with status $1\", \"disable_notification\": true}" \
      https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage
  else
    echo "Physical Delete chat_id and token not provided"
  fi
}

su - postgres -c "/usr/local/bin/wal-g delete before FIND_FULL \$(date -d '-7 days' +\"%Y-%m-%dT%H:%M:%SZ\") --config /var/lib/postgresql/.walg.json --confirm --use-sentinel-time >> /var/log/postgresql/walg_delete.log 2>&1"
# su - postgres -c "/usr/local/bin/wal-g delete retain FULL 1 --config /var/lib/postgresql/.walg.json --confirm --use-sentinel-time >> /var/log/postgresql/walg_delete.log 2>&1"

if [ ! -z "$TELEGRAM_CHAT_ID" ] && [ ! -z "$TELEGRAM_TOKEN" ]; then
  curl -X POST \
    -H 'Content-Type: application/json' \
    -d "{\"chat_id\": \"${TELEGRAM_CHAT_ID}\", \"text\": \"✅ Физический бэкап базы данных ${BACKUP_PROJECT_NAME} успешно удален\", \"disable_notification\": true}" \
    https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage
else
  echo "Physical Delete chat_id and token not provided"
fi
