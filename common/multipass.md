# [Multipass](https://canonical.com/multipass)

## Установка

```bash
snap install multipass
```

## ВМ

### Список

```bash
multipass list
```

### Создать

```bash
multipass launch 22.04 --cpus 2 --disk 20G --memory 2G --name ${VM_NAME}
```

### Подключиться

```bash
multipass exec ${VM_NAME} -- bash
```

### Остановить

```bash
multipass stop ${VM_NAME}
```

### Удалить

```bash
multipass delete ${VM_NAME}
```

## Очистка

```bash
multipass purge
```
