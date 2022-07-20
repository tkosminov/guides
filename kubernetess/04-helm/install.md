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

### Установка

```bash
apt-get update
```

```bash
apt-get install helm
```

## Установка через [helmenv](https://github.com/little-angry-clouds/kubernetes-binaries-managers/tree/master/cmd/helmenv)

### Установка

```bash
echo 'export PATH="$HOME/.bin:$PATH"' >> ~/.bashrc
# Or
echo 'export PATH="$HOME/.bin:$PATH"' >> ~/.zshrc

mkdir -p ~/.bin
```

```bash
mkdir -p /tmp/helm

cd /tmp/helm && curl -L $(curl -s https://api.github.com/repos/little-angry-clouds/kubernetes-binaries-managers/releases/latest | grep browser_download_url | grep -E 'kubernetes-binaries-managers_[0-9\.\-]+_linux_amd64.tar.gz' | cut -d '"' -f 4 | head -n 1) | tar xzf -

mv ./helm-linux-amd64/helmenv ~/.bin/helmenv
mv ./helm-linux-amd64/helm-wrapper ~/.bin/helm

cd /tmp && rm -r ./helm
```

### helm

```bash
helmenv install 3.9.1
helmenv use 3.9.1
```

## Настройка

### Базовые репозитории чартов

```bash
helm repo add stable https://charts.helm.sh/stable
```

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
```
