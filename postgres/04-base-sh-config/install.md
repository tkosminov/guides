# Base SH config

## Установка

*Это скрипт, в которым содержаться общие константы для другие скриптов*

*Если необходимо отправлять результаты в телегам, то необходимо дать значения переменным `TELEGRAM_TOKEN` и `TELEGRAM_CHAT_ID`, а так же `BACKUP_PROJECT_NAME` (но это необязательно)*

*Если необходимо шифровать логические бэкапы, то необходимо дать значения переменной `BACKUP_PASS_PHRASE`, а переменные `BACKUP_ENCRYPT` и `BACKUP_DECRYPT` установить в `true` (установите в `false` если шифрование не требуется, тогда пасс-фраза будет игнорироваться)*

Скопировать скрипт `00-base-sh-config/scripts/base-config.sh` в `/var/lib/postgresql/base-config.sh`

*Скриптам необходимо выдать права на запуск*

```bash
chmod +x /var/lib/postgresql/base-config.sh
```
