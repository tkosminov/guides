# [ingress](https://kubernetes.github.io/ingress-nginx/deploy/#using-helm)

## Установка 

### Скачиваем чарт

```bash
helm pull ingress-nginx/ingress-nginx --untar
```

### Редактируем values.yaml:

```yaml
controller:
  ...
  hostNetwork: true
  dnsPolicy: ClusterFirstWithHostNet
  kind: DaemonSet
  config:
    - enable-underscores-in-headers: true
```

### Устанавливаем chart

```bash
helm install ingress-nginx ingress-nginx/ingress-nginx  --namespace kube-system \
                                                        -f ./values.yaml
```

<!-- ### LoadBalancer "pending"

Возможно надо указать externalIPs.

Для этого надо изменить сервис ingress-nginx-controller:

```yml
spec:
  type: LoadBalancer
  externalIPs:
    - 192.168.0.10
``` -->
