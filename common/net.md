# Сеть

## Проверить пинг до сервера

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

## Список используемых портов

### ss

```bash
apt install iproute2

ss -tulpn
```
