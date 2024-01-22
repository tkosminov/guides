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

