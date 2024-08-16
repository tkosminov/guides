# [RabbitMQ](https://github.com/bitnami/charts/tree/master/bitnami/rabbitmq)

## namespace

```bash
kubectl create namespace rabbitmq
```

## PV and PVC

Указать размер хранилища в поле `storage` в файле `rabbitmq-pv.yaml`

```bash
kubectl apply -f rabbitmq-pv.yaml
```

## Установка (На внешний сервер)

### Скачиваем чарт

```bash
helm pull bitnami/rabbitmq --untar
```

### Редактируем values.yaml:

Указываем данные юзера в auth:

```yaml
auth:
  ...
  username: ${USER_NAME}
  password: ${USER_PASSWORD}
```

Указываем данные домена в ingress:

```yaml
ingress:
  ...
  enabled: true
  ...
  hostname: rabbitmq.example.com
  ...
  annotations:
    nginx.ingress.kubernetes.io/force-ssl-redirect: “true”
    nginx.ingress.kubernetes.io/rewrite-target: "/"
    kubernetes.io/tls-acme: "true"
    cert-manager.io/cluster-issuer: cert-cluster-issuer
  ...
  tls: true
  ...
  ingressClassName: nginx
```

Указываем созданный pvc в persistence:

```yaml
persistence:
  ...
  enabled: true
  existingClaim: rabbitmq-pv-claim
```

Включаем volumePermissions:

```yaml
volumePermissions:
  ...
  enabled: true
```

Количество потоков и домен внутри кластера:

```yaml
image:
  ...
  maxAvailableSchedulers: 2
  onlineSchedulers: 1
  clusterDomain: cluster.local
```

Если сообщение долго обрабатывается, то происходит обрыв соединения с кроликом, чтобы этого не происходило надо исправить это следующим конфигом:

```yaml
advancedConfiguration: |-
  [ {rabbit, [ {consumer_timeout, undefined} ]} ].
```

### Добавляем плагин на отложенные сообщения (не обязательно), редактируем values.yaml:

*Важно! Версия плагина должна совпадать с версией rabbitmq*

```yaml
extraPlugins: "rabbitmq_auth_backend_ldap rabbitmq_delayed_message_exchange"

communityPlugins: https://github.com/rabbitmq/rabbitmq-delayed-message-exchange/releases/download/v3.13.0/rabbitmq_delayed_message_exchange-3.13.0.ez
```

* Чтобы сменить версию rabbitmq_delayed_message (**если необходимо**), замените ссылку в `communityPlugins` на другой релиз плагина, список которых можно посмотреть [тут](https://github.com/rabbitmq/rabbitmq-delayed-message-exchange/releases/)

```yaml
image:
  ...
  registry: docker.io
  repository: bitnami/rabbitmq
  tag: 3.10.2-debian-10-r11
```

* Чтобы сменить версию rabbitmq (**если необходимо**) надо поменять `tag`, список которых можно посмотреть [тут](https://hub.docker.com/r/bitnami/rabbitmq/tags)

### Устанавливаем chart

```bash
helm install rabbitmq bitnami/rabbitmq --namespace rabbitmq \
                                       -f ./values.yaml \
                                       --set nodeSelector."kubernetes\.io/hostname"=${название_ноды}
```

## Установка (Локально)

```bash
helm install rabbitmq bitnami/rabbitmq --namespace rabbitmq \
                                       --set auth.username=${USER_NAME} \
                                       --set auth.password=${USER_PASSWORD} \
                                       --set persistence.enabled=true \
                                       --set persistence.existingClaim=rabbitmq-pv-claim \
                                       --set volumePermissions.enabled=true \
                                       --set nodeSelector."kubernetes\.io/hostname"=${название_ноды}
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

## Полезные команды для кролика

Очистить все очереди:

```bash
rabbitmqctl list_queues --vhost vhost | awk '{ print $1 }' | xargs -L1 rabbitmqctl purge_queue --vhost vhost
```

Очистить очереди, в которых есть сообщения:

```bash
rabbitmqctl list_queues --vhost vhost | awk '$2!=0 { print $1 }' | xargs -L1 rabbitmqctl purge_queue --vhost vhost
```

Удалить очереди, в которых нету сообщений:

```bash
rabbitmqctl list_queues --vhost vhost | awk '$2==0 { print $1 }' | xargs -L1 rabbitmqctl delete_queue --vhost vhost
```
