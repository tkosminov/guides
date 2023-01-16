#!/bin/bash

read -r -p "Вы точно хотите восстановиться из логического бэкапа? <y/N> " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
  echo "Logical Fetch Start"
else
  exit 0
fi

source /var/lib/postgresql/base-config.sh

# папка для бэкапа
BACKUP_DIR="/tmp/backups"

# если она существует, то удаляем её
if [ -d "${BACKUP_DIR}" ]; then rm -rf ${BACKUP_DIR}/files; fi

# создаем папку для sql файлов
mkdir -p ${BACKUP_DIR}/files

# переходим в паку с бэкапами
pushd ${BACKUP_DIR}

# находим последний бэкап (он же единственный в папке)
lastDump=$(ls -t ${BACKUP_DIR}/* | head -n 1)

# распоковываем его в папку для sql файлов
if [ "${BACKUP_DECRYPT}" = true ]; then
  # если с шифрованием
  lastDumpName=$(echo ${lastDump} | sed s/.tar.xz.gpg//)

  echo ${BACKUP_PASS_PHRASE} | gpg --batch --yes --pinentry-mode loopback --passphrase-fd 0 ${lastDump}
  tar -C ${BACKUP_DIR}/files -xJvf ${lastDumpName}.tar.xz

  rm ${lastDumpName}.tar.xz
else
  # если без фирования
  tar -C ${BACKUP_DIR}/files -xJvf ${lastDump}
fi

# останавливаем сервисы мониторинга и пулер (чтобы не спамили ошибки в логи, пока восстанавливаемся из дампа)
service prometheus stop
service postgres_exporter stop
service pgbouncer_exporter stop
service pgbouncer stop

# обходим циклом sql файлы
for filename in $(ls ${BACKUP_DIR}/files); do
  # название бд
  dbName=$(echo ${filename} | sed s/.sql//)

  {
    # удаляем существующую базу
    su - postgres -c "dropdb ${dbName}"
  }
  {
    # создаем новую базу
    su - postgres -c "createdb ${dbName}"
  }
  {
    # применяем бэкап
    cat ${BACKUP_DIR}/files/${filename} | su - postgres -c "psql -U postgres -d ${dbName}"
  }
done

# удаляем sql файлы
rm -rf ${BACKUP_DIR}/files

# запускаем сервисы мониторинга и пулер
service pgbouncer start
service pgbouncer_exporter start
service postgres_exporter start
service prometheus start

if [ ! -z "$TELEGRAM_CHAT_ID" ] && [ ! -z "$TELEGRAM_TOKEN" ]; then
  curl -X POST \
    -H 'Content-Type: application/json' \
    -d "{\"chat_id\": \"${TELEGRAM_CHAT_ID}\", \"text\": \"✅ Базы данных ${BACKUP_PROJECT_NAME} успешно восстановлены из логического бэкапа\", \"disable_notification\": true}" \
    https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage
else
  echo "Logical Fetch chat_id and token not provided"
fi

echo "Logical Fetch Complete"
