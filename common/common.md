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

# Locale

список доступных локалей:

```bash
locale -a
```

отредактировать `nano /etc/default/locale`:

```conf
LANG="en_US.utf8"
LANGUAGE="en_US.utf8"
LC_ALL="en_US.utf8"
```

перезапустить сервер:

```bash
reboot
```

# Timezone

```bash
cp /usr/share/zoneinfo/UTC /etc/localtime
```

перезапустить сервер:

```bash
reboot
```

# Network scan

```bash
sudo apt-get install arp-scan
```

Localnet:

```bash
sudo arp-scan --localnet
```

WiFi:

```bash
sudo arp-scan -l --interface=wlan0
```

Ethernet:

```bash
sudo arp-scan -l --interface=eth0
```

# Chrome with fake media

```bash
google-chrome --disable-web-security --use-fake-device-for-media-stream
```
