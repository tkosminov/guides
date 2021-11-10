# [RabbitMQ](https://github.com/bitnami/charts/tree/master/bitnami/rabbitmq)

## Установка

### PV and PVC

Указать размер хранилища в поле `storage` в файле `rabbitmq-pv.yaml`

```bash
kubectl create -f rabbitmq-pv.yaml
```

### Chart

```bash
helm install rabbitmq bitnami/rabbitmq --set auth.username=admin \
                                       --set auth.password=admin \
                                       --set persistence.enabled=true \
                                       --set persistence.existingClaim=rabbitmq-pv-claim \
                                       --set volumePermissions.enabled=true
```

### Host

`rabbitmq.default.svc.cluster.local`

Если нужно открыть дэшборд в браузере вне контейнера:

### Dashboard

```bash
kubectl get pods -n default -l "app.kubernetes.io/name=rabbitmq,app.kubernetes.io/instance=rabbitmq" -o jsonpath="{.items[0].metadata.name}"

kubectl -n default port-forward $POD_NAME 15672:15672
```

Dashboard будет доступен по ссылке:

`http://127.0.0.1:15672`
