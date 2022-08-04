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
