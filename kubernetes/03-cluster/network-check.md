# Проверка сети

## Тестовый контейнер

Получаем список нод

```bash
kubectl get nodes
```

Поднимаем тестовый под

```bash
kubectl run -it --rm dns-test-slave --image=busybox:1.36 --restart=Never --overrides='
{
  "apiVersion": "v1",
  "spec": {
    "nodeSelector": {
      "kubernetes.io/hostname": "${NODE_NAME}"
    }
  }
}' -- sh
```


Внутри пода

1. содержимое конфигурационного файла системы разрешения DNS
   ```bash
   cat /etc/resolv.conf
   ```
2. DNS-запрос к указанному доменному имени
   ```bash
   nslookup ${INTERNAL_DOMAIN_NAME}
   ```
3. Для проверки UDP соединения
   ```bash
   nc -u -v ${INTERNAL_IP} ${PORT}
   ```
4. Для проверки TCP соединения
   ```bash
   nc -v ${INTERNAL_IP} ${PORT}
   ```
