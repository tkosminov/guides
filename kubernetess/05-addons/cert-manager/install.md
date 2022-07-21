# [cert manager](https://cert-manager.io/docs/installation/helm/)

## Установка

```bash
helm repo add jetstack https://charts.jetstack.io

helm install cert-manager jetstack/cert-manager --namespace kube-system --set installCRDs=true
```

## Настройка

Изменить `email` в файле `05-addons/cert-manager/issuer.yaml`

```bash
kubectl apply -f issuer.yaml
```
