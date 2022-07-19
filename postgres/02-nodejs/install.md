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

### Стандартная

```bash
curl -s https://deb.nodesource.com/setup_16.x | sudo bash
```

```bash
sudo apt install nodejs -y
```

## Путь к бинарнику

*Для запуска `js` скриптов из `bash` скриптов необходимо указывать полный путь к бинарнику `nodejs`, узнать который можно следующей командой*

```bash
which node
```
