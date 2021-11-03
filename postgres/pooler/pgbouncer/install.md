# [PgBouncer](https://github.com/pgbouncer/pgbouncer)

## Установка

```bash
apt install pgbouncer

systemctl enable pgbouncer
```

## Настройка

```bash
nano -w /etc/pgbouncer/pgbouncer.ini
```

### Запускаем баунсер в локальной сети

```ini
listen_addr = 0.0.0.0
listen_port = 6432
```

### Настройка режима работы пула

```ini
pool_mode = transaction
```

### Настройка юзера для выгрузки статистики

```ini
stats_users = stats
```

### Настройка количества подключений и размер пула

```ini
max_client_conn = 1000
```

### Добавление настроек соединения с базой данных

```ini
[databases]
* = host=localhost port=5432
```

### Настройка параметров старта

```ini
ignore_startup_parameters = extra_float_digits
```

### Настройка типа аутентификации

```ini
auth_type = md5
auth_file = /etc/pgbouncer/userlist.txt
```

#### Узнаем пароль от дефолтного юзера

```bash
su - postgres

psql -qAtX -F ' ' -U postgres -c 'select rolname, rolpassword from pg_authid'
```

Пример вывода:
```log
postgres md5...
stats md5...
```

#### Редактируем файл с юзерами

```bash
nano -w /etc/pgbouncer/userlist.txt
```

Указываем в нем юзера с паролем

```txt
"postgres" "md5..."
"stats" "md5..."
```

Проверить что все работает можно командой

```bash
psql -h localhost -p 6432 -U postgres
```

#### Для проектов на рельсах

Надо отключить дефолтный пуллер рельсов и локи для транзакций

##### RoR 6+

надо в конфиг бд добавить строки

```yaml
prepared_statements: false
advisory_locks: false
```

##### RoR 5-

Создать файл `config/initializers/advisory_locks.rb`

```ruby
# https://help.heroku.com/UYH8N2WW/why-do-i-receive-activerecord-concurrentmigrationerror-when-running-rails-migrations-using-pgbouncer
# https://github.com/rails/rails/issues/31190

class ActiveRecord::Migrator
  def use_advisory_lock?
    false
  end
end
```

надо в конфиг бд добавить строки

```yaml
prepared_statements: false
```
