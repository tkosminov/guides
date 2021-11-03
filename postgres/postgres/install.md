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

### Postgres user

```bash
psql -U postgres
```

```psql
ALTER USER postgres PASSWORD 'postgres';
```

### Юзер для pgbouncer метрики

```psql
CREATE USER stats WITH ENCRYPTED PASSWORD 'stats';
```

### PG Stat

```psql
SELECT * FROM pg_available_extensions 
WHERE name = 'pg_stat_statements' AND 
  installed_version IS NOT NULL;
```

Если результат запроса - пустая таблица, то надо исполнить:

```psql
CREATE EXTENSION pg_stat_statements;
```

## Настройка

### Конфиг

Рассчитать настройки используя [pgtune](https://pgtune.leopard.in.ua/#/) и вставить в файл `postgres/conf/custom.conf`

скопировать `postgres/conf/custom.conf` в `/etc/postgresql/13/main/conf.d`
скопировать `postgres/conf/statements.conf` в `/etc/postgresql/13/main/conf.d`

### Дефолтный шаблон постгрес

Это нужно чтобы по деволту базы создавали в кодировке UTF8.

```bash
su - postgres
psql -U postgres
```

```sql
update pg_database set datallowconn = TRUE where datname = 'template0';
update pg_database set datistemplate = FALSE where datname = 'template1';

drop database template1;
create database template1 with template = template0 encoding = 'UTF8' lc_ctype = 'en_US.UTF-8' lc_collate = 'en_US.UTF-8';

update pg_database set datistemplate = TRUE where datname = 'template1';
update pg_database set datallowconn = FALSE where datname = 'template0';
```

### Таймзона

Отредактируйте файл `/etc/postgresql/13/main/postgresql.conf`

```conf
log_timezone = 'UTC'
timezone = 'UTC'
```

Возможно понадобиться изменить таймзону всей системы с последующей перезагрузкой сервера

```bash
cp /usr/share/zoneinfo/UTC /etc/localtime

reboot
```
