# Proxy

*Это нужно чтобы дать сервисам внутри k8s возможность использовать постгрес установленный снаружи.*

## Настройка

Редактируем файл `08-k8s/service.yaml`

Название сервиса и порт сервиса внутри k8s:

```yaml
metadata:
  name: postgres-external
spec:
  ports:
  - port: 5432
    targetPort: 5432
```

Путь к постгресу:

```yaml
metadata:
  name: postgres-external
subsets:
  - addresses:
    - ip: ${ip_сервер_с_бд}
  ports:
    - port: ${порт_бд}

```

## Установка

```bash
kubectl apply -f ./service.yaml
```
