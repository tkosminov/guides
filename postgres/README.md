# Установка PostgreSQL 13 со всеми необходимыми компонентами

## Порядок установки

1. [nodejs](01-nodejs/install.md)
2. [postgresql](02-postgresql/install.md)
3. [base-sh-config](03-base-sh-config/install.md)
4. physical-backup
    1. [pgbackrest](04-physical-backup/pgbackrest/install.md) - используем это
    2. [wal-g](04-physical-backup/wal-g/install.md)
5. [logical-backup](05-logical-backup/install.md)
6. [cron](06-cron/install.md)
7. pooler
    1. [pgbouncer](07-pooler/pgbouncer/install.md) - используем это
    2. [odyssey](07-pooler/odyssey/install.md)
8. [k8s](08-k8s/install.md)
9. monitoring
    1. [postgres_exporter](../monitoring/postgres_exporter/install.md)
    2. [pgbouncer_exporter](../monitoring/pgbouncer_exporter)
    3. [node_exporter](../monitoring/node_exporter/install.md)
    4. [prometheus](../monitoring/prometheus/install.md)
    5. [grafana](../monitoring/grafana/install.md)
