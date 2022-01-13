# Proxy

*Это нужно чтобы дать сервисам внутри k8s возможность использовать постгрес установленный снаружи.*

## Настройка

Редактируем файл `13-k8s/service.yaml`

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
      - ip: 192.168.0.2
    ports:
      - port: 6432

```

## Установка

```bash
kubectl apply -f ./service.yaml
```
