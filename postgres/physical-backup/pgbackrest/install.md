# [pgBackRest](https://github.com/pgbackrest/pgbackrest)

## Установка

```bash
apt install build-essential libssl-dev libxml2-dev libperl-dev zlib1g-dev libpq-dev libbz2-dev perl
```

```bash
mkdir -p /tmp/pgbackrest

cd /tmp/pgbackrest && curl -L https://github.com/pgbackrest/pgbackrest/archive/release/2.34.tar.gz | tar xzf -

cd /tmp/pgbackrest/pgbackrest-release-2.34/src && ./configure

make -s -C /tmp/pgbackrest/pgbackrest-release-2.34/src

cp /tmp/pgbackrest/pgbackrest-release-2.34/src/pgbackrest /usr/local/bin

chmod 755 /usr/local/bin/pgbackrest

rm -r /tmp/pgbackrest
```

## Настройка

### Создаем директории для логов и конфигов

```bash
mkdir -p -m 770 /var/log/pgbackrest
chown postgres:postgres /var/log/pgbackrest

mkdir -p /etc/pgbackrest
mkdir -p /etc/pgbackrest/conf.d
```

### Копируем конфиги

* Скопировать файл `physical-backup/pgbackrest/configs/etc_pgbackrest.conf` в папку `/etc/pgbackrest/pgbackrest.conf`
* Скопировать файл `physical-backup/pgbackrest/configs/postres_pgbackrest.conf` в папку `/etc/postgresql/13/main/conf.d/pgbackrest.conf`

### Выдаем права на кофиги

```bash
chmod 640 /etc/pgbackrest/pgbackrest.conf
chown postgres:postgres /etc/pgbackrest/pgbackrest.conf
```

### Создаем файлы для хранилища

```bash
su - postgres -c "pgbackrest --stanza=main stanza-create"
```

### Бэкапы

#### Создаем полный бэкап

```bash
su - postgres -c "pgbackrest --log-level-console=info --stanza=main --type=full backup"
```

#### Создаем дельта бэкап

Первый бэкап все равно будет полным бэкапом.

```bash
su - postgres -c "pgbackrest --log-level-console=info --stanza=main backup"
```

#### Список бэкапов

```bash
su - postgres -c "pgbackrest --stanza=main info"
```

#### Восстанавливаемся из последнего бэкапа

```bash
# su - postgres -c "pgbackrest --stanza=main --log-level-console=info --delta --recovery-option=recovery_target=immediate restore"

su - postgres -c "pgbackrest --stanza=main --log-level-console=info --delta --recovery-option=recovery_target=immediate --target-action=promote --type=immediate restore"
```

#### Восстанавливаемся конкретную БД

```bash
su - postgres -c "pgbackrest --stanza=main --log-level-console=info --delta --recovery-option=recovery_target=immediate --target-action=promote --type=immediate --db-include=${dbName} restore"
```

## Скрипты

### Бэкапы

* Скопировать скрипт для создания бэкапа `physical-backup/pgbackrest/scripts/pgbackrest-backup-push.sh` в `/var/lib/postgresql/pgbackrest-backup-push.sh`
* Скопировать скрипт восстановления из последнего бэкапа `physical-backup/pgbackrest/scripts/pgbackrest-backup-fetch.sh` в `/var/lib/postgresql/pgbackrest-backup-fetch.sh`

#### Права

* Выдать права для запуска
  ```bash
  chmod +x /var/lib/postgresql/pgbackrest-backup-push.sh
  chmod +x /var/lib/postgresql/pgbackrest-backup-fetch.sh
  ```

#### Запуск

Заходим за рута

```bash
sudo -i
```

и вызываем скрипт, пример:

```bash
/var/lib/postgresql/pgbackrest-backup-push.sh
```
