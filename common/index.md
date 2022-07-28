# Tar

## С шифрованием

Архивировать:

```bash
tar cf - * | xz -z | gpg --symmetric --cipher-algo aes256 --passphrase-file <(echo ${PASS_PHRASE}) - > ../${TAR_NAME}.tar.xz.gpg
```

Разархивировать:

```bash
gpg -d ${TAR_NAME}.tar.xz.gpg | tar -xJvf -
```

## Без шифрования

Архивировать:

```bash
tar cf - * | xz -z - >../${TAR_NAME}.tar.xz
```

Разархивировать:

```bash
tar -C ./ -xJvf ${TAR_NAME}.tar.xz
```

## Расшифровать и посмотреть список файлов, не разархивируя

```bash
gpg -d ${TAR_NAME}.tar.xz.gpg | tar -tvJf -
```

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
