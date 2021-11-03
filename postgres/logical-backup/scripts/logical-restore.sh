#!/bin/bash

token=''
chat=''

read -r -p "Вы точно хотите восстановиться из логического бэкапа? <y/N> " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
  echo "Logical Restore Start"
else
  exit 0
fi

# папка для бэкапа
BACKUP_DIR="/tmp/backups"

# шифрование
PASSPHRASE=""
DECRYPT=true

# если она существует, то удаляем её
if [ -d "${BACKUP_DIR}" ]; then rm -rf ${BACKUP_DIR}/ts; fi

# создаем папку для sql файлов
mkdir -p ${BACKUP_DIR}/ts

# переходим в паку с бэкапами
pushd ${BACKUP_DIR}

# находим последний бэкап (он же единственный в папке)
lastDump=`ls -t ${BACKUP_DIR}/* | head -n 1`

# распоковываем его в папку для sql файлов
if [ "${DECRYPT}" = true ]; then
  # если с шифрованием
  lastDumpName=`echo ${lastDump} | sed s/.tar.xz.gpg//`

  echo ${PASSPHRASE} | gpg --batch --yes --pinentry-mode loopback --passphrase-fd 0 ${lastDump}
  tar -C ${BACKUP_DIR}/ts -xJvf ${lastDumpName}.tar.xz

  rm ${lastDumpName}.tar.xz
else
  # если без фирования
  tar -C ${BACKUP_DIR}/ts -xJvf ${lastDump}
fi

# останавливаем сервисы мониторинга и пулер (чтобы не спамили ошибки в логи, пока восстанавливаемся из дампа)
service prometheus stop
service postgres_exporter stop
service pgbouncer_exporter stop
service pgbouncer stop
# service odyssey stop

# обходим циклом sql файлы
for filename in $(ls ${BACKUP_DIR}/ts); do
  # название бд
  dbName=`echo ${filename} | sed s/.sql//`

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
    cat ${BACKUP_DIR}/ts/${filename} | su - postgres -c "psql -U postgres -d ${dbName}"
  }
done

# удаляем sql файлы
rm -rf ${BACKUP_DIR}/ts

# запускаем сервисы мониторинга и пулер
# service odyssey start
service pgbouncer start
service pgbouncer_exporter start
service postgres_exporter start
service prometheus start

curl -X POST \
    -H 'Content-Type: application/json' \
    -d "{\"chat_id\": \"${chat}\", \"text\": \"✅ Базы данных успешно создан восстановлена из логического бэкапа\", \"disable_notification\": true}" \
    https://api.telegram.org/bot${token}/sendMessage

echo "Logical Restore Complete"
