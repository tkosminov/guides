# [Redis](https://github.com/bitnami/charts/tree/master/bitnami/redis)

## Установка

### PV and PVC

Указать размер хранилища в поле `storage` в файле `redis-pv.yaml`

```bash
kubectl create -f redis-pv.yaml
```

### Chart

```bash
helm install redis bitnami/redis --set global.redis.password=redis \
                                 --set image.tag=6.2.6-debian-10-r21 \
                                 --set master.persistence.enabled=true \
                                 --set master.persistence.existingClaim=redis-pv-claim \
                                 --set volumePermissions.enabled=true \
                                 --set replica.replicaCount=0
```

### Host

`redis.default.svc.cluster.local`
