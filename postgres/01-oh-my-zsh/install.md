# [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)

## Установка

*Эта оболочка для консоли удобнее стандартной*

### zsh

```bash
apt install zsh curl wget
```

### oh-my-zsh

*Необходимо поставить `oh-my-zsh` для `root` пользователя и для обычного. Для этого под каждым пользователем необходимо исполнить следующую команду*

```bash
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## Настройка

в файле `.zshrc` для `root` пользователя меняем тему, чтобы сразу определить пользователя под которым зашли

```conf
ZSH_THEME="agnoster"
```
