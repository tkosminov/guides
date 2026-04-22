# [docker](https://docs.docker.com/engine/install/ubuntu/)

## Установка

### Дополнительные пакеты

```bash
apt-get update
```

```bash
apt-get install apt-transport-https \
                curl \
                gnupg \
                lsb-release \
                ca-certificates
```

### Ключ и репозиторий

```bash
install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc

chmod a+r /etc/apt/keyrings/docker.asc
```

```bash
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF
```

```bash
apt update
```

### Пакеты

```bash
apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### Зеркала

Список актуальных зеркал docker hub (docker registry-mirrors):
* https://mirror.gcr.io - зеркало Google
* https://dockerhub.timeweb.cloud - зеркало Timeweb
* https://registry.docker-cn.com - зеркало Китай
* https://daocloud.io - зеркало Китай
* https://cr.yandex/mirror - зеркало Яндекс
* https://quay.io - зеркало Redhat
* https://registry.access.redhat.com - зеркало Redhat
* https://registry.redhat.io - зеркало Redhat
* https://public.ecr.aws - зеркало Amazon


```bash
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "registry-mirrors": [
    "https://mirror.gcr.io",
  ]
}
```

### Сервис

```bash
mkdir /etc/docker

cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "live-restore": true
}
EOF
```

```bash
systemctl enable docker
systemctl daemon-reload
systemctl restart docker
```
