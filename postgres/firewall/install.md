# Ufw

## Установка

```bash
apt install ufw
```

## Настройка

### Логи

#### Включить логи

```bash
ufw logging on
```

#### Уровень логов (опционально)

```bash
ufw logging high
```

#### Файл с логами

`/var/log/ufw.log`

### Запретить все входящие соединения

```bash
ufw default deny incoming
```

### Разрешаем определенным IP доступ по ssh

```bash
ufw allow from ${IP} to any port 22
```

### Запретить определенным IP доступ по ssh

```bash
ufw deny from ${IP} to any port 22
```

## Запуск

```bash
ufw enable
```
