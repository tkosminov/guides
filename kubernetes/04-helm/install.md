# [helm](https://helm.sh/docs/intro/install/)

## Дополнительные пакеты

```bash
apt-get update
```

```bash
apt-get install apt-transport-https \
                curl
```

## Установка

```bash
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

apt-get update

apt-get install helm
```

## Настройка

### Базовые репозитории чартов

```bash
helm repo add stable https://charts.helm.sh/stable
```

## Полезные команды

### Скачать чарт

```bash
helm pull ${REPO_NAME}/${CHART_NAME} --untar
```

### Посмотреть values.yaml установленного чарта

```bash
helm -n ${NAMESPACE} get values ${CHART_NAME}
```

### Посмотреть values.yaml не установленного чарта

```bash
helm show values ${CHART_NAME}
```
