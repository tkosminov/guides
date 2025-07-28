#!/bin/bash

echo "Physical Push Start"

source /var/lib/postgresql/base-config.sh

trap 'catch $? $LINENO' ERR
set -e
catch() {
  echo "Error in ${BASH_SOURCE[1]}:${BASH_LINENO[0]}. '${BASH_COMMAND}' exited with status $1"

  if [ ! -z "$TELEGRAM_CHAT_ID" ] && [ ! -z "$TELEGRAM_TOKEN" ]; then
    curl -X POST \
      -H 'Content-Type: application/json' \
      -d "{\"chat_id\": \"${TELEGRAM_CHAT_ID}\", \"text\": \"🆘 При создании физического бэкапа базы данных ${BACKUP_PROJECT_NAME} возникли ошибки\nError in ${BASH_SOURCE[1]}:${BASH_LINENO[0]}. ${BASH_COMMAND} exited with status $1\", \"disable_notification\": true}" \
      https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage
  else
    echo "Physical Push chat_id and token not provided"
  fi
}

# создаем и загружаем бэкап в облако
su - postgres -c '/usr/local/bin/wal-g backup-push /var/lib/postgresql/13/main --config /var/lib/postgresql/.walg.json'

if [ ! -z "$TELEGRAM_CHAT_ID" ] && [ ! -z "$TELEGRAM_TOKEN" ]; then
  curl -X POST \
    -H 'Content-Type: application/json' \
    -d "{\"chat_id\": \"${TELEGRAM_CHAT_ID}\", \"text\": \"✅ Физический бэкап базы данных ${BACKUP_PROJECT_NAME} успешно создан\", \"disable_notification\": true}" \
    https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage
else
  echo "Physical Push chat_id and token not provided"
fi

echo "Physical Push End"
