#!/bin/bash

echo "Volume Backup Push Start"

source /var/lib/volume/base-config.sh

trap 'catch $? $LINENO' ERR
set -e
catch() {
  echo "Error in ${BASH_SOURCE[1]}:${BASH_LINENO[0]}. '${BASH_COMMAND}' exited with status $1"

  if [ ! -z "$TELEGRAM_CHAT_ID" ] && [ ! -z "$TELEGRAM_TOKEN" ]; then
    curl -X POST \
      -H 'Content-Type: application/json' \
      -d "{\"chat_id\": \"${TELEGRAM_CHAT_ID}\", \"text\": \"🆘 При создании бэкапа ассетов сервера ${BACKUP_PROJECT_NAME} возникли ошибки\nError in ${BASH_SOURCE[1]}:${BASH_LINENO[0]}. ${BASH_COMMAND} exited with status $1\", \"disable_notification\": true}" \
      https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage
  else
    echo "Volume Backup chat_id and token not provided"
  fi
}

# папка для бэкапа
BACKUP_DIR="/tmp/backups-volume"

# Путь к ассетам
ASSETS_PATH='/volumes'

# текущее время (для названия архива с бэкапами)
CURRENT_TIME=$(date +%Y-%m-%dT%H:%M:%S)

# если она существует, то удаляем её
if [ -d "${BACKUP_DIR}" ]; then rm -rf ${BACKUP_DIR}; fi

# создаем папку для бэкапов
mkdir -p ${BACKUP_DIR}/files

# копируем ассеты во временную папку для последующей архивации
rsync -rv --exclude=clockworkd.clockwork.output \
          --ignore-missing-args \
          --log-file ${BACKUP_DIR}/rsync.log \
          ${ASSETS_PATH}/* ${BACKUP_DIR}/files

# переходим в папку с бэкапами
pushd ${BACKUP_DIR}/files

# архивируем ассеты
tar cf - * | xz -z - >../${CURRENT_TIME}.tar.xz

# переходим в папку с архивом
pushd ${BACKUP_DIR}

# удаляем скопированные файлы с бэкапами
rm -rf ${BACKUP_DIR}/files

# грузим бэкап в облако
/usr/bin/node /var/lib/volume/volume-upload/index.js uploadBackup -p ${BACKUP_DIR}/${CURRENT_TIME}.tar.xz

# размер файла
BACKUP_SIZE=$(ls ${CURRENT_TIME}.tar.xz -lah | awk '{print $5}')

if [ ! -z "$TELEGRAM_CHAT_ID" ] && [ ! -z "$TELEGRAM_TOKEN" ]; then
  curl -X POST \
    -H 'Content-Type: application/json' \
    -d "{\"chat_id\": \"${TELEGRAM_CHAT_ID}\", \"text\": \"✅ Бэкап ассетов ${BACKUP_PROJECT_NAME} успешно создан\n Размер ${BACKUP_SIZE}\", \"disable_notification\": true}" \
    https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage
else
  echo "Volume Backup Push chat_id and token not provided"
fi

echo "Volume Backup Push End"
