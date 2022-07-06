# Tar

## Архивировать и зашифровать

```bash
tar cf - *.sql | xz -z | gpg --symmetric --cipher-algo aes256 --passphrase-file <(echo ${PASS_PHRASE}) - > ../${TAR_NAME}.tar.xz.gpg
```

## Расшифровать и разархивировать

```bash
gpg -d ${TAR_NAME}.tar.xz.gpg | tar -xJvf -
```

## Посмотреть список файлов, не разархивируя

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
