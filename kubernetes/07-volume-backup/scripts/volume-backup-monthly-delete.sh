#!/bin/bash

echo "Volume Monthly Delete Start"

source /var/lib/volume/base-config.sh

/usr/bin/node /var/lib/volume/volume-upload/index.js deleteOldBackups

if [ ! -z "$TELEGRAM_CHAT_ID" ] && [ ! -z "$TELEGRAM_TOKEN" ]; then
  curl -X POST \
    -H 'Content-Type: application/json' \
    -d "{\"chat_id\": \"${TELEGRAM_CHAT_ID}\", \"text\": \"✅ Старые бэкапы ассетов ${BACKUP_PROJECT_NAME} успешно удалены\n Размер ${backupSize}\", \"disable_notification\": true}" \
    https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage
else
  echo "Volume Monthly Delete chat_id and token not provided"
fi

echo "Volume Monthly Delete Complete"
