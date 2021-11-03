#!/bin/bash

echo "Physical Push Start"

token=''
chat=''

# создаем и загружаем бэкап в облако
su - postgres -c '/usr/local/bin/wal-g backup-push /var/lib/postgresql/13/main --config /var/lib/postgresql/.walg.json'

curl -X POST \
    -H 'Content-Type: application/json' \
    -d "{\"chat_id\": \"${chat}\", \"text\": \"✅ Физический бэкап базы данных успешно создан\", \"disable_notification\": true}" \
    https://api.telegram.org/bot${token}/sendMessage

echo "Physical Push End"
