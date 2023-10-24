# [nodejs](https://github.com/lukechilds/zsh-nvm)

## Установка

### Через zsh-nvm

*Так как нам нужен `nodejs` для `root` пользователя, то устанавливать его будем через `nvm` как плагин для `oh-my-zsh`*

```bash
apt install git
```

```bash
git clone https://github.com/lukechilds/zsh-nvm ~/.oh-my-zsh/custom/plugins/zsh-nvm
```

в файле `.zshrc` для `root` пользователя добавляем плагин

```conf
plugins+=(zsh-nvm)
```

*Теперь необходимо перезапустить консоль*

*После того как скачается `nvm` устанавливаем `nodejs`*

```bash
nvm install 14.18.2
```

### [Стандартная](https://github.com/nodesource/distributions)

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
