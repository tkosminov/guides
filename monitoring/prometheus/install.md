# [Prometheus](https://github.com/prometheus/prometheus)

## Установка

### Создание юзера и директорий

```bash
groupadd --system prometheus
useradd -s /sbin/nologin --system -g prometheus prometheus
```

```bash
mkdir /var/lib/prometheus
for i in rules rules.d files_sd; do mkdir -p /etc/prometheus/${i}; done
```

### Установка с гита

```bash
apt update
apt -y install wget curl vim
```

```bash
mkdir -p /tmp/prometheus && cd /tmp/prometheus && curl -L $(curl -s https://api.github.com/repos/prometheus/prometheus/releases/latest | grep browser_download_url | grep linux-amd64 | cut -d '"' -f 4 | head -n 1) | tar xzf - 
```

```bash
cd prometheus*/

mv prometheus promtool /usr/local/bin/
mv prometheus.yml /etc/prometheus/prometheus.yml
mv consoles/ console_libraries/ /etc/prometheus/
```

```bash
cd /tmp && rm -r ./prometheus
```

### Создание сервиса для автозапуска

* Скопировать файл `monitoring/prometheus/prometheus.service` в папку `/etc/systemd/system/prometheus.service`

### Установка прав на файлы

```bash
for i in rules rules.d files_sd; do chown -R prometheus:prometheus /etc/prometheus/${i}; done
for i in rules rules.d files_sd; do chmod -R 775 /etc/prometheus/${i}; done
chown -R prometheus:prometheus /var/lib/prometheus/
```

### Добавление postgres_exporter

* Открыть файл с конфигом прометеуса и добавить в scrape_configs новую цель для скрапа

```bash
nano /etc/prometheus/prometheus.yml
```

```yml
- job_name: 'postgres_exporter'
  static_configs:
    - targets: ['127.0.0.1:9187']

- job_name: 'pgbouncer_exporter'
  static_configs:
    - targets: ['127.0.0.1:9127']

- job_name: 'redis_exporter'
  static_configs:
    - targets: ['127.0.0.1:9121']

- job_name: 'node_exporter'
  static_configs:
    - targets: ['127.0.0.1:9167']

- job_name: 'mongodb_exporter'
  static_configs:
    - targets: ['127.0.0.1:9216']
```

### Запуск сервиса

```bash
systemctl daemon-reload
systemctl enable prometheus
systemctl start prometheus
```
