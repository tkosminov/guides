#!/bin/bash

echo "Physical Push Start"

source /var/lib/postgresql/base-config.sh

# создаем станзу для бэкапов
# если она уже существует, то ничего не произойдет
su - postgres -c "pgbackrest --log-level-console=info --stanza=main stanza-create"

# создаем и загружаем бэкап в облако
su - postgres -c "pgbackrest --log-level-console=info --stanza=main backup"

if [ ! -z "$TELEGRAM_CHAT_ID" ] && [ ! -z "$TELEGRAM_TOKEN" ]; then
  curl -X POST \
    -H 'Content-Type: application/json' \
    -d "{\"chat_id\": \"${TELEGRAM_CHAT_ID}\", \"text\": \"✅ Физический бэкап базы данных ${BACKUP_PROJECT_NAME} успешно создан\", \"disable_notification\": true}" \
    https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage
else
  echo "Physical Push chat_id and token not provided"
fi

echo "Physical Push End"
