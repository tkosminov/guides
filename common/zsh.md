# [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)

## Установка

```bash
wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh

sh install.sh
```

## Тема

```bash
nano ~/.zshrc
```

* root:
  ```ini
  ZSH_THEME="agnoster"
  ```
* user:
  ```ini
  ZSH_THEME="af-magic"
  ```

## Плагины

### [asdf](https://asdf-vm.com/)

#### Установка

```bash
git clone https://github.com/asdf-vm/asdf.git ~/.asdf
```

#### Настройка

```bash
nano ~/.zshrc
```

```ini
plugins+=(asdf)
```

#### Плагины

```bash
asdf plugin add ruby
```

```bash
asdf plugin add nodejs
```
