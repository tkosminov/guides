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

| Поле        | Допустимые значения                     |
| ----------- | :-------------------------------------: |
| минута      | 0–59                                    |
| час         | 0–23                                    |
| день месяца | 1–31                                    |
| месяц       | 1–12 или ЯНВ–ДЕК                        |
| день недели | 0–7 или ((1-7 ПНД–ВСК) и (0 - ВСК))     |

## wal-g (опционально)

* Ежедневный физический бэкап (в 21 вечера по UTC, кроме воскресенья)
  ```bash
  echo "0 21 * * 1-6 /var/lib/postgresql/walg-backup-push.sh >> /var/log/postgresql/cron.log 2>&1" >> /var/spool/cron/crontabs/root
  ```
* Удаляем старые физические бэкапы из облака и создаем новый логический и физический бэкап (в 21 вечера в воскресенье по UTC)
  ```bash
  echo "0 21 * * 7 /var/lib/postgresql/walg-backup-weekly-delete.sh >> /var/log/postgresql/cron.log 2>&1" >> /var/spool/cron/crontabs/root
  ```

## pgbackrest (опционально)

* Ежедневный физический бэкап (в 21 вечера по UTC, кроме воскресенья)
  ```bash
  echo "0 21 * * 1-6 /var/lib/postgresql/pgbackrest-backup-push.sh >> /var/log/postgresql/cron.log 2>&1" >> /var/spool/cron/crontabs/root
  ```
* Удаляем старые физические бэкапы из облака и создаем новый логический и физический бэкап (в 21 вечера в воскресенье по UTC)
  ```bash
  echo "0 21 * * 7 /var/lib/postgresql/pgbackrest-backup-weekly-delete-node.sh >> /var/log/postgresql/cron.log 2>&1" >> /var/spool/cron/crontabs/root
  ```

## логические бэкапы (опционально)

* Ежемесячная чистка бэкапов (в 21 вечера по UTC, 1-го числа каждого месяца)
  ```bash
  echo "0 21 1 * * /var/lib/postgresql/logical-backup-monthly-delete.sh >> /var/log/postgresql/cron.log 2>&1" >> /var/spool/cron/crontabs/root
  ```

## чистка старых wal журналов (опционально)

* Ежедневная очистка журналов (в 21 вечера по UTC) старше 14 дней.

```bash
echo "0 21 * * * /var/lib/postgresql/clean-pg_wal.sh -p /var/lib/postgresql/13/main/pg_wal -a 14 -d >> /var/log/postgresql/cron.log 2>&1" >> /var/spool/cron/crontabs/root
```
