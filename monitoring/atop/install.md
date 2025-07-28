# [atop](https://github.com/Atoptool/atop)

## Установка

```bash
apt install atop
```

## Настройка

Редактируем файл с конфигом:

```bash
nano /usr/share/atop/atop.daily
```

Устанавливаем интервал записи лога:

```conf
INTERVAl=30
```

Перезапускаем atop

```bash
service atop restart
```

## Просмотр логов

### Папка с логами

```bash
cd /var/log/atop
```

### Просмотр логов

```bash
atop -r ${FILE_NAME}
```

### Просмотр логов с конкретного времени

```bash
atop -r ${FILE_NAME} -b ${HOURS}:${MINUTES}
```
