# Сеть

## Пинг

### basic

```bash
ping $IP
```

### telnet

```bash
apt install telnet

telnet $IP $PORT
```

### netcat

```bash
apt install netcat

nc -vz $IP $PORT
```

### nmap

```bash
apt install nmap

nmap -p $PORT $IP
```

## Используемые порты

### ss

```bash
apt install iproute2

ss -tulpn
```

### lsof

[Статья на хабре](https://habr.com/ru/companies/ruvds/articles/337934/)

```bash
lsof -i -P -n
```

```bash
lsof -wni tcp:${PORT}
```

## DNS Check

```bash
apt-get install dnsutils

dig $DOMAIN
```

## Сканирование сети

### [arp-scan](https://github.com/royhills/arp-scan)

```bash
apt-get install arp-scan
```

```bash
arp-scan --localnet # local

arp-scan -l --interface=wlan0 # wifi

arp-scan -l --interface=eth0 # ethernet
```

### [RealiTLScanner](https://github.com/XTLS/RealiTLScanner)

```bash
curl -L $(curl -s https://api.github.com/repos/XTLS/RealiTLScanner/releases/latest | grep browser_download_url | grep linux-64 | cut -d '"' -f 4 | head -n 1) --output ./RealiTLScanner
```

```bash
./RealiTLScanner -addr 89.150.41.0/24 -v
```

## Замеры скорости интернета

### [iperf3](https://iperf.fr/)

```bash
apt-get install iperf3
```

```bash
iperf3 -s # на сервере

iperf3 -c ${SERVER_IP} -R # на клиенте
```

### [Speedtest by RosTelekom](https://speedtest.rt.ru/)

```bash
curl -sL https://lib.qms.ru/bin/linux/qms_lib.zip | bsdtar -xvf - -C /usr/local/bin

mv /usr/local/bin/qms_lib /usr/local/bin/speedtest-rt

chmod +x /usr/local/bin/speedtest-rt
```

### [Speedtest by Ookla](https://www.speedtest.net/ru/apps/cli)

```bash
pip install speedtest-cli
```

## Проверка маршрута

### traceroute

```bash
apt install traceroute
```

```bash
traceroute -T ${DOMAIN}
```

### mtr

```bash
apt install mtr-tiny
```

```bash
mtr -rwzbc 100 ${SERVER_IP}
```
