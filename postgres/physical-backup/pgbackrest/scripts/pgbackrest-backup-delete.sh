#!/bin/bash

echo "Physical Delete Start"
echo "Use this script with caution — it will permanently remove all backups and archives from the pgBackRest repository for the specified stanza."

token=''
chat=''

# останавливаем сервисы мониторинга и пулер (чтобы не спамили ошибки в логи, пока постгрес выключен)
service prometheus stop
service postgres_exporter stop
service pgbouncer_exporter stop
service pgbouncer stop
# service odyssey stop

# останавливаем кластер постгреса
pg_ctlcluster 13 main stop

# останавливаем станзу
su - postgres -c "pgbackrest --log-level-console=info --stanza=main stop"

# удаляем станзу
su - postgres -c "pgbackrest --log-level-console=info --stanza=main stanza-delete"

# запускам постгрес
pg_ctlcluster 13 main start

# запускаем сервисы мониторинга и пулер
# service odyssey start
service pgbouncer start
service pgbouncer_exporter start
service postgres_exporter start
service prometheus start

curl -X POST \
    -H 'Content-Type: application/json' \
    -d "{\"chat_id\": \"${chat}\", \"text\": \"✅ Физический бэкап базы данных успешно удален\", \"disable_notification\": true}" \
    https://api.telegram.org/bot${token}/sendMessage

echo "Physical Delete End"
