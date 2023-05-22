# [PostgreSQL](https://github.com/postgres/postgres)

## Установка

### PostgreSQL

```bash
apt update
apt -y install vim bash-completion wget
```

```bash
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" | tee  /etc/apt/sources.list.d/pgdg.list
```

```bash
apt update
apt -y install postgresql-13 postgresql-client-13
```

## Настройка пользователей

### Postgres user

```bash
psql -U postgres
```

```psql
ALTER USER postgres PASSWORD 'postgres';
```

### Extension для сбора аналитики

*track planning and execution statistics of all SQL statements executed*

```psql
SELECT * FROM pg_available_extensions 
WHERE name = 'pg_stat_statements' AND 
  installed_version IS NOT NULL;
```

Если результат запроса - пустая таблица, то надо исполнить:

```psql
CREATE EXTENSION pg_stat_statements;
```

### Extension для улучшенного поиска

*text similarity measurement and index searching based on trigrams*

```psql
SELECT * FROM pg_available_extensions 
WHERE name = 'pg_trgm' AND 
  installed_version IS NOT NULL;
```

Если результат запроса - пустая таблица, то надо исполнить:

```psql
CREATE EXTENSION pg_trgm;
```

### Extension для cross-db запросов

*connect to other PostgreSQL databases from within a database*

```psql
SELECT * FROM pg_available_extensions 
WHERE name = 'dblink' AND 
  installed_version IS NOT NULL;
```

Если результат запроса - пустая таблица, то надо исполнить:

```psql
CREATE EXTENSION dblink;
```

## Настройка конфигов

### Конфиг

Рассчитать настройки используя [pgtune](https://pgtune.leopard.in.ua/#/) и вставить в файл `02-postgresql/conf/custom.conf`

1. Конфиг для ресурсов. Скопировать `02-postgresql/conf/custom.conf` в `/etc/postgresql/13/main/conf.d`
2. Конфиг для аналитики. Скопировать `02-postgresql/conf/statements.conf` в `/etc/postgresql/13/main/conf.d`
3. Конфиг для таймзоны. Скопировать `02-postgresql/conf/time.conf` в `/etc/postgresql/13/main/conf.d`
3. Конфиг для журналов. Скопировать `02-postgresql/conf/wal.conf` в `/etc/postgresql/13/main/conf.d`

### Шаблон БД

*Надо удостовериться что создаваемые БД будут в кодировке `UTF-8`, для этого достаточно зайти в постгрес и посмотреть список БД и их кодировки*

```bash
su - postgres

psql -U postgres
```

```psql
\l
```

*Если у БД с названиями `template0` и `template1` кодировка `UTF-8`, то все ок, а если нет, то надо её изменить следующим образом*

```sql
update pg_database set datallowconn = TRUE where datname = 'template0';
update pg_database set datistemplate = FALSE where datname = 'template1';

drop database template1;
create database template1 with template = template0 encoding = 'UTF8' lc_ctype = 'en_US.UTF-8' lc_collate = 'en_US.UTF-8';

update pg_database set datistemplate = TRUE where datname = 'template1';
update pg_database set datallowconn = FALSE where datname = 'template0';
```

### Шаблон БД - Способ 2

**Способ требует переустановки PostgreSQL**

список доступных локалей:

```bash
locale -a
```

отредактировать `nano /etc/default/locale`:

```conf
LANG="en_US.utf8"
LANGUAGE="en_US.utf8"
LC_ALL="en_US.utf8"
```

перезапустить сервер:

```bash
reboot
```

удалить PostgreSQL: 

```bash
apt -y remove postgresql-13 postgresql-client-13

apt -y purge postgresql-13 postgresql-client-13
```

вернутся к пункту с установкой.

### Таймзона

*В конфигах для постгреса указано, что таймзона должна быть `UTC`, но это может оверрайдиться таймзоной системы и её возможно так же нужно изменить на `UTC`, после чего перезапустить сервер*

```bash
cp /usr/share/zoneinfo/UTC /etc/localtime
```

перезапустить сервер:

```bash
reboot
```

## Очистка WAL

### Скриптом (найден на просторах интернета)

Скопировать скрипт для создания бэкапа `02-postgresql/scripts/clean-pg_wal.sh` в `/var/lib/postgresql/clean-pg_wal.sh`

*Скриптам необходимо выдать права на запуск*

```bash
chmod +x /var/lib/postgresql/clean-pg_wal.sh
```

Пример запуска:

```bash
/var/lib/postgresql/clean-pg_wal.sh -p /var/lib/postgresql/13/main/pg_wal -a ${DAYS_COUNT} -d
```

### В ручную

Эта команда выведет информацию о кластере:

```bash
/usr/lib/postgresql/13/bin/pg_controldata -D /var/lib/postgresql/13/main
```

Пример вывода:

```bash
Номер версии pg_control:              1300
Номер версии каталога:                202007201
Идентификатор системы баз данных:     7212239371412468712
Состояние кластера БД:                в работе
Последнее обновление pg_control:      Вт 11 апр 2023 11:34:51
Положение последней конт. точки:      0/609DD00
Положение REDO последней конт. точки: 0/609DCC8
Файл WAL c REDO последней к. т.:      000000010000000000000006
...
```

В поле `Файл WAL c REDO последней к. т.:` значение текущего WAL .

Далее используя команду можно удалить все WAL, кроме текущего:

```bash
/usr/lib/postgresql/13/bin/pg_archivecleanup -d /var/lib/postgresql/13/main/pg_wal/ ${WAL_HASH}
```
