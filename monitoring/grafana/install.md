# Grafana

## Установка

```bash
apt-get update
apt-get install -y apt-transport-https software-properties-common wget gnupg
```

```bash
mkdir -p /etc/apt/keyrings
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
chmod 644 /etc/apt/keyrings/grafana.gpg
```

### OSS (Бесплатная)

```bash
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://mirror.yandex.ru/mirrors/packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
```

```bash
apt-get update
apt-get install grafana
```

### Enterprise (платная)

Будет работать без лицензии, но платные функции будут недоступны

```bash
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://mirror.yandex.ru/mirrors/packages.grafana.com/enterprise/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
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

## Alert Rules

* CPU usage >= 80%
  * query
    ```
    (1 - avg by (instance, job) (rate(node_cpu_seconds_total{mode="idle"}[1m]))) * 100
    ```
  * message
    ```
    CPU usage for server ({{ $labels.instance }}) has exceeded 80%: Current value is {{ printf "%.2f" $value }}%
    ```
  * condition
    ```
    "is above or equal to" 80
    ```
* RAM usage >= 80%
  * query
    ```
    (1 - sum by (instance, job) (node_memory_MemAvailable_bytes) / sum by (instance, job) (node_memory_MemTotal_bytes)) * 100
    ```
  * message
    ```
    RAM usage for server ({{ $labels.instance }}) has exceeded 80%: Current value is {{ printf "%.2f" $value }}%
    ```
  * condition
    ```
    "is above or equal to" 80
    ```
* DISK usage >= 80%
  * query
    ```
    (1 - node_filesystem_avail_bytes{origin_prometheus=~"", fstype!~"tmpfs|devtmpfs|overlay|squashfs|iso9660|ramfs"} / node_filesystem_size_bytes{origin_prometheus=~"", fstype!~"tmpfs|devtmpfs|overlay|squashfs|iso9660|ramfs"}) * 100
    ```
  * message
    ```
    DISK usage for server ({{ $labels.instance }}) has exceeded 80%: Current value is {{ printf "%.2f" $value }}%
    ```
  * condition
    ```
    "is above or equal to" 80
    ```
* CPU TEMP >= 75°C (если node-exporter с lm-sensors и дэшборд с поддержкой hwmon)
  * query
    ```
    max by (instance, job) (node_hwmon_temp_celsius{origin_prometheus=~""})
    ```
  * message
    ```
    CPU TEMP for server ({{ $labels.instance }}) has exceeded 75°C: Current value is {{ printf "%.2f" $value }}°C
    ```
  * condition
    ```
    "is above or equal to" 75
    ```
* Long running query
  * query
    ```
    pg_stat_custom_activity_runtime{state=~"active|idle|idle in transaction", datname!~"postgres|template0|template1|rdsadmin"}[1m]
    ```
  * message
    ```
    Long running query in DB server: Database: "{{ $labels.datname }}", State: "{{ $labels.state }}", PID: {{ $labels.pid }}, Runtime: {{ printf "%.0f" $value }} seconds (Threshold: 300s)
    ```
  * condition
    ```
    "is above or equal to" 300
    ```
* Inbound Network Traffic >= 100 M/s
  * query
    ```
    sum by (instance, device) (rate(node_network_receive_bytes_total{device!~"lo|veth.*|docker.*|br-.*"}[5m]))
    ```
  * message
    ```
    High Network Traffic on server {{ $labels.instance }} ({{ $labels.device }}): Inbound exceeded threshold (100 M/s). Current: {{ humanize $value }}/s
    ```
  * condition
    ```
    "is above or equal to" 104857600
    ```
* Outbound Network Traffic >= 100 M/s
  * query
    ```
    sum by (instance, device) (rate(node_network_transmit_bytes_total{device!~"lo|veth.*|docker.*|br-.*"}[5m]))
    ```
  * message
    ```
    High Network Traffic on server {{ $labels.instance }} ({{ $labels.device }}): Outbound exceeded threshold (100 M/s). Current: {{ humanize $value }}/s
    ```
  * condition
    ```
    "is above or equal to" 104857600
    ```
* DISK Read >= 100 M/c
  * query
    ```
    sum by (instance, device) (rate(node_disk_read_bytes_total{device!~"loop.*|ram.*"}[5m]))
    ```
  * message
    ```
    High Disk I/O on server {{ $labels.instance }} ({{ $labels.device }}): Read exceeded threshold (100 M/s). Current: {{ humanize $value }}/s
    ```
  * condition
    ```
    "is above or equal to" 104857600
    ```
* DISK Write >= 100 M/c
  * query
    ```
    sum by (instance, device) (rate(node_disk_written_bytes_total{device!~"loop.*|ram.*"}[5m]))
    ```
  * message
    ```
    High Disk I/O on server {{ $labels.instance }} ({{ $labels.device }}): Write exceeded threshold (100 M/s). Current: {{ humanize $value }}/s
    ```
  * condition
    ```
    "is above or equal to" 104857600
    ```
* Instance is down (up возвращает 1 для живых серверов и 0 для недоступных)
  * query
    ```
    max by (instance) (up{instance=~"instance-1|instance-2"})
    ```
  * message
    ```
    Server ({{ $labels.instance }}) is not available!
    ```
  * condition
    ```
    "is below" 1
    ```
* Pod is down
  * query
    ```
    min by (namespace, pod) (
      kube_pod_status_ready{condition="true", namespace!~"kube-system|kube-public|kube-node-lease|default"}
    ) == 0
    unless on(namespace, pod) kube_pod_status_phase{phase=~"Succeeded|Failed"} == 1
    ```
  * message
    ```
    Pod {{ $labels.pod }} ({{ $labels.namespace }}) on server is down!
    ```
  * condition
    ```
    "is below" 1
    ```
  * Для "Alert state if no data or all values are null" (No Data)
    ```
    No Data -> Normal
    ```

## Alert contact point

`name`: Bitrix24
`integration`: Webhook
`URL`: https://${COMPANY_NAME}.bitrix24.ru/rest/${USER_ID}/${USER_TOKEN}/imbot.message.add.json?BOT_ID=${BOT_ID}&CLIENT_ID=${CLIENT_ID}&DIALOG_ID=${DIALOG_ID}

В Optional Webhook settings
`HTTP Method`: POST

Edit message -> Enter custom message

```
{{ if .Alerts }}
{{ range .Alerts }}
• [{{ .Status | toUpper }}] {{ .Labels.alertname }}
{{ .Annotations.summary }}
{{ end }}
{{ else }}
Тестовое уведомление Grafana
{{ end }}
```
