# [Postgres Exporter](https://github.com/prometheus-community/postgres_exporter)

## Установка

### Установка с гита

```bash
apt update
apt -y install wget curl vim
```

```bash
mkdir -p /tmp/postgres_exporter && cd /tmp/postgres_exporter && curl -L $(curl -s https://api.github.com/repos/prometheus-community/postgres_exporter/releases/latest | grep browser_download_url | grep linux-amd64 | cut -d '"' -f 4 | head -n 1) | tar xzf -
```

```bash
cd postgres_exporter*/

mv postgres_exporter /usr/local/bin/
```

```bash
cd /tmp && rm -r ./postgres_exporter
```

### Создание директорий и конфигов

```bash
mkdir -p /opt/postgres_exporter && cd /opt/postgres_exporter
```

* Скопировать файл `monitoring/postgres_exporter/postgres_exporter.env` в папку `/opt/postgres_exporter/postgres_exporter.env`
* Скопировать файл `monitoring/postgres_exporter/queries.yaml` в папку `/opt/postgres_exporter/queries.yaml`

### Создание сервиса для автозапуска

* Поменять в файле `monitoring/postgres_exporter/postgres_exporter.service` авторизационные данные
* Скопировать файл `monitoring/postgres_exporter/postgres_exporter.service` в папку `/etc/systemd/system/postgres_exporter.service`

### Запуск сервиса

```bash
systemctl daemon-reload
systemctl enable postgres_exporter
systemctl start postgres_exporter
```

### Grafana dashboard

Импортируем `monitoring/postgres_exporter/grafana_dashboard.json` в графану через `Import via panel json` на странице иморта бордов.

Далее заходим в созданую борду и для каждой панели меняем источник данных на свой.
