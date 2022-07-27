# [ingress](https://kubernetes.github.io/ingress-nginx/deploy/#using-helm)

## Установка 

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

helm install ingress-nginx ingress-nginx/ingress-nginx --namespace kube-system \
                                                       --set controller.hostNetwork=true \
                                                       --set controller.dnsPolicy=ClusterFirstWithHostNet \
                                                       --set controller.kind=DaemonSet \
                                                       --set-string controller.config."enable-underscores-in-headers"="true"
```

## Возможные решения некоторых проблем

### LoadBalancer "pending"

Возможно надо указать externalIPs.

Для этого надо изменить сервис ingress-nginx-controller:

```yml
spec:
  type: LoadBalancer
  externalIPs:
    - 192.168.0.10
```
