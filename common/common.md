# Size

## Место на диске

```bash
df -h
```

## Размер папки

```bash
du -sh ${DIR_PATH}
```

## Размер файлов внутри папки

```bash
ls -lah
```

# Пользователь

Создать пользователя:

```bash
sudo adduser ${username}
```

Добавить в группу sudo:

```bash
usermod -aG sudo ${username}
```

Добавить в sudoers:

```bash
echo "${username}  ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/${username}
```
