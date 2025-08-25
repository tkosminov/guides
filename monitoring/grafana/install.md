# Grafana

## Установка

```bash
apt-get update
apt-get install -y apt-transport-https software-properties-common wget
```

```bash
mkdir -p /etc/apt/keyrings/

wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null

echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
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