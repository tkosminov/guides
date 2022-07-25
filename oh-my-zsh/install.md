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

в файле `.zshrc` для `%username%` пользователя меняем тему, чтобы сразу определить пользователя под которым зашли

```conf
ZSH_THEME="maran"
```

в файле `.zshrc` для `%username%` прописать в самом верху, `если необходимо отключить вопросы связанные с обновлениями` (спрашивать не будет - будет сразу обновлять)

```conf
DISABLE_UPDATE_PROMPT="true"
```

в файле `.zshrc` для `%username%` прописать в самом верху, `если необходимо отключить обновлениями`

```conf
DISABLE_AUTO_UPDATE="true"
```

## Удаление

Выдать права на запуск для скрипта для удаления:

```bash
sudo chmod 777 ~/.oh-my-zsh/tools/uninstall.sh
```

Запустить скрипт для удаления:

```bash
~/.oh-my-zsh/tools/uninstall.sh
```
