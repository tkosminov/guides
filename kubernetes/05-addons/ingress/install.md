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
  ...
  addHeaders:
    X-Frame-Options: "SAMEORIGIN"
```

### Устанавливаем chart

```bash
helm install ingress-nginx ingress-nginx/ingress-nginx  --namespace kube-system \
                                                        -f ./values.yaml
```
