# [PG_DUMP](https://postgrespro.ru/docs/postgresql/13/app-pgdump)

## Скрипты

### JS

*Скрипт для загрузки и скачивания бэкапа*

*Необходимо указать данные для s3 в файле `05-logical-backup/logical-upload/s3.js`*

Копируем папку `05-logical-backup/logical-upload` в `/var/lib/postgresql/logical-upload`

*Необходимо установить node_modules*

```bash
cd /var/lib/postgresql/logical-upload && npm ci
```

### Bash

* Скопировать скрипт для создания бэкапа `05-logical-backup/scripts/logical-backup-push.sh` в `/var/lib/postgresql/logical-backup-push.sh`
* Скопировать скрипт восстановления из последнего бэкапа `05-logical-backup/scripts/logical-backup-fetch.sh` в `/var/lib/postgresql/logical-backup-fetch.sh`
* Скопировать скрипт для очистки старых бэкпов (30+ дней) `05-logical-backup/scripts/logical-backup-monthly-delete.sh` в `/var/lib/postgresql/logical-backup-monthly-delete.sh`

*Чтобы вызывать `js` скрипты из `bash` скриптом необходимо указывать полный путь к бинарнику `nodejs`. Как узнать этот путь можно посмотреть тут - [Установка nodejs](../../02-nodejs/install.md).*

*Скриптам необходимо выдать права на запуск*

```bash
chmod +x /var/lib/postgresql/logical-backup-push.sh
chmod +x /var/lib/postgresql/logical-backup-fetch.sh
chmod +x /var/lib/postgresql/logical-backup-monthly-delete.sh
```

*Перед запуском скрипта на восстановление из бэкапа (`logical-backup-fetch.sh`) необходимо в папку `/tmp/backups` положить архив с бэкапами. Если папки нету, то создать её.*

*Как скачать файл c бэкапом. Заходим в яндекс облако. Выбираем нужный файл. Получаем ссылку на него. И из под рута запускаем:*

```bash
cd /tmp/backups

curl -L ${link}
```
