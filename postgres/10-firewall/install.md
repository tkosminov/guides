# Ufw

## Установка

```bash
apt install ufw
```

## Настройка

### Логи

#### Включить логи

```bash
sudo ufw logging on
```

#### Уровень логов (опционально)

```bash
ufw logging high
```

#### Файл с логами

`/var/log/ufw.log`

### Запретить все входящие соединения

```bash
sudo ufw default deny incoming
```

### Разрешаем определенным IP доступ по ssh

```bash
sudo ufw allow from ${IP} to any port 22
```

### Запретить определенным IP доступ по ssh

```bash
sudo ufw deny from ${IP} to any port 22
```

## Запуск

```bash
sudo ufw enable
```

### Удаление правил

```bash
sudo ufw status numbered
```

```bash
sudo ufw delete ${NUMBER}
```
