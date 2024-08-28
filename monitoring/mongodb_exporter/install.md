# [MongoDB Exporter](https://github.com/percona/mongodb_exporter)

## Установка

### Установка с гита

```bash
apt update
apt -y install wget curl vim
```

```bash
mkdir -p /tmp/mongodb_exporter && cd /tmp/mongodb_exporter && curl -L $(curl -s https://api.github.com/repos/percona/mongodb_exporter/releases/latest | grep browser_download_url | grep linux-amd64 | cut -d '"' -f 4 | head -n 1) | tar xzf -
```

```bash
cd mongodb_exporter*/

mv mongodb_exporter /usr/local/bin/
```

```bash
cd /tmp && rm -r ./mongodb_exporter
```

### Создание директорий и конфигов

```bash
mkdir -p /opt/mongodb_exporter && cd /opt/mongodb_exporter
```

* Скопировать файл `monitoring/mongodb_exporter/mongodb_exporter.env` в папку `/opt/mongodb_exporter/mongodb_exporter.env`
* Прописать в нем логин и пароль

### Создание сервиса для автозапуска

* Скопировать файл `monitoring/mongodb_exporter/mongodb_exporter.service` в папку `/etc/systemd/system/mongodb_exporter.service`

### Запуск сервиса

```bash
systemctl daemon-reload
systemctl enable mongodb_exporter
systemctl start mongodb_exporter
```

## Dashboard

* [grafana](https://grafana.com/grafana/dashboards/20867-mongodb-dashboard/)
