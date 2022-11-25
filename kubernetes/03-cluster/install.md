# [cluster](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/)

## Установка

### Файл подкачки

Необходимо отключить [файл подкачки](../../common/swap.md)

### Создание кластера

```bash
kubeadm init --pod-network-cidr=10.244.0.0/16 --node-name ${название_мастер_ноды}
```

Сохраните запись kubeadm join команды, которую выведет kubeadm init. (Это нужно для присоединения slave нод) Пример:

```bash
kubeadm join ${ip:port} --token ${token} ----discovery-token-ca-cert-hash ${ca}
```

Повторно создать токен для добавления salve-ноды можно командой:

```bash
kubeadm token create --print-join-command
```

Чтобы использовать кластер выполните команду:

```bash
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# Или вставьте эту строку в .zshrc или в .bashrc
# export KUBECONFIG=/etc/kubernetes/admin.conf
```

### Если необходимо ставить поды на мастер ноду

```bash
kubectl taint nodes --all node-role.kubernetes.io/master-
```

### Настройка сети для подов

**`Выбрать одно из:`**

* flannel dns (`предпочтительнее`):
   ```bash
   kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
   ```
* weave dns:
   ```bash
   kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
   ```

### Если необходимо заменить dns

* Установить новый dns
* Удалить старый dns
* перезапустить `kubelet` на каждой node:
  ```bash
  systemctl restart kubelet
  ```

### Создание сервисного аккаунта

Шаблоны находятся в папке `03-cluster/roles`

Переходим в папку с шаблоном и выполняем:

```bash
kubectl apply -f ${ROLE_FILE}
```

Если нужно получить токен для доступа через дэшборд или апи:

```cubectl
kubectl get secrets

kubectl describe secret ${ROLE_SERVICE_ACCOUNT}-token-${RANDOM_HASH}
```

### Если нужно получить доступ к поду снаружи

1. Можно сделать прокси для сервиса:
   ```bash
   kubectl -n $NAMESPACE port-forward $POD_NAME $EXTERNAL_PORT:$INTERNAL_PORT
   ```
2. Можно войти в контейнер:
   ```bash
   kubectl exec -it $POD_NAME sh
   ```

## Удаление кластера

```bash
kubeadm reset
```
