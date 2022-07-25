#!/bin/bash

echo "Physical Delete Start"
echo "Use this script with caution — it will permanently remove all backups and archives from the pgBackRest repository for the specified stanza."

source /var/lib/postgresql/base-config.sh

# останавливаем сервисы мониторинга и пулер (чтобы не спамили ошибки в логи, пока постгрес выключен)
service prometheus stop
service postgres_exporter stop
service pgbouncer_exporter stop
service pgbouncer stop

# останавливаем кластер постгреса
pg_ctlcluster 13 main stop

# останавливаем станзу
su - postgres -c "pgbackrest --log-level-console=info --stanza=main stop"

# удаляем станзу
su - postgres -c "pgbackrest --log-level-console=info --stanza=main stanza-delete"

# запускам постгрес
pg_ctlcluster 13 main start

# запускаем сервисы мониторинга и пулер
service pgbouncer start
service pgbouncer_exporter start
service postgres_exporter start
service prometheus start

if [ ! -z "$TELEGRAM_CHAT_ID" ] && [ ! -z "$TELEGRAM_TOKEN" ]; then
  curl -X POST \
    -H 'Content-Type: application/json' \
    -d "{\"chat_id\": \"${TELEGRAM_CHAT_ID}\", \"text\": \"✅ Физический бэкап базы данных ${BACKUP_PROJECT_NAME} успешно удален\", \"disable_notification\": true}" \
    https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage
else
  echo "Physical Delete chat_id and token not provided"
fi

echo "Physical Delete End"
