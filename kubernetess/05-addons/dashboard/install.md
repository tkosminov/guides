# [dashboard](https://github.com/kubernetes/dashboard)

## Установка

```bash
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/

helm install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --namespace kube-system
```

## Настройка

### Если нужно открыть дэшборд в браузере вне контейнера

1. В файлах `05-addons/dashboard/cert.yaml` изменить поля `commonName`, `dnsNames` на свой домен
2. В файле `05-addons/dashboard/ingress.yaml` изменить поле `host`, `hosts` на свой домен

```bash
kubectl apply -f cert.yaml
kubectl apply -f ingress.yaml
```

Файл `cert.yaml` можно не применять. `ingress.yaml` сам создаст сертификат с именем из `secretName`, если того не будет существовать.

### Если нужно открыть дэшборд в браузере вне контейнера (для локального тестирования):

```bash
kubectl get pods -n kube-system -l "app.kubernetes.io/name=kubernetes-dashboard,app.kubernetes.io/instance=kubernetes-dashboard" -o jsonpath="{.items[0].metadata.name}"

kubectl -n kube-system port-forward $POD_NAME 8443:8443
```

Dashboard будет доступен по ссылке:

`https://127.0.0.1:8443/#/login`
