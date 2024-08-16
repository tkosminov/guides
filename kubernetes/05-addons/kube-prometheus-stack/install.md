# [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)

## Установка

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
