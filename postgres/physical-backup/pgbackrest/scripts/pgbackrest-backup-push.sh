#!/bin/bash

echo "Physical Push Start"

token=''
chat=''

# создаем станзу для бэкапов
# если она уже существует, то ничего не произойдет
su - postgres -c "pgbackrest --log-level-console=info --stanza=main stanza-create"

# создаем и загружаем бэкап в облако
su - postgres -c "pgbackrest --log-level-console=info --stanza=main backup"

curl -X POST \
    -H 'Content-Type: application/json' \
    -d "{\"chat_id\": \"${chat}\", \"text\": \"✅ Физический бэкап базы данных успешно создан\", \"disable_notification\": true}" \
    https://api.telegram.org/bot${token}/sendMessage

echo "Physical Push End"
