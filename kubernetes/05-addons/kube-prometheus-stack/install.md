# [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)

## Установка

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
    ...
    enabled: true
    hosts:
      - grafana.example.com
    annotations:
      nginx.ingress.kubernetes.io/force-ssl-redirect: “true”
      nginx.ingress.kubernetes.io/rewrite-target: "/"
      kubernetes.io/ingress.class: "nginx"
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
