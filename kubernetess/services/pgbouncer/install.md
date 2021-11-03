# [PGBouncer](https://github.com/wallarm/pgbouncer-chart)

## Установка

### Chart

В `values.yaml` указать пользователя в `config.userlist`

```bash
cd chart

helm install pgbouncer .
```

### Host

`pgbounbcer.default.svc.cluster.local`

### Подключение через баунсер

```bash
psql -p 6432 -U postgres -h pgbouncer.default.svc.cluster.local
```
