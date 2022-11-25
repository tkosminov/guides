# Файл подкачки

## Создание

* Создать файл подкачки (на 1Gi)
  ```bash
  dd if=/dev/zero of=$SWAP_FILE_PATH bs=1024 count=1048576
  ```
* Установить права на файл
  ```bash
  chmod 600 $SWAP_FILE_PATH
  ```
* Создать файл/раздел подкачки
  ```bash
  mkswap $SWAP_FILE_PATH
  ```
* Включить файл подкачки
  ```bash
  swapon $SWAP_FILE_PATH
  ```
* Отредактировать файл (`для автоматического включения`)
  ```bash
  nano /etc/fstab
  ```
  Добавив в него:
  ```txt
  $SWAP_FILE_PATH swap swap defaults 0 0
  ```

## Удаление

* Отключить файл подкачи
  ```bash
  swapoff -a
  ```
* Закомментировать строку с файлом подкачки в файле
  ```bash
  nano /etc/fstab
  ```
* Удалить файл подкачи (`опционально`), название файла в `/etc/fstab`
  ```bash
  rm -f $SWAP_FILE_PATH
  ```
