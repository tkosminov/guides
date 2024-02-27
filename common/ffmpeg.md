# [ffmpeg](https://github.com/FFmpeg/FFmpeg)

## Установка

```bash
apt install ffmpeg
```

## Уменьшить размер

Степень сжатия (чем меньше число, тем хуже сжатие):

```bash
crf=30 # степень сжатия

-crf ${crf}
```

Уменьшит разрешение до 720 точек по горизонтали, количество точек по вертикали будет вычислено на основе текущего отношения ширины к высоте:

```bash
scale=720

-filter:v scale=${scale}:-1
```

Предустановка определяет эффективность сжатия и, следовательно, влияет на скорость кодирования (Используйте самый медленный пресет, на который у вас хватит терпения):

```bash
preset=slow # ultrafast, superfast, veryfast, faster, fast, medium, slow, slower, veryslow

-preset ${preset}
```

Тюнинг:

* film – использование для высококачественного кино-контента; снижает разблокировку
* animation – хорош для мультфильмов; использует более высокий уровень деблокировки и больше опорных кадров
* grain – сохраняет зернистую структуру в старом зернистом пленочном материале
* stillimage – подходит для контента, похожего на слайд-шоу
* fastdecode – позволяет ускорить декодирование за счет отключения определенных фильтров
* zerolatency – хорошо подходит для быстрого кодирования и потоковой передачи с малой задержкой

```bash
tune=film

-tune ${tune}
```

Пример

```bash
ffmpeg -i ${file_name}.${file_ext} -c:v libx264 -preset slow -tune film -crf 30 -c:a copy ${new_file_name}.${new_file_ext}
```

## Указать кодек

Видео кодек:
```bash
-c:v ${video_codec}
```

Аудио кодек:
```bash
-c:a ${audio_codec}
```

Список доступных кодеков:

```bash
ffmpeg -codecs
```

Пример:

```bash
ffmpeg -i ${file_name}.${file_ext} -c:v ${video_codec} -c:a ${audio_codec} ${new_file_name}.${new_file_ext}
```

## Конвертировать в другой формат

```bash
ffmpeg -i ${file_name}.${file_ext} -c:av copy ${new_file_name}.${new_file_ext}
```

Eсли же нужно поменять только звук, а видео оставить как есть

```bash
ffmpeg -i ${file_name}.${file_ext} -c:v copy -c:a ${audio_codec} ${new_file_name}.${new_file_ext}
```

Eсли же нужно поменять только видео, а звук оставить как есть

```bash
ffmpeg -i ${file_name}.${file_ext} -c:v ${video_codec} -c:a copy ${new_file_name}.${new_file_ext}
```

## Добавить звуковую дорожку

```bash
ffmpeg -i ${file_name}.${file_ext} -i ${path_to_audio_file} ${new_file_name}.${new_file_ext}
```

## Извлечь звуковую дорожку

Указать формат для извлекаемого аудио:

```
-c:a ${audio_codec}
```

Указать битрейт для извлекаемого аудио:

```bash
audio_bitrate=192k

-b:a ${audio_bitrate}
```

Пример:

```bash
ffmpeg -i ${file_name}.${file_ext} -vn -c:a ${audio_codec} -b:a ${audio_bitrate} ${audio_file_name}.${audio_file_ext}
```

## Вырезать часть видео

```bash
starts_time=00:01:00 # с какого момента вырезать
duration=10 # в секундах

-ss ${starts_time} -t ${duration}
```

Пример:

```bash
ffmpeg -i ${file_name}.${file_ext} -c:av copy -ss ${starts_time} -t ${duration} ${new_file_name}.${new_file_ext}
```
