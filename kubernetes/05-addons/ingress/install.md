# Ingress

## Установка 

* [ingress-nginx](./nginx.md)
* [traefik](./traefik.md)

## NoFile

### App

```bash
$SERVICE_NAME = worker # (если nginx)
                containerd # (если containerd)
                dockerd # (если docker)
```

* Список воркеров:
  ```bash
  ps aux | grep ${SERVICE_NAME}
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

Т.е. если `каждый воркер` может открыть до `1_047_552` файлов, а `число воркеров равно числу ядер` (например `32`), это не означает что всего может быть открыто до `32 * 1_047_552` файлов.

Из-за `ulimit`, который ограничивает процесс и может открыть (например до `1_048_576` файлов) число файлов которые может открыть воркер уменьшается до `1_048_576 / 32`, т.е. `ограничения от ulimit деленное на количество воркеров nginx`.

Кроме того `nginx/traefik`, как `прокси` устанавливает соединение с клиентом и сервером приложения, т.е. для каждого запроса открывается по `2` файла.

### Изменение лимитов на дескрипторы

```bash
$HARD_LIMIT=65535
$SOFT_LIMIT=65535
```

* [docker](../../02-container-runtime/docker/install.md)
  
  Для контейнеров:

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

  Для самого docker:

  ```bash
  nano /usr/lib/systemd/system/docker.service
  ```

  ```conf
  [Service]
  ...
  LimitNOFILE=infinity # Или число > 0
  LimitNPROC=infinity
  LimitCORE=infinity
  ...
  ```
* [containerd](../../02-container-runtime/containerd/install.md)

  Для контейнеров:

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

  Для самого containerd:

  ```bash
  nano /usr/lib/systemd/system/containerd.service
  ```

  ```conf
  [Service]
  ...
  LimitNOFILE=infinity # Или число > 0
  LimitNPROC=infinity
  LimitCORE=infinity
  ...
  ```
* OS
  ```bash
  nano /etc/security/limits.conf
  ```

  ```conf
  root           soft    nofile          $SOFT_LIMIT
  root           hard    nofile          $HARD_LIMIT
  ```

  В теории этот файл можно копировать внутрь контейнера по такому же пути и это должно изменить лимиты внутри контейнера

## TIME_WAIT

Состояние `TIME_WAIT` в протоколе `TCP` позволяет системе убедиться в том, что в данном `TCP`-соединении действительно `прекращена передача данных` и никакие данные не были потеряны. `Но возможное количество одновременно открытых сокетов — величина конечная`, а значит — это ресурс, который тратится в том числе и на состояние `TIME_WAIT`, в котором не выполняется обслуживание клиента.

Если ваш сервер `создает множество исходящих соединений`, установите `tcp_tw_reuse = 1` и ваша система сможет `использовать` порты `TIME_WAIT` `в случае исчерпания свободных`

```
0 - disable
1 - global enable
2 - enable for loopback traffic only
```

* Текущее значнение:
  ```bash
  cat /proc/sys/net/ipv4/tcp_tw_reuse
  ```
* Изменить значение:
  ```bash
  sysctl -w net.ipv4.tcp_tw_reuse=1

  sysctl -p
  ```

Также значение можно изменить след. образом:

```bash
nano /etc/sysctl.d/tcp_tw_reuse.conf
```

```conf
net.ipv4.tcp_tw_reuse = 1
```

## Port Range

* Текущее значение:
  ```bash
  cat /proc/sys/net/ipv4/ip_local_port_range
  ```
* Изменить значение:
  ```bash
  sysctl -w net.ipv4.ip_local_port_range="1024 65535"

  sysctl -p
  ```

Также значение можно изменить след. образом:

```bash
nano /etc/sysctl.d/ip_local_port_range.conf
```

```conf
net.ipv4.ip_local_port_range = "1024 65535"
```

По `дефолту` это значение в диапазоне `30_000` портов. Это означает, что `каждую минуту между веб-сервером и балансировщиком нагрузки` может быть установлено только `30_000` соединений, т.е. `около 500 соединений в секунду`.

## Max conn

В высоконагруженной среде может произойти переполнение очереди соединений, если та мала, что не позволит установить соединение. Размер очереди регулирует `net.core.somaxconn`. 

* Текущее значение:
  ```bash
  cat /proc/sys/net/core/somaxconn
  ```
* Изменить значение:
  ```bash
  sysctl -w net.core.somaxconn=65535

  sysctl -p
  ```

Также значение можно изменить след. образом:

```bash
nano /etc/sysctl.d/somaxconn.conf
```

```conf
net.core.somaxconn = 65535
```

## Доп. ссылки

* [Nginx Ingress High-Concurrency Practices](https://www.tencentcloud.com/document/product/457/38300)
* [3 необычных кейса о сетевой подсистеме Linux](https://habr.com/ru/companies/flant/articles/343348/)
* [Coping with the TCP TIME-WAIT state on busy Linux servers](https://vincent.bernat.ch/en/blog/2014-tcp-time-wait-state-linux)
* [Ingress-nginx sysctl tuning](https://kubernetes.github.io/ingress-nginx/examples/customization/sysctl/)
* [Update API Objects in Place Using kubectl patch](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/update-api-object-kubectl-patch/)
* [TIME-WAIT описание из коммита](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=79e9fed460385a3d8ba0b5782e9e74405cb199b1)