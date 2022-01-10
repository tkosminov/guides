# Cron

## Установка

```bash
apt install cron

systemctl enable cron
```

## Настройка

### Создаем файл с задачами

```bash
touch /var/spool/cron/crontabs/root
```

### Памятка к cron

| Поле        | Допустимые значения |
| ----------- | :-----------------: |
| минута      | 0–59                |
| час         | 0–23                |
| день месяца | 1–31                |
| месяц       | 1–12 или ЯНВ–ДЕК    |
| день недели | 0–6 или ПНД–ВСК     |

## pgbackrest

* Ежедневный физический бэкап (в 21 вечера по UTC, кроме воскресенья)
  ```bash
  echo "0 21 * * 0-5 /var/lib/postgresql/pgbackrest-backup-push.sh >> /var/log/postgresql/cron.log 2>&1" >> /var/spool/cron/crontabs/root
  ```

* Удаляем старые физические бэкапы из облака и создаем новый логический и физический бэкап (в 21 вечера в воскресенье по UTC)
  ```bash
  echo "0 21 * * 6 /var/lib/postgresql/pgbackrest-backup-weekly-delete.sh >> /var/log/postgresql/cron.log 2>&1" >> /var/spool/cron/crontabs/root
  ```

## wal-g

* Еженедельный логический бэкап (в 9 вечера в воскресенье по UTC)
  ```bash
  echo "0 21 * * 6 /var/lib/postgresql/logical-backup.sh >> /var/log/postgresql/cron.log 2>&1" >> /var/spool/cron/crontabs/root
  ```
* Ежедневный физический бэкап (в 21 вечера по UTC)
  ```bash
  echo "0 21 * * * /var/lib/postgresql/walg-backup-push.sh >> /var/log/postgresql/cron.log 2>&1" >> /var/spool/cron/crontabs/root
  ```
* Удаляем старые физические бэкапы из облака (в 21 вечера в воскресенье по UTC)
  ```bash
  echo "0 21 * * 6 /var/lib/postgresql/walg-backup-delete.sh >> /var/log/postgresql/cron.log 2>&1" >> /var/spool/cron/crontabs/root
  ```

## Права

```bash
chown root: /var/spool/cron/crontabs/root
chmod 600 /var/spool/cron/crontabs/root
```
