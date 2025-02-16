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
sudo mkdir -p /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```

```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

### Пакеты

```bash
apt-get update
```

```bash
apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

curl -SL $(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep browser_download_url | grep linux-x86_64 | cut -d '"' -f 4 | head -n 1) -o /usr/local/bin/docker-compose

ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

chmod +x /usr/local/bin/docker-compose
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
