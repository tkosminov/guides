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
  ...
  dnsPolicy: ClusterFirstWithHostNet
  ...
  kind: DaemonSet
  ...
  allowSnippetAnnotations: true
  ...
  config:
    enable-underscores-in-headers: true
  ...
  addHeaders:
    X-Frame-Options: "SAMEORIGIN"
```

Устанавливаем чарт:

```bash
helm install ingress-nginx ingress-nginx/ingress-nginx  --namespace kube-system \
                                                        -f ./values.yaml
```

## Патч sysctl

```bash
kubectl patch ds -n kube-system ingress-nginx-controller \
                                --type strategic \
                                --patch-file ./ingress-nginx-sysctl-patch.json
```

ingress-nginx-sysctl-patch.json:

```json
{
  "spec": {
    "template": {
      "spec": {
        "initContainers": [
          {
            "name": "sysctl",
            "image": "alpine:$ALPINE_VERSION",
            "securityContext": {
              "privileged": true
            },
            "command": [
              "sh",
              "-c",
              "sysctl -w net.core.somaxconn=65535; sysctl -w net.ipv4.ip_local_port_range='1024 65000'; sysctl -w net.ipv4.tcp_tw_reuse=1"
            ]
          }
        ]
      }
    }
  }
}
```

`$ALPINE_VERSION` можно посмотреть внутри контейнера `ingress-nginx-controller`:

```bash
cat /etc/alpine-release
```
