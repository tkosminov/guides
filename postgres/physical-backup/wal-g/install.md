# [WalG](https://github.com/wal-g/wal-g)

## Установка

```bash
apt install curl liblzo2-dev

cd /usr/local/bin && curl -L $(curl -s https://api.github.com/repos/wal-g/wal-g/releases/latest | grep browser_download_url | grep pg-ubuntu-18.04-amd64.tar.gz | cut -d '"' -f 4 | head -n 1) | tar xzf -

mv wal-g-pg-ubuntu-18.04-amd64 wal-g
```

## Настройка

### PostgreSQL Config

* Скопировать файл `physical-backup/wal-g/configs/walg.conf` в папку `/etc/postgresql/13/main/conf.d/walg.conf`
* Перезапустить постгрес
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

Ключ выдается на 2 года

#### Посмотреть список ключей

```bash
gpg --list-keys
gpg --list-secret-keys
gpg --list-public-keys
```

#### Экспорт ключей в файлы

Ключи хранятся в папке `/root/.gnupg`.

```bash
gpg --armor --output /var/lib/postgresql/pubkey.txt --export ${KEY_ID}
gpg --armor --output /var/lib/postgresql/privkey.txt --export-secret-keys ${KEY_ID}
```

Ключи все еще остаются зашиврованными фразой-паролем.

#### Wal-g

Исправляем файл `physical-backup/wal-g/configs/.walg.json`.

Добавляем туда:

```json
{
  "WALG_PGP_KEY_PATH": "/var/lib/postgresql/pubkey.txt",
  "WALG_PGP_KEY_PASSPHRASE": ""
}
```

Исправляем файл `physical-backup/wal-g/configs/.walg-restore.json`.

Добавляем туда:

```json
{
  "WALG_PGP_KEY_PATH": "/var/lib/postgresql/privkey.txt",
  "WALG_PGP_KEY_PASSPHRASE": ""
}
```

* Для создания бэкапа указываем `публичный` ключ, а для восстановления из бэкапа - `приватный`
* Не забываем указать `WALG_PGP_KEY_PASSPHRASE` в конфигах. Это Фраза-пароль, которая использовалась [при создании ключей](./install.md#Создаем%20ключ)

#### Права

```bash
chown postgres: /var/lib/postgresql/pubkey.txt
chown postgres: /var/lib/postgresql/privkey.txt
```

### WalG Config

* Скопировать файл `physical-backup/wal-g/configs/.walg.json` в папку `/var/lib/postgresql/.walg.json`
* Скопировать файл `physical-backup/wal-g/configs/.walg-restore.json` в папку `/var/lib/postgresql/.walg-restore.json`
* указать s3 данные для физических бэкапов в файле `/var/lib/postgresql/.walg.json`

#### Права

* Выдать права на файл с конфигом `.walg.json` для постгреса
  ```bash
  chown postgres: /var/lib/postgresql/.walg.json
  ```
* Выдать права на файл с конфигом `.walg-restore.json` для постгреса
  ```bash
  chown postgres: /var/lib/postgresql/.walg-restore.json
  ```

## Скрипты

### WalG Scripts

* Скопировать скрипт для создания бэкапа `physical-backup/wal-g/scripts/walg-backup-push.sh` в `/var/lib/postgresql/walg-backup-push.sh`
* Скопировать скрипт восстановления из последнего бэкапа `physical-backup/wal-g/scripts/walg-backup-fetch.sh` в `/var/lib/postgresql/walg-backup-fetch.sh`
* Скопировать скрипт для удаления устаревших бэкапов (30+ дней) `physical-backup/wal-g/scripts/walg-backup-delete.sh` в `/var/lib/postgresql/walg-backup-delete.sh`

#### Права

* Выдать права для запуска
  ```bash
  chmod +x /var/lib/postgresql/walg-backup-push.sh
  chmod +x /var/lib/postgresql/walg-backup-fetch.sh
  chmod +x /var/lib/postgresql/walg-backup-delete.sh
  ```

#### Запуск

Заходим за рута

```bash
sudo -i
```

и вызываем скрипт, пример:

```bash
/var/lib/postgresql/walg-backup-push.sh
```
