#!/bin/bash

echo "Logical Monthly Delete Start"

source /var/lib/postgresql/base-config.sh

/usr/bin/node /var/lib/postgresql/logical-upload/index.js deleteOldBackups

if [ ! -z "$TELEGRAM_CHAT_ID" ] && [ ! -z "$TELEGRAM_TOKEN" ]; then
  curl -X POST \
    -H 'Content-Type: application/json' \
    -d "{\"chat_id\": \"${TELEGRAM_CHAT_ID}\", \"text\": \"✅ Старые логические бэкап базы данных ${BACKUP_PROJECT_NAME} успешно удалены\n Размер ${backupSize}\", \"disable_notification\": true}" \
    https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage
else
  echo "Logical Monthly Delete chat_id and token not provided"
fi

echo "Logical Monthly Delete Complete"
