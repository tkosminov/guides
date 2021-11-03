#!/bin/bash

token=''
chat=''

trap 'catch $? $LINENO' ERR
set -e
catch() {
  echo "Error in ${BASH_SOURCE[1]}:${BASH_LINENO[0]}. '${BASH_COMMAND}' exited with status $1"
  
  curl -X POST \
    -H 'Content-Type: application/json' \
    -d "{\"chat_id\": \"${chat}\", \"text\": \"🆘 При создании логического бэкапа базы данных возникли ошибки\nError in ${BASH_SOURCE[1]}:${BASH_LINENO[0]}. ${BASH_COMMAND} exited with status $1\", \"disable_notification\": true}" \
    https://api.telegram.org/bot${token}/sendMessage
}

# папка для бэкапа
BACKUP_DIR="/tmp/backups"

# шифрование
PASSPHRASE=""
ENCRYPT=true

# если она существует, то удаляем её
if [ -d "${BACKUP_DIR}" ]; then rm -rf ${BACKUP_DIR}; fi

# создаем папку для бэкапов
mkdir -p ${BACKUP_DIR}/ts

# префифкс/постфикс в названии баз
DB_SEARCH_PATTERN="production"

# текущее время (для названия архива с бэкапами)
CURRENT_TIME=`date +%Y-%m-%dT%H:%M:%S`

# получаем имена баз
dbNames=$(su - postgres -c "psql -U postgres -c '\l'" | grep ${DB_SEARCH_PATTERN} | awk '{print $1}')

# делаем логический бэкап баз
for dbName in ${dbNames}; do
  su - postgres -c "pg_dump -U postgres ${dbName}" > "${BACKUP_DIR}/ts/${dbName}.sql"
done

# переходим в папку с бэкапами
pushd ${BACKUP_DIR}/ts

# архивируем бэкапы (архив кладем на 1 каталог выше)
if [ "${ENCRYPT}" = true ]; then
  # если с шифрованием
  tar cf - *.sql | xz -z | gpg --symmetric --cipher-algo aes256 --pinentry-mode loopback --passphrase-file <(echo ${PASSPHRASE}) - > ../${CURRENT_TIME}.tar.xz.gpg
else
  #если без шифрования
  tar cf - * | xz -z - > ../${CURRENT_TIME}.tar.xz
fi

# переходим в папку с архивом
pushd ${BACKUP_DIR}

# удаляем .sql файлы с бэкапами
rm -rf ${BACKUP_DIR}/ts

# загружаем бэкап в облако
if [ "${ENCRYPT}" = true ]; then
  # если с шифрованием
  node /var/lib/postgresql/logical-upload/index.js uploadBackup -p ${BACKUP_DIR}/${CURRENT_TIME}.tar.xz.gpg
else
  # если без шифрования
  node /var/lib/postgresql/logical-upload/index.js uploadBackup -p ${BACKUP_DIR}/${CURRENT_TIME}.tar.xz
fi

# размер файла
if [ "${ENCRYPT}" = true ]; then
  # если с шифрованием
  backupSize=$(ls ${CURRENT_TIME}.tar.xz.gpg -lah | awk '{print $5}')
else
  # если без шифрования
  backupSize=$(ls ${CURRENT_TIME}.tar.xz -lah | awk '{print $5}')
fi

curl -X POST \
    -H 'Content-Type: application/json' \
    -d "{\"chat_id\": \"${chat}\", \"text\": \"✅ Логический бэкап базы данных успешно создан\n Размер ${backupSize}\", \"disable_notification\": true}" \
    https://api.telegram.org/bot${token}/sendMessage
