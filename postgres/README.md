# Установка PostgreSQL 13 со всеми необходимыми компонентами

## Порядок установки

1. [oh-my-zsh](01-oh-my-zsh/install.md)
2. [nodejs](02-nodejs/install.md)
3. [postgresql](03-postgresql/install.md)
4. [base-sh-config](004-base-sh-config/install.md)
5. physical-backup
    1. [pgbackrest](05-physical-backup/pgbackrest/install.md) - используем это
    2. [wal-g](05-physical-backup/wal-g/install.md)
6. [logical-backup](06-logical-backup/install.md)
7. [cron](07-cron/install.md)
8. pooler
    1. [pgbouncer](08-pooler/pgbouncer/install.md) - используем это
    2. [odyssey](08-pooler/odyssey/install.md)
9. monitoring
    1. [postgres_exporter](09-monitoring/postgres_exporter/install.md)
    2. [pgbouncer_exporter](09-monitoring/pgbouncer_exporter)
    3. [node_exporter](09-monitoring/node_exporter/install.md)
    4. [prometheus](09-monitoring/prometheus/install.md)
    5. [grafana](09-monitoring/grafana/install.md)
10. [firewall](10-firewall/install.md)
11. [atop](11-atop/install.md)
12. [login-notify](12-login-notify/install.md)
13. [k8s](13-k8s/install.md)
