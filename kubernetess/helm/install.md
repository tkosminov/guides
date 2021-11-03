# [helm](https://helm.sh/docs/intro/install/)

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
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
```

```bash
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
```

### Докер

```bash
apt-get update
```

```bash
apt-get install helm
```

### Настрйока helm

```bash
kubectl apply -f tiller.yaml

helm init --service-account tiller
```
