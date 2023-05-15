# [Ingress-Nginx](https://github.com/kubernetes/ingress-nginx)

## Установка 

Добавляем репозитория:

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
```

Скачиваем чарт:

```bash
helm pull ingress-nginx/ingress-nginx --untar
```

Редактируем `values.yaml`:

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

Устанавливаем чарт:

```bash
helm install ingress-nginx ingress-nginx/ingress-nginx  --namespace kube-system \
                                                        -f ./values.yaml
```
