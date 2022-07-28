# [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)

## Установка

### Дополнительные пакеты

```bash
apt-get update
```

```bash
apt-get install apt-transport-https \
                curl
```

### Ключ и репозиторий

```bash
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
```

```bash
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
```

### Пакеты

```bash
apt-get update
```

```bash
apt-get install kubelet kubeadm kubectl
```
