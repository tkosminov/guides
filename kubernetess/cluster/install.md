# [cluster](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/)

## Установка

### Отключение файла подкачки

```bash
swapoff -a
```

### Создание и настройка кластера

#### Создать кластер

```bash
kubeadm init --pod-network-cidr=10.244.0.0/16 --node-name ${название_ноды}
```

Сохраните запись kubeadm join команды, которую выведет kubeadm init. (Это нужно для присоединения slave нод) Пример:

```bash
kubeadm join ${ip:port} --token ${token} ----discovery-token-ca-cert-hash ${ca}
```

Чтобы использовать кластер выполните команду:

```bash
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# Или вставьте эту строку в .zshrc или в .bashrc
# export KUBECONFIG=/etc/kubernetes/admin.conf
```

#### Если необходимо ставить поды на мастер ноду (для локального тестирования)

```bash
kubectl taint nodes --all node-role.kubernetes.io/master-
```

#### Настройка сети для подов (weave dns)

```bash
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
```

#### Создание сервисного аккаунта

```bash
kubectl create serviceaccount cluster-admin-sa

kubectl create clusterrolebinding cluster-admin-sa --clusterrole=cluster-admin --serviceaccount=default:cluster-admin-sa

kubectl get secrets

kubectl describe secret cluster-admin-sa-token-${random}
```

#### Если нужно получить доступ к поду снаружи

1. Можно сделать прокси для сервиса:
   ```bash
   kubectl -n $NAMESPACE port-forward $POD_NAME $EXTERNAL_PORT:$INTERNAL_PORT
   ```
2. Можно войти в контейнер:
   ```bash
   kubectl exec -it $POD_NAME sh
   ```

### Удаление кластера

```bash
kubeadm reset
```
