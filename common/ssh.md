# [ssh](https://docs.gitlab.com/ee/user/ssh.html)

## Установка

```bash
apt install ssh
```

## Создание

```bash
ssh-keygen -t ed25519 -C "<comment>"
```

## Настройка

```bash
cat ~/.ssh/id_rsa.pub
```

Открытый ключ выгружается на удаленный сервер, на который вы хотите заходить, используя SSH. Этот ключ добавляется в специальный файл `~/.ssh/authorized_keys` в учетной записи пользователя, которую вы используете для входа.

## Tunnel

[Статья на хабре](https://habr.com/ru/companies/flant/articles/691388/)

### На сервере

Создаем нового пользователя

```bash
sudo useradd -s /bin/true -m -r rtunnel
```

Создаем этому пользователю `authorized_keys` для входа по ssh

```bash
sudo -u rtunnel mkdir -p /home/rtunnel/.ssh
sudo -u rtunnel touch /home/rtunnel/.ssh/authorized_keys
```

Копируем свой `id_rsa.pub` в созданный `/home/rtunnel/.ssh/authorized_keys`

Меняем права для доступа к файлу

```bash
sudo chmod 600 /home/rtunnel/.ssh/authorized_keys
```

Должен быть включен `AllowTcpForwarding`

```bash
nano /etc/ssh/sshd_config
```

```ini
AllowTcpForwarding yes
```

### Локально

Должен быть включен `GatewayPorts`

```bash
nano /etc/ssh/sshd_config
```

```ini
GatewayPorts yes
```

Открываем туннель

```bash
ssh -fnNT -L ${LOCAL_PORT}:localhost:${SERVER_PORT} rtunnel@${SERVER_IP} -i ~/.ssh/id_rsa.pub
```

```ini
-f # переводит процесс ssh в фоновый режим;
-n # предотвращает чтение из STDIN;
-N # не выполнять удаленные команды. Полезно, если нужно только перенаправить порты;
-T # отменяет переназначение терминала.
```
