# [Ingress-Nginx](https://github.com/kubernetes/ingress-nginx)

## Установка 

Добавляем репозитория:

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
```

Скачиваем чарт:

```bash
helm pull ingress-nginx/ingress-nginx --untar
```

Редактируем `values.yaml`:

```yaml
controller:
  ...
  hostNetwork: true
  dnsPolicy: ClusterFirstWithHostNet
  kind: DaemonSet
  config:
    - enable-underscores-in-headers: true
  ...
  addHeaders:
    X-Frame-Options: "SAMEORIGIN"
```

Устанавливаем чарт:

```bash
helm install ingress-nginx ingress-nginx/ingress-nginx  --namespace kube-system \
                                                        -f ./values.yaml
```

## Дескрипторы

### Nginx

* Список воркеров:
  ```bash
  ps aux | grep worker
  ```
* Сколько файлов может открыть воркер:
  ```bash
  cat /proc/${PID}/limits | grep open
  ```
* Сколько сейчас открыто файлов воркером:
  ```bash
  lsof -p ${PID} | wc -l
  ```

### System

* Максимальное число файлов, которое можно открыть:
  ```bash
  cat /proc/sys/fs/file-max
  ```
* Сколько сейчас открыто файлов:
  ```bash
  cat /proc/sys/fs/file-nr
  ```
* Изменить лимит:
  ```bash
  sysctl -w fs.file-max=500000

  sysctl -p
  ```

### ulimit

Он ограничивает ресурсы, которые может использовать процесс

* Максимальное число файлов, которое можно открыть:
  ```bash
  ulimit -n
  ```
  * Максимальное число файлов, которое можно открыть (soft):
  ```bash
  ulimit -Sn
  ```
  * Максимальное число файлов, которое можно открыть (hard):
  ```bash
  ulimit -Hn
  ```

### Выводы

Т.е. если `каждый воркер nginx` может открыть до `1_047_552` файлов, а `число воркеров равно числу ядер` (например `32`), это не означает что всего может быть открыто до `32 * 1_047_552` файлов.

Из-за `ulimit`, который ограничивает процесс и может открыть (например до `1_048_576` файлов) число файлов которые может открыть воркер уменьшается до `1_048_576 / 32`, т.е. `ограничения от ulimit деленное на количество воркеров nginx`.

## Изменение лимитов на дескрипторы

### [docker](../../02-container-runtime/docker/install.md)

Для всех контейнеров по дефолту это можно изменить через:

```bash
nano /etc/docker/daemon.json
```

```json
...
"default-ulimits": {
  "nofile": {
    "Name": "nofile",
    "Hard": $HARD_LIMIT,
    "Soft": $SOFT_LIMIT
  }
}
...
```

### [containerd](../../02-container-runtime/containerd/install.md)

```bash
nano /etc/systemd/system/kubelet.service.d/0-containerd.conf
```

```conf
[Service]
...
LimitNOFILE=infinity # Или число > 0
LimitNPROC=infinity
LimitCORE=infinity
...
```

### OS

```bash
nano /etc/security/limits.conf
```

```conf
root           soft    nofile          $SOFT_LIMIT
root           hard    nofile          $HARD_LIMIT
```

В теории этот файл можно копировать внутрь контейнера по такому же пути и это должно изменить лимиты внутри контейнера
