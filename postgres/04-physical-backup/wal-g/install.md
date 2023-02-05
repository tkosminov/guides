# [wal-g](https://github.com/wal-g/wal-g)

## Установка

```bash
apt install curl liblzo2-dev

cd /usr/local/bin && curl -L $(curl -s https://api.github.com/repos/wal-g/wal-g/releases/latest | grep browser_download_url | grep pg-ubuntu-20.04-amd64.tar.gz | cut -d '"' -f 4 | head -n 1) | tar xzf -

mv wal-g-pg-ubuntu-20.04-amd64 wal-g
```

Если у wal-g возникают ошибки типа `/lib/x86_64-linux-gnu/libm.so.6: version 'GLIBC_x.xx' not found` попробуй скачать версию под другую версию ОС, т.е., например, не под 20.04, а для 18.04 или для 22.04 - зависит от того требуется версия ниже или выше чем у вас.

Свою версию `'GLIBC_x.xx'` можно узнать командой `ldd --version`

## Настройка

### Конфиг постгреса

Скопировать конфиг для постгреса `04-physical-backup/wal-g/conf/walg.conf` в папку `/etc/postgresql/13/main/conf.d/walg.conf`

Перезапустить постгрес

```bash
service postgresql restart
```

### Шифрование

#### Установка

```bash
apt install gnupg rng-tools
```

#### Создаем ключ

```bash
gpg --gen-key
```

Вводим следущие данные:
* Выше полное имя: 'PostgreSQL Server'
* Адрес электронной почты: ''
* Фраза-пароль: ''

*Ключ выдается на 2 года*

#### Посмотреть список ключей

```bash
gpg --list-keys
gpg --list-secret-keys
gpg --list-public-keys
```

#### Экспорт ключей в файлы

*Ключи хранятся в папке `/root/.gnupg`*

```bash
gpg --armor --output /var/lib/postgresql/.pubkey.txt --export ${KEY_ID}
gpg --armor --output /var/lib/postgresql/.privkey.txt --export-secret-keys ${KEY_ID}
```

*Экспортированным ключам необходимо выдать права для того чтобы `postgres` могу их читать*

```bash
chown postgres: /var/lib/postgresql/.pubkey.txt
chown postgres: /var/lib/postgresql/.privkey.txt
```

*Ключи все еще остаются зашиврованными фразой-паролем*

### Конфиг wal-g

#### Для создания бэкапов

*Необходимо отредактировать файл `04-physical-backup/wal-g/conf/.walg.json`*

*Для `создания` бэкапов используется `публичный` ключ шифрования, так же указываем данные для s3 и фразу пароль для ключа*

```json
{
  "WALG_PGP_KEY_PATH": "/var/lib/postgresql/.pubkey.txt",
  "WALG_PGP_KEY_PASSPHRASE": "",
  "AWS_ACCESS_KEY_ID": "",
  "AWS_SECRET_ACCESS_KEY": "",
  "WALG_S3_PREFIX": ""
}
```

Скопировать файл `04-physical-backup/wal-g/conf/.walg.json` в папку `/var/lib/postgresql/.walg.json`

*Этому конфигу так же нужно выдать права для `postgres`*

```bash
chown postgres: /var/lib/postgresql/.walg.json
```

#### Для восстановления из бэкапа

*Необходимо отредактировать файл `04-physical-backup/wal-g/conf/.walg-restore.json`*

*Для `восстановления` из бэкапа используется `приватный` ключ шифрования, так же указываем данные для s3 и фразу пароль для ключа*

```json
{
  "WALG_PGP_KEY_PATH": "/var/lib/postgresql/.privkey.txt",
  "WALG_PGP_KEY_PASSPHRASE": "",
  "AWS_ACCESS_KEY_ID": "",
  "AWS_SECRET_ACCESS_KEY": "",
  "WALG_S3_PREFIX": ""
}
```

Скопировать файл `04-physical-backup/wal-g/conf/.walg-restore.json` в папку `/var/lib/postgresql/.walg-restore.json`

*Этому конфигу так же нужно выдать права для `postgres`*

```bash
chown postgres: /var/lib/postgresql/.walg-restore.json
```

### Скрипты

* Скопировать скрипт для создания бэкапа `04-physical-backup/wal-g/scripts/walg-backup-push.sh` в `/var/lib/postgresql/walg-backup-push.sh`
* Скопировать скрипт восстановления из последнего бэкапа `04-physical-backup/wal-g/scripts/walg-backup-fetch.sh` в `/var/lib/postgresql/walg-backup-fetch.sh`
* Скопировать скрипт для удаления устаревших бэкапов (7+ дней) `04-physical-backup/wal-g/scripts/walg-backup-delete.sh` в `/var/lib/postgresql/walg-backup-delete.sh`
* Скопировать скрипт для удаления устаревших бэкапов (7+ дней), этот скрипт так же запускает создание логического и физического бэкапа `04-physical-backup/wal-g/scripts/walg-backup-weekly-delete.sh` в `/var/lib/postgresql/walg-backup-weekly-delete.sh`

*Скриптам необходимо выдать права на запуск*

```bash
chmod +x /var/lib/postgresql/walg-backup-push.sh
chmod +x /var/lib/postgresql/walg-backup-fetch.sh
chmod +x /var/lib/postgresql/walg-backup-delete.sh
chmod +x /var/lib/postgresql/walg-backup-weekly-delete.sh
```

### Команды

#### Список бэкапов

```bash
/usr/local/bin/wal-g backup-list --config /var/lib/postgresql/.walg.json
```

#### Создать бэкап

```bash
/usr/local/bin/wal-g backup-push /var/lib/postgresql/13/main --config /var/lib/postgresql/.walg.json
```

#### Удалить бэкапы старше 7-и дней

```bash
/usr/local/bin/wal-g delete before FIND_FULL \$(date -d '-7 days' '+\\%FT\\%TZ') --config /var/lib/postgresql/.walg.json --confirm
```

#### Восстановиться из последнего бэкапа

```bash
/usr/local/bin/wal-g backup-fetch /var/lib/postgresql/13/main LATEST --config /var/lib/postgresql/.walg-restore.json
```
