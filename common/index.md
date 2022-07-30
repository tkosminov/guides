# Tar

## С шифрованием

Архивировать:

```bash
tar cf - * | xz -z | gpg --symmetric --cipher-algo aes256 --passphrase-file <(echo ${PASS_PHRASE}) - > ../${TAR_NAME}.tar.xz.gpg
```

Разархивировать:

```bash
gpg -d ./${TAR_NAME}.tar.xz.gpg | tar -xJvf -
```

Посмотреть список файлов не разархивируя:

```bash
gpg -d ./${TAR_NAME}.tar.xz.gpg | tar -tvJf -
```

## Без шифрования

Архивировать:

```bash
tar cf - * | xz -z - >../taat.tar.xz
```

Разархивировать:

```bash
tar -xJvf ./${TAR_NAME}.tar.xz -C ./
```

Посмотреть список файлов не разархивируя:

```bash
tar -tvJf ./${TAR_NAME}.tar.xz
```

# zip

## Установка

```bash
apt install p7zip-full
```

## Архивировать

```bash
7z a -r ../${TAR_NAME}.zip *
```

## Разархивировать

```bash
7z x ${TAR_NAME}.zip
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
