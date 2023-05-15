# [Ingress-Traefik](https://github.com/traefik/traefik-helm-chart)

## Установка

Добавляем репозитория:

```bash
helm repo add traefik https://traefik.github.io/charts
```

Скачиваем чарт:

```bash
helm pull traefik/traefik --untar
```

Редактируем `values.yaml`:

```yaml
deployment:
  ...
  kind: DaemonSet
  ...
  dnsPolicy: ClusterFirstWithHostNet
  ...
...
dashboard:
  enabled: true
...
hostNetwork: true
```

Устанавливаем чарт:

```bash
helm install traefik traefik/traefik  --namespace kube-system \
                                      -f ./values.yaml
```
