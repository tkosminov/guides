# addons

## Repositories

```bash
helm repo add stable https://charts.helm.sh/stable
```

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
```

## Настройка [ingress](https://kubernetes.github.io/ingress-nginx/deploy/#using-helm)

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

helm install ingress-nginx ingress-nginx/ingress-nginx --namespace kube-system
```

## Настройка [cert manager](https://cert-manager.io/docs/installation/helm/)

```bash
helm repo add jetstack https://charts.jetstack.io

helm install cert-manager jetstack/cert-manager --namespace kube-system --version v1.6.0 --set installCRDs=true
```

## Настройка [dashboard](https://github.com/kubernetes/dashboard)

```bash
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/

helm install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --namespace kube-system
```

### Если нужно открыть дэшборд в браузере вне контейнера:

```bash
kubectl get pods -n kube-system -l "app.kubernetes.io/name=kubernetes-dashboard,app.kubernetes.io/instance=kubernetes-dashboard" -o jsonpath="{.items[0].metadata.name}"

kubectl -n kube-system port-forward $POD_NAME 8443:8443
```

Dashboard будет доступен по ссылке:

`https://127.0.0.1:8443/#/login`
