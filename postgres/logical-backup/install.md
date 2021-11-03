# [PG_DUMP](https://postgrespro.ru/docs/postgresql/13/app-pgdump)

## Установка

### NodeJS

* [Установить nodejs](https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-20-04-ru)

* Скопировать папку `logical-backup/logical-upload` в `/var/lib/postgresql/logical-upload`
* Установить пакеты
  ```bash
  cd /var/lib/postgresql/logical-upload && npm i  
  ```

#### Необходимо узнать путь к бинарнику nodejs

* Если ставили нод через `apt install nodejs`:
  ```bash
  which nodejs
  ```
* Если ставили нод через `nvm`:
  ```bash
  which node
  ```

Далее в скрипте `logical-backup/scripts/logical-backup.sh` изменить строки 62 и 65, в которых используется node. Надо указать полный путь к бинарнику

### Скрипты

* Скопировать скрипт для создания бэкапа `logical-backup/scripts/logical-backup.sh` в `/var/lib/postgresql/logical-backup.sh`
* Скопировать скрипт для восстановления из бэкапа `logical-backup/scripts/logical-restore.sh` в `/var/lib/postgresql/logical-restore.sh`

#### Права

* Выдать права для запуска
  ```bash
  chmod +x /var/lib/postgresql/logical-backup.sh
  chmod +x /var/lib/postgresql/logical-restore.sh
  ```

#### Запуск

Заходим за рута

```bash
sudo -i
```

и вызываем скрипт, пример:

```bash
/var/lib/postgresql/logical-backup.sh
```

* Перед запуском скрипта на восстановление из бэкапа необходимо в папку `/tmp/backups` положить архив с бэкапами. Если папки нету, то создать её.
* Как скачать файл. Заходим в яндекс облако. Выбираем нужный файл. Получаем ссылку на него. И из под рута запускаем:

```bash
cd /tmp/backups

curl -L ${link}
```

## Настройка

* указать пароль (`PASSPHRASE`) для шифрования логических бэкапов в файле `/var/lib/postgresql/logical-backup.sh`. Если шифрование не нужно, то поставить флаг `ENCRYPT` в `false`
* указать пароль (`PASSPHRASE`) для расшифровки логических бэкапов в файле `/var/lib/postgresql/logical-restore.sh`. Если шифрование не требуется, то поставить флаг `DECRYPT` в `false`
* указать `s3` данные для логических бэкапов в файле `/var/lib/postgresql/logical-upload/s3.js`
