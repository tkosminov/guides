# [atop](https://github.com/Atoptool/atop)

## Установка

```bash
apt install atop
```

## Настройка

### Конфиг 1

Редактируем файл с кофигом:

```bash
nano /etc/default/atop
```

Устанавливаем интервал записи лога в 30 секунд:

```bash
SET INTERVAl=30
```

### Конфиг 2

Редактируем файл с кофигом:

```bash
nano /usr/share/atop/atop.daily
```

Устанавливаем интервал записи лога в 30 секунд:

```bash
LOGINTERVAL = 30
INTERVAl=30
```
