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

### Стабильная версия

```bash
STABLE_VERSION=$(curl -sL https://dl.k8s.io/release/stable.txt | cut -d '"' -f 4 | head -n 1)

MINOR_STABLE_VERSION=$(echo $STABLE_VERSION | awk -F "." '{print $1"."$2}')
```

### Ключ и репозиторий

```bash
curl -fsSL "https://pkgs.k8s.io/core:/stable:/${STABLE_VERSION}/deb/Release.key" | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
```

```bash
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/${MINOR_STABLE_VERSION}/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
```

### Пакеты

```bash
apt-get update
```

```bash
apt-get install kubelet kubeadm kubectl
```
