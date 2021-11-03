# [ingress](https://kubernetes.github.io/ingress-nginx/deploy/#using-helm)

## Установка 

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

helm install ingress-nginx ingress-nginx/ingress-nginx --namespace kube-system
```
