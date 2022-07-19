#!/bin/bash

echo "Logical Push Start"

source /var/lib/postgresql/base-config.sh

trap 'catch $? $LINENO' ERR
set -e
catch() {
  echo "Error in ${BASH_SOURCE[1]}:${BASH_LINENO[0]}. '${BASH_COMMAND}' exited with status $1"

  if [ ! -z "$TELEGRAM_CHAT_ID" ] && [ ! -z "$TELEGRAM_TOKEN" ]; then
    curl -X POST \
      -H 'Content-Type: application/json' \
      -d "{\"chat_id\": \"${TELEGRAM_CHAT_ID}\", \"text\": \"🆘 При создании логического бэкапа базы данных ${BACKUP_PROJECT_NAME} возникли ошибки\nError in ${BASH_SOURCE[1]}:${BASH_LINENO[0]}. ${BASH_COMMAND} exited with status $1\", \"disable_notification\": true}" \
      https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage
  else
    echo "Logical Push chat_id and token not provided"
  fi
}

# папка для бэкапа
BACKUP_DIR="/tmp/backups"

# если она существует, то удаляем её
if [ -d "${BACKUP_DIR}" ]; then rm -rf ${BACKUP_DIR}; fi

# создаем папку для бэкапов
mkdir -p ${BACKUP_DIR}/files

# префифкс/постфикс в названии баз
DB_SEARCH_PATTERN="production"

# текущее время (для названия архива с бэкапами)
CURRENT_TIME=$(date +%Y-%m-%dT%H:%M:%S)

# получаем имена баз
dbNames=$(su - postgres -c "psql -q -A -t -c \"SELECT datname FROM pg_database;\"" | grep ${DB_SEARCH_PATTERN} | awk '{print $1}')

# делаем логический бэкап баз
for dbName in ${dbNames}; do
  su - postgres -c "pg_dump -U postgres ${dbName}" >"${BACKUP_DIR}/files/${dbName}.sql"
done

# переходим в папку с бэкапами
pushd ${BACKUP_DIR}/files

# архивируем бэкапы (архив кладем на 1 каталог выше)
if [ "${BACKUP_ENCRYPT}" = true ]; then
  # если с шифрованием
  tar cf - *.sql | xz -z | gpg --symmetric --cipher-algo aes256 --pinentry-mode loopback --passphrase-file <(echo ${BACKUP_PASS_PHRASE}) - >../${CURRENT_TIME}.tar.xz.gpg
else
  #если без шифрования
  tar cf - * | xz -z - >../${CURRENT_TIME}.tar.xz
fi

# переходим в папку с архивом
pushd ${BACKUP_DIR}

# удаляем .sql файлы с бэкапами
rm -rf ${BACKUP_DIR}/files

# загружаем бэкап в облако
if [ "${BACKUP_ENCRYPT}" = true ]; then
  # если с шифрованием
  /root/.nvm/versions/node/v14.18.2/bin/node /var/lib/postgresql/logical-upload/index.js uploadBackup -p ${BACKUP_DIR}/${CURRENT_TIME}.tar.xz.gpg
else
  # если без шифрования
  /root/.nvm/versions/node/v14.18.2/bin/node /var/lib/postgresql/logical-upload/index.js uploadBackup -p ${BACKUP_DIR}/${CURRENT_TIME}.tar.xz
fi

# размер файла
if [ "${BACKUP_ENCRYPT}" = true ]; then
  # если с шифрованием
  backupSize=$(ls ${CURRENT_TIME}.tar.xz.gpg -lah | awk '{print $5}')
else
  # если без шифрования
  backupSize=$(ls ${CURRENT_TIME}.tar.xz -lah | awk '{print $5}')
fi

if [ ! -z "$TELEGRAM_CHAT_ID" ] && [ ! -z "$TELEGRAM_TOKEN" ]; then
  curl -X POST \
    -H 'Content-Type: application/json' \
    -d "{\"chat_id\": \"${TELEGRAM_CHAT_ID}\", \"text\": \"✅ Логический бэкап базы данных ${BACKUP_PROJECT_NAME} успешно создан\n Размер ${backupSize}\", \"disable_notification\": true}" \
    https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage
else
  echo "Logical Push chat_id and token not provided"
fi

echo "Logical Push Complete"
