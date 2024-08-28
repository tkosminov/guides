# [Node Exporter](https://github.com/prometheus/node_exporter)

## Установка

### Установка с гита

```bash
apt update
apt -y install wget curl vim
```

```bash
mkdir -p /tmp/node_exporter && cd /tmp/node_exporter && curl -L $(curl -s https://api.github.com/repos/prometheus/node_exporter/releases/latest | grep browser_download_url | grep linux-amd64 | cut -d '"' -f 4 | head -n 1) | tar xzf -
```

```bash
cd node_exporter*/

mv node_exporter /usr/local/bin/
```

```bash
cd /tmp && rm -r ./node_exporter
```

### Создание директорий и конфигов

```bash
mkdir -p /opt/node_exporter && cd /opt/node_exporter
```

* Скопировать файл `monitoring/node_exporter/node_exporter.env` в папку `/opt/node_exporter/node_exporter.env`

### Создание сервиса для автозапуска

* Скопировать файл `monitoring/node_exporter/node_exporter.service` в папку `/etc/systemd/system/node_exporter.service`

### Запуск сервиса

```bash
systemctl daemon-reload
systemctl enable node_exporter
systemctl start node_exporter
```

## Dashboard

* [grafana](https://grafana.com/grafana/dashboards/11074)
