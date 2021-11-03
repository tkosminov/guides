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

### Логический бэкап

* Еженедельный логический бэкап (в 4 утра в воскресенье)
  ```bash
  echo "0 4 * * 6 /var/lib/postgresql/logical-backup.sh >> /var/log/postgresql/cron.log 2>&1" >> /var/spool/cron/crontabs/root
  ```

### Физический бэкап (wal-g)

* Ежедневный физический бэкап в 11 вечера
  ```bash
  echo "0 23 * * * /var/lib/postgresql/walg-backup-push.sh >> /var/log/postgresql/cron.log 2>&1" >> /var/spool/cron/crontabs/root
  ```
* Удаляем старые физические бэкапы из облака (в 4 утра каждый день)
  ```bash
  echo "0 4 * * * /var/lib/postgresql/walg-backup-delete.sh >> /var/log/postgresql/cron.log 2>&1" >> /var/spool/cron/crontabs/root
  ```

### Физический бэкап (pgbackrest)

* Ежедневный физический бэкап в 11 вечера
  ```bash
  echo "0 23 * * * /var/lib/postgresql/pgbackrest-backup-push.sh >> /var/log/postgresql/cron.log 2>&1" >> /var/spool/cron/crontabs/root
  ```

### Права

```bash
chown root: /var/spool/cron/crontabs/root
chmod 600 /var/spool/cron/crontabs/root
```
