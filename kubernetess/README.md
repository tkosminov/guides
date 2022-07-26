# Kubernetes

## OS

Ubuntu 20.04+

## Порядок установки

1. [kubectl](01-kubectl/install.md)
2. container-runtime (выберите одно)
   1. [docker](02-container-runtime/docker/install.md)
   2. [containerd](02-container-runtime/containerd/install.md)
3. [cluster](03-cluster/install.md)
4. [helm](04-helm/install.md)
5. addons
   1. [ingress](05-addons/ingress/install.md)
   2. [cert-manager](05-addons/cert-manager/install.md)
   3. [dashboard](05-addons/dashboard/install.md)
   4. [kube-prometheus-stack](05-addons/kube-prometheus-stack/install.md)
6. services
   1. [postgres](06-services/postgresql/install.md)
   2. [pgbouncer](06-services/pgbouncer/install.md)
   3. [redis](06-services/redis/install.md)
   4. [rabbitmq](06-services/rabbitmq/install.md)

## Полезные ссылки

[kubectl - Шпаргалка](https://kubernetes.io/ru/docs/reference/kubectl/cheatsheet/)
