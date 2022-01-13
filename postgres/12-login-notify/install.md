# login-notify

Уведомления в телеграм о входе на сервер и выходе с сервера

## Установка

```bash
apt install jq
```

* Скопировать скрипт уведомления `12-login-notify/scripts/login-notify.sh` в `/usr/bin/login-notify.sh`

Указать в файле
* `TELEGRAM_TOKEN` - токен для телеграм бота
* `TELEGRAM_CHAT_ID` - id чата в телеграме
  
Заполнить переменную `users`, указать в нем IP сотрудников и их имена, пример:

```bash
users='{
  "127.0.0.1":"Test User"
}'
```

## Настройка

Выдать скрипту права на запуск

```bash
chmod +x /usr/bin/login-notify.sh
```

Добавить вызов скрипта 

```bash
echo "session    optional     pam_exec.so /usr/bin/login-notify.sh" >> /etc/pam.d/sshd
```

