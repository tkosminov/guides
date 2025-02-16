# [redis](https://redis.io/)

## Установка

```bash
curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list

sudo apt-get update
sudo apt-get install redis
```

## Настройка

```bash
sudo nano /etc/redis/redis.conf
```

```conf
bind 0.0.0.0
...
supervised systemd
...
requirepass <password>
```

```bash
systemctl enable redis-server

systemctl restart redis-server
```

## Полезное

### Получить список ключей

```bash
redis-cli -a ${REDIS_PASSWORD} KEYS "${KEY_PATTERN}"
```

`KEY_PATTERN` пример: `beta_*` или `beta_*_key_*_`

### Удалить ключи

```bash
redis-cli -a ${REDIS_PASSWORD} KEYS "${KEY_PATTERN}" | xargs redis-cli -a ${REDIS_PASSWORD} DEL
```
