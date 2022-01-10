#!/bin/bash

echo "Physical Delete Start"
echo "Use this script with caution — it will permanently remove all backups and archives from the pgBackRest repository for the specified stanza."

token=''
chat=''

# создаем и загружаем бэкап в облако
su - postgres -c "pgbackrest --stanza=main stanza-delete"

curl -X POST \
    -H 'Content-Type: application/json' \
    -d "{\"chat_id\": \"${chat}\", \"text\": \"✅ Физический бэкап базы данных успешно удален\", \"disable_notification\": true}" \
    https://api.telegram.org/bot${token}/sendMessage

echo "Physical Delete End"
