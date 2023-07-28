# Volume Backup

## rsync

```bash
sudo apt install rsync
```

## JS

*Скрипт для загрузки и скачивания бэкапа*

*Необходимо указать данные для s3 в файле `07-volume-backup/volume-upload/s3.js`*

Копируем папку `07-volume-backup/volume-upload/s3.js` в `/var/lib/volume/volume-upload`

*Необходимо установить node_modules*

```bash
cd /var/lib/volume/volume-upload && npm ci
```

## Bash

* Скопировать базовый конфиг для бэкапов `07-volume-backup/scripts/base-config.sh` в `/var/lib/volume/base-config.sh`
* Скопировать скрипт для создания бэкапа `07-volume-backup/scripts/volume-backup-push.sh` в `/var/lib/volume/volume-backup-push.sh`
* Скопировать скрипт для очистки старых бэкпов (30+ дней) `07-volume-backup/scripts/volume-backup-monthly-delete.sh` в `/var/lib/volume/volume-backup-monthly-delete.sh`

*Чтобы вызывать `js` скрипты из `bash` скриптом необходимо указывать полный путь к бинарнику `nodejs`. Как узнать этот путь можно посмотреть тут - [Установка nodejs](../../02-nodejs/install.md).*

*Скриптам необходимо выдать права на запуск*

```bash
chmod +x /var/lib/volume/base-config.sh
chmod +x /var/lib/volume/volume-backup-push.sh
chmod +x /var/lib/volume/volume-backup-monthly-delete.sh
```

*Как скачать файл c бэкапом. Заходим в яндекс облако. Выбираем нужный файл. Получаем ссылку на него. И из под рута запускаем:*

```bash
cd /tmp/backups-volume

curl -L "${link}" --output "${FILE_NAME}"
```
