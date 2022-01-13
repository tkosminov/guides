# [pgBackRest](https://github.com/pgbackrest/pgbackrest)

## Установка

```bash
apt install build-essential libssl-dev libxml2-dev libperl-dev zlib1g-dev libpq-dev libbz2-dev liblz4-dev libzstd-dev perl git
```

*Скачиваем прогу с гита и билдим её в бинарник, кладем бинарник в `/usr/local/bin` и удаляем исходники*

```bash
mkdir -p /tmp/pgbackrest

cd /tmp/pgbackrest && curl -L https://github.com/pgbackrest/pgbackrest/archive/release/2.34.tar.gz | tar xzf -

cd /tmp/pgbackrest/pgbackrest-release-2.34/src && ./configure

make -s -C /tmp/pgbackrest/pgbackrest-release-2.34/src

cp /tmp/pgbackrest/pgbackrest-release-2.34/src/pgbackrest /usr/local/bin

chmod 755 /usr/local/bin/pgbackrest

rm -r /tmp/pgbackrest
```

*Создаем папки для логов и конфигов, и выдаем на них права*

```bash
mkdir -p -m 770 /var/log/pgbackrest
chown postgres:postgres /var/log/pgbackrest

mkdir -p /etc/pgbackrest
mkdir -p /etc/pgbackrest/conf.d
```

## Настройка

### Конфиг постгреса

Скопировать конфиг для постгреса `05-physical-backup/pgbackrest/conf/postres_pgbackrest.conf` в папку `/etc/postgresql/13/main/conf.d/pgbackrest.conf`

Перезапустить постгрес

```bash
service postgresql restart
```

### Конфиг pgbackrest

*Необходимо отредактировать файл `05-physical-backup/pgbackrest/conf/etc_pgbackrest.conf`*

*Необходимо указать пасс-фразу для шифрования бэкапов и данные для s3*

```conf
repo1-cipher-pass=
repo1-s3-bucket=
repo1-s3-key=
repo1-s3-key-secret=
```

Скопировать конфиг для pgbackrest `05-physical-backup/pgbackrest/conf/etc_pgbackrest.conf` в папку `/etc/pgbackrest/pgbackrest.conf`

*После выдаем права для `postgres` на этот конфиг*

```bash
chmod 640 /etc/pgbackrest/pgbackrest.conf
chown postgres:postgres /etc/pgbackrest/pgbackrest.conf
```

## Скрипты

### JS

*Скрипт для очистки бакета*

*Необходимо указать данные для s3 в файле `05-physical-backup/pgbackrest/pgbackrest-stanza-delete/s3.js`*

Копируем папку `05-physical-backup/pgbackrest/pgbackrest-stanza-delete` в `/var/lib/postgresql/pgbackrest-stanza-delete`

*Необходимо установить node_modules*

```bash
cd /var/lib/postgresql/pgbackrest-stanza-delete && npm i
```

### Bash

* Скопировать скрипт для создания бэкапа `05-physical-backup/pgbackrest/scripts/pgbackrest-backup-push.sh` в `/var/lib/postgresql/pgbackrest-backup-push.sh`
* Скопировать скрипт восстановления из последнего бэкапа `05-physical-backup/pgbackrest/scripts/pgbackrest-backup-fetch.sh` в `/var/lib/postgresql/pgbackrest-backup-fetch.sh`
* Скопировать скрипт для удаления устаревших бэкапов (7+ дней), этот скрипт так же запускает создание логического и физического бэкапа `05-physical-backup/pgbackrest/scripts/pgbackrest-backup-weekly-delete-node.sh` в `/var/lib/postgresql/pgbackrest-backup-weekly-delete-node.sh`

*pgbackrest не поддерживает удаление бэкапов. Для этого необходимо полностью удалить stanza.*

*Для удаление stanza написано два скрипта*

*1. `pgbackrest-backup-weekly-delete.sh` - он удаляет stanza методами `pgbackrest`, что требует остановки кластера постгреса.*

*2. `pgbackrest-backup-weekly-delete-node.sh` - он удаляет stanza путем очистки бакета через апи с помощью `nodejs`.*

*Для нас непреемлимо останавливать постгрес раз в неделю, по этому мы используем срипт с очисткой бакета через `nodejs`.*
*Чтобы вызывать `js` скрипты из `bash` скриптом необходимо указывать полный путь к бинарнику `nodejs`. Как узнать этот путь можно посмотреть тут - [Установка nodejs](../../02-nodejs/install.md).*
*После чего необходимо указать правильный путь в файле скрипта `05-physical-backup/pgbackrest/scripts/pgbackrest-backup-weekly-delete-node.sh`*

*Скриптам необходимо выдать права на запуск*

```bash
chmod +x /var/lib/postgresql/pgbackrest-backup-push.sh
chmod +x /var/lib/postgresql/pgbackrest-backup-fetch.sh
chmod +x /var/lib/postgresql/pgbackrest-backup-weekly-delete-node.sh
```

## Команды для pgbackrest

### Создать stanza

```bash
su - postgres -c "pgbackrest --stanza=main stanza-create"
```

### Список бэкапов

```bash
su - postgres -c "pgbackrest --stanza=main info"
```

### Создать полный бэкап

```bash
su - postgres -c "pgbackrest --log-level-console=info --stanza=main --type=full backup"
```

### Создать инкрементируемый бэкап

*Первый бэкап все равно будет полным*

```bash
su - postgres -c "pgbackrest --log-level-console=info --stanza=main backup"
```

### Восстановится из последнего бэкапа

```bash
su - postgres -c "pgbackrest --stanza=main --log-level-console=info --delta --recovery-option=recovery_target=immediate --target-action=promote --type=immediate restore"
```

### Восстановить конкретную БД из последнего бэкапа

```bash
su - postgres -c "pgbackrest --stanza=main --log-level-console=info --delta --recovery-option=recovery_target=immediate --target-action=promote --type=immediate --db-include=${dbName} restore"
```
