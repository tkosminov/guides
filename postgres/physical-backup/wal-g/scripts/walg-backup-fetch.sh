#!/bin/bash

token=''
chat=''

read -r -p "Вы точно хотите восстановиться из физического бэкапа? <y/N> " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
  echo "Physical Restore Start"
else
  exit 0
fi

# останавливаем сервисы мониторинга и пулер (чтобы не спамили ошибки в логи, пока постгрес выключен)
service prometheus stop
service postgres_exporter stop
service pgbouncer_exporter stop
service pgbouncer stop
# service odyssey stop

# останавливаем постгрес
service postgresql stop

# удаляем текущую папку с базами
rm -rf /var/lib/postgresql/13/main

# скачиваем бэкап из облака
su - postgres -c '/usr/local/bin/wal-g backup-fetch /var/lib/postgresql/13/main LATEST --config /var/lib/postgresql/.walg-restore.json'

# создаем файл для восстановления из бэкапа
su - postgres -c 'touch /var/lib/postgresql/13/main/recovery.signal'

# запускам постгрес
service postgresql start

# запускаем сервисы мониторинга и пулер
# service odyssey start
service pgbouncer start
service pgbouncer_exporter start
service postgres_exporter start
service prometheus start

curl -X POST \
    -H 'Content-Type: application/json' \
    -d "{\"chat_id\": \"${chat}\", \"text\": \"✅ Базы данных успешно восстановлены из физического бэкапа\", \"disable_notification\": true}" \
    https://api.telegram.org/bot${token}/sendMessage

echo "Physical Restore End"
