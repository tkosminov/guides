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

## DNS Check

```bash
apt-get install dnsutils

dig $DOMAIN
```
