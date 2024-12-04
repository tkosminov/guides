# [PostgreSQL](https://github.com/bitnami/charts/tree/master/bitnami/postgresql)

## Установка

### PV and PVC

Указать размер хранилища в поле `storage` в файле `postgresql-pv.yaml`

```bash
kubectl create -f postgresql-pv.yaml
```

### Chart

```bash
helm install postgresql oci://registry-1.docker.io/bitnamicharts/postgresql --set global.postgresql.postgresqlPassword=postgres \
                                                                            --set global.postgresql.postgresqlUsername=postgres \
                                                                            --set image.tag=13.4.0-debian-10-r79 \
                                                                            --set persistence.existingClaim=postgresql-pv-claim \
                                                                            --set volumePermissions.enabled=true
```

### Host

`postgresql.default.svc.cluster.local`
