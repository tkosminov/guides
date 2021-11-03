# Grafana

## Установка

```bash
apt-get update
apt-get install -y apt-transport-https software-properties-common wget
```

```bash
wget -q -O - https://packages.grafana.com/gpg.key | apt-key add -
echo "deb https://packages.grafana.com/enterprise/deb stable main" | tee -a /etc/apt/sources.list.d/grafana.list
```

```bash
apt-get update
apt-get install grafana-enterprise
```

## Запуск сервиса

```bash
systemctl daemon-reload
systemctl enable grafana-server.service
systemctl start grafana-server
```