# [PGBouncer Exporter](https://github.com/prometheus-community/pgbouncer_exporter)

## Установка

### Установка с гита

```bash
apt update
apt -y install wget curl vim
```

```bash
mkdir -p /tmp/pgbouncer_exporter && cd /tmp/pgbouncer_exporter && curl -L $(curl -s https://api.github.com/repos/prometheus-community/pgbouncer_exporter/releases/latest | grep browser_download_url | grep linux-amd64 | cut -d '"' -f 4 | head -n 1) | tar xzf -
```

```bash
cd pgbouncer_exporter*/

mv pgbouncer_exporter /usr/local/bin/
```

```bash
cd /tmp && rm -r ./pgbouncer_exporter
```

### Создание директорий и конфигов

```bash
mkdir -p /opt/pgbouncer_exporter && cd /opt/pgbouncer_exporter
```

* Скопировать файл `monitoring/pgbouncer_exporter/pgbouncer_exporter.env` в папку `/opt/pgbouncer_exporter/pgbouncer_exporter.env`

### Создание сервиса для автозапуска

* Поменять в файле `monitoring/pgbouncer_exporter/pgbouncer_exporter.service` авторизационные данные
* Скопировать файл `monitoring/pgbouncer_exporter/pgbouncer_exporter.service` в папку `/etc/systemd/system/pgbouncer_exporter.service`

### Запуск сервиса

```bash
systemctl daemon-reload
systemctl enable pgbouncer_exporter
systemctl start pgbouncer_exporter
```
