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

### Добавление настроек соединения с базой данных

```ini
[databases]
* = host=localhost port=5432

listen_addr = 0.0.0.0
listen_port = 6432

auth_type = md5
auth_file = /etc/pgbouncer/userlist.txt

stats_users = postgres

pool_mode = transaction

ignore_startup_parameters = extra_float_digits

max_client_conn = 1000
default_pool_size = 100

server_lifetime = 600
server_idle_timeout = 300
```

### Настраиваем вход по md5

Получаем список пользователей и их пароли в md5

```bash
su - postgres

psql -qAtX -F ' ' -U postgres -c 'select rolname, rolpassword from pg_authid'
```

Пример вывода:

```log
postgres md5...
```

Редактируем файл с паролями:

```bash
nano -w /etc/pgbouncer/userlist.txt
```

Указываем в нем юзера и его md5-хэш

```txt
"postgres" "md5..."
```

### После изменения настроек необходимо сделать рестарт сервиса

```bash
systemctl restart pgbouncer
```

Проверить что все работает можно командой

```bash
psql -h localhost -p 6432 -U postgres
```

### Для проектов на рельсах

Надо отключить дефолтный пуллер рельсов и локи для транзакций

#### RoR 6+

надо в конфиг бд добавить строки

```yaml
prepared_statements: false
advisory_locks: false
```

#### RoR 5-

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
