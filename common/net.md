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
sudo lsof -wni tcp:${PORT}
```

## DNS Check

```bash
apt-get install dnsutils

dig $DOMAIN
```

## [arp-scan](https://github.com/royhills/arp-scan)

```bash
sudo apt-get install arp-scan
```

### Localnet

```bash
sudo arp-scan --localnet
```

### WiFi

```bash
sudo arp-scan -l --interface=wlan0
```

### Ethernet

```bash
sudo arp-scan -l --interface=eth0
```

## [iperf3](https://iperf.fr/)

```bash
sudo apt-get install iperf3
```

### На сервере

```bash
iperf3 -s
```

### На клиенте

```bash
iperf3 -c ${SERVER_IP} -R
```
