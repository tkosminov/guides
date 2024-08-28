# [Redis Exporter](https://github.com/oliver006/redis_exporter)

## Установка

### Установка с гита

```bash
apt update
apt -y install wget curl vim
```

```bash
mkdir -p /tmp/redis_exporter && cd /tmp/redis_exporter && curl -L $(curl -s https://api.github.com/repos/oliver006/redis_exporter/releases/latest | grep browser_download_url | grep linux-amd64 | cut -d '"' -f 4 | head -n 1) | tar xzf -
```

```bash
cd redis_exporter*/

mv redis_exporter /usr/local/bin/
```

```bash
cd /tmp && rm -r ./redis_exporter
```

### Создание директорий и конфигов

```bash
mkdir -p /opt/redis_exporter && cd /opt/redis_exporter
```

* Скопировать файл `monitoring/redis_exporter/redis_exporter.env` в папку `/opt/redis_exporter/redis_exporter.env`
* Прописать пароль в файле с энвами `/opt/redis_exporter/redis_exporter.env`

### Создание сервиса для автозапуска

* Скопировать файл `monitoring/redis_exporter/redis_exporter.service` в папку `/etc/systemd/system/redis_exporter.service`

### Запуск сервиса

```bash
systemctl daemon-reload
systemctl enable redis_exporter
systemctl start redis_exporter
```

## Dashboard

* [grafana](https://grafana.com/grafana/dashboards/763-redis-dashboard-for-prometheus-redis-exporter-1-x/)
