#!/bin/bash

read -r -p "Вы точно хотите восстановиться из физического бэкапа? <y/N> " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
  echo "Physical Restore Start"
else
  exit 0
fi

source /var/lib/postgresql/base-config.sh

trap 'catch $? $LINENO' ERR
set -e
catch() {
  echo "Error in ${BASH_SOURCE[1]}:${BASH_LINENO[0]}. '${BASH_COMMAND}' exited with status $1"

  if [ ! -z "$TELEGRAM_CHAT_ID" ] && [ ! -z "$TELEGRAM_TOKEN" ]; then
    curl -X POST \
      -H 'Content-Type: application/json' \
      -d "{\"chat_id\": \"${TELEGRAM_CHAT_ID}\", \"text\": \"🆘 При восстановлении из физического бэкапа базы данных ${BACKUP_PROJECT_NAME} возникли ошибки\nError in ${BASH_SOURCE[1]}:${BASH_LINENO[0]}. ${BASH_COMMAND} exited with status $1\", \"disable_notification\": true}" \
      https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage
  else
    echo "Physical Restore chat_id and token not provided"
  fi
}

# останавливаем сервисы мониторинга и пулер (чтобы не спамили ошибки в логи, пока постгрес выключен)
service prometheus stop
service postgres_exporter stop
service pgbouncer_exporter stop
service pgbouncer stop

# останавливаем кластер постгреса
pg_ctlcluster 13 main stop

# удаляем текущую папку с базами
su - postgres -c 'find /var/lib/postgresql/13/main -mindepth 1 -delete'

# скачиваем бэкап из облака
su - postgres -c 'pgbackrest --stanza=main --log-level-console=info --delta --recovery-option=recovery_target=immediate --target-action=promote --type=immediate restore'

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
    -d "{\"chat_id\": \"${TELEGRAM_CHAT_ID}\", \"text\": \"✅ Базы данных ${BACKUP_PROJECT_NAME} успешно восстановлены из физического бэкапа\", \"disable_notification\": true}" \
    https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage
else
  echo "Physical Restore chat_id and token not provided"
fi

echo "Physical Restore End"
