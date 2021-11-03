# [cert manager](https://cert-manager.io/docs/installation/helm/)

## Установка

```bash
helm repo add jetstack https://charts.jetstack.io

helm install cert-manager jetstack/cert-manager --namespace kube-system --version v1.6.0 --set installCRDs=true
```

## Настройка

Изменить `email` в файле `addons/cert-manager/issuer.yaml`

```bash
kubectl apply -f issuer.yaml
```
