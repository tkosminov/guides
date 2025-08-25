# [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)

## Установка

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
```

```bash
kubectl create namespace monitoring
```

### Скачиваем чарт

```bash
helm pull prometheus-community/kube-prometheus-stack --untar
```

### Редактируем values.yaml:

```yaml
grafana:
  ...
  adminPassword: 'password'
  ...
  ingress:
    ingressClassName: nginx
    ...
    enabled: true
    hosts:
      - grafana.example.com
    annotations:
      nginx.ingress.kubernetes.io/force-ssl-redirect: “true”
      nginx.ingress.kubernetes.io/rewrite-target: "/"
      kubernetes.io/tls-acme: "true"
      cert-manager.io/cluster-issuer: cert-cluster-issuer
    tls:
      - secretName: grafana-tls
        hosts:
        - grafana.example.com
```

```yaml
prometheus:
  ...
  prometheusSpec:
    ...
    serviceMonitorSelectorNilUsesHelmValues: false
```

### Устанавливаем chart

```bash
helm install monitoring prometheus-community/kube-prometheus-stack --namespace monitoring \
                                                                   -f ./values.yaml \
                                                                   --set grafana.nodeSelector."kubernetes\.io/hostname"=${название_мастер_ноды} \
                                                                   --set alertmanager.alertmanagerSpec.nodeSelector."kubernetes\.io/hostname"=${название_мастер_ноды} \
                                                                   --set prometheusOperator.nodeSelector."kubernetes\.io/hostname"=${название_мастер_ноды} \
                                                                   --set prometheusOperator.admissionWebhooks.patch.nodeSelector."kubernetes\.io/hostname"=${название_мастер_ноды} \
                                                                   --set prometheus.prometheusSpec.nodeSelector."kubernetes\.io/hostname"=${название_мастер_ноды} \
                                                                   --set kube-state-metrics.nodeSelector."kubernetes\.io/hostname"=${название_мастер_ноды}
```

*Для обновления после внесения изменений в values.yaml, команда та же, но **install** меняем на **upgrade***

### Необходимо открыть порты для метрик, если установлен ufw

*Чтобы метрики нормально собирались все эти сервисы должны быть запущены на `0.0.0.0`*

`из values.yaml:`

* 10250 - prometheusOperator.tls.internalPort
* 10249 - kubeProxy.service.port / kubeProxy.service.targetPort
* 10249 - kubeEtcd.service.port / kubeEtcd.service.targetPort

`дефолтные порты из readme.md`

* 10259 - kubeSchedulerDefaultSecurePort
* 10257 - kubeControllerManagerDefaultSecurePort

`из charts/prometheus-node-exporter/values.yaml:`

* 9100 - service.port / service.targetPort

```bash
sudo ufw allow from ${ip_мастер_ноды} to any port 10250
sudo ufw allow from ${ip_мастер_ноды} to any port 10249
sudo ufw allow from ${ip_мастер_ноды} to any port 2379
sudo ufw allow from ${ip_мастер_ноды} to any port 9100
sudo ufw allow from ${ip_мастер_ноды} to any port 10259
sudo ufw allow from ${ip_мастер_ноды} to any port 10257

sudo ufw allow from 10.0.0.0/8
```

## Удаление

```bash
helm uninstall monitoring
```

```bash
kubectl delete crd alertmanagerconfigs.monitoring.coreos.com
kubectl delete crd alertmanagers.monitoring.coreos.com
kubectl delete crd podmonitors.monitoring.coreos.com
kubectl delete crd probes.monitoring.coreos.com
kubectl delete crd prometheuses.monitoring.coreos.com
kubectl delete crd prometheusrules.monitoring.coreos.com
kubectl delete crd servicemonitors.monitoring.coreos.com
kubectl delete crd thanosrulers.monitoring.coreos.com
```

## Доп. источники для prometheus

Редактируем `values.yaml`:

```yaml
prometheus:
  ...
  prometheusSpec:
    ...
    additionalScrapeConfigsSecret:
      enabled: true
      name: additional-scrape-configs
      key: prometheus-additional.yaml
```

Создаем файл `prometheus-additional.yaml`:

```yaml
- job_name: $JON_NAME
  static_configs:
    - targets: [$IP:$PORT]
      labels:
        instance: $INSTANCE_NAME
```

Создаем k8s Secret из файла:

```bash
kubectl create secret generic additional-scrape-configs --from-file=prometheus-additional.yaml --dry-run=client -oyaml > additional-scrape-configs.yaml
```

```bash
kubectl apply -f additional-scrape-configs.yaml -n monitoring
```

## Чтобы сделать prometheus доступным снаружи

Редактируем `values.yaml`:

```yaml
prometheus:
  ...
  service:
    ...
    nodePort: 30090
    ...
    type: NodePort
```

```bash
sudo ufw allow from ${IP} to any port 30090
```
