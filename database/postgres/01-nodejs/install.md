# [nodejs](https://github.com/lukechilds/zsh-nvm)

## Установка

```bash
apt-get update
apt-get install -y ca-certificates curl gnupg
mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

NODE_MAJOR=20
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list

apt-get update
apt-get install nodejs -y
```

## Путь к бинарнику

*Для запуска `js` скриптов из `bash` скриптов необходимо указывать полный путь к бинарнику `nodejs`, узнать который можно следующей командой*

```bash
which node
```
