# [Odyssey](https://github.com/yandex/odyssey)

## Установка

```bash
cd /usr/bin && curl -L https://github.com/yandex/odyssey/releases/download/1.1/odyssey.linux-amd64.b7bcb86.tar.gz | tar xzf -
chmod a+x /usr/bin/odyssey
chown root:root /usr/bin/odyssey
```

## Настройка

### Создание пользователя и вспомогательных каталогов

```bash
groupadd --system odyssey
useradd --system --shell /sbin/nologin --gid odyssey --home-dir /var/lib/odyssey --no-create-home odyssey

mkdir /run/odyssey
chown -R odyssey:odyssey /run/odyssey
echo "d /run/odyssey 0755 odyssey odyssey - -" > /usr/lib/tmpfiles.d/odyssey.conf

mkdir /var/lib/odyssey
chown -R odyssey:odyssey /var/lib/odyssey

touch /var/log/odyssey.log
chown odyssey:odyssey /var/log/odyssey.log

mkdir /etc/odyssey
cd /etc/odyssey && curl -L https://raw.githubusercontent.com/yandex/odyssey/1.1/odyssey.conf
chmod 644 /etc/odyssey/odyssey.conf

cd /usr/lib/systemd/system && curl -L https://raw.githubusercontent.com/yandex/odyssey/1.1/scripts/systemd/odyssey.service
systemctl daemon-reload
systemctl enable odyssey
```

| `все поля конфига и их описание есть в самом конфиге.`

### Ограничиваем соединения только локалхостом

```bash
nano -w /etc/odyssey/odyssey.conf
```

```conf
listen {
  host "0.0.0.0"
  port 6432
}
```

### Настроим административную консоль для просмотра статистики.

| `в самом низу конфига`

```bash
nano -w /etc/odyssey/odyssey.conf
```

```conf
storage "local" {
  type "local"
}

database "console" {
  user default {
    authentication "none"
    pool "session"
    storage "local"
  }
}
```

Команда для теста (сначала надо запустить odyssey):

```bash
psql -p 6432 -d console
```

### Включим ведение лога

```bash
nano -w /etc/odyssey/odyssey.conf
```

```conf
log_file "/var/log/odyssey.log"

log_format "%p %t %l [%i %s] (%c) %m\n"
log_debug no
log_config yes
log_session no
log_query no
log_stats yes
```

### Настройка пользователя

#### Узнаем пароль от дефолтного пользователя

```bash
su - postgres

psql -qAtX -F ' ' -U postgres -c 'select rolname, rolpassword from pg_authid'
```

Пример вывода:
```log
postgres md5...
stats md5...
```

#### Изменяем конфиг

```conf
database default {
	user default {
		authentication "md5"

		storage "postgres_server"
		# storage_db "db"
		storage_user "postgres"
		storage_password "md5..."

		pool "transaction"

		client_fwd_error yes
	}
}
```

#### Для проектов на рельсах

надо в конфиг бд добавить строки

```yaml
prepared_statements: false
advisory_locks: false
```

т.к. надо отключить дефолтный пуллер рельсов

### Запуск

```bash
systemctl start odyssey
```

### Проверить что все работает можно командой

```bash
psql -h localhost -p 6432 -U postgres
```
