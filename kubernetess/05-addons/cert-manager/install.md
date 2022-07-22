# [cert manager](https://cert-manager.io/docs/installation/helm/)

## Установка

```bash
helm repo add jetstack https://charts.jetstack.io

helm install cert-manager jetstack/cert-manager --namespace kube-system \
                                                --set installCRDs=true \
                                                --set nodeSelector."kubernetes\.io/hostname"=${название_мастер_ноды} \
                                                --set webhook.nodeSelector."kubernetes\.io/hostname"=${название_мастер_ноды} \
                                                --set cainjector.nodeSelector."kubernetes\.io/hostname"=${название_мастер_ноды}
```

## Настройка

В файле `05-addons/cert-manager/issuer.yaml` изменить `email` и указать название мастер-ноды в `nodeSelector` 

```bash
kubectl apply -f issuer.yaml
```
