# csv

## Поиск по файлу в кодировке WINDOWS-1251

```bash
iconv -f WINDOWS-1251 -t UTF-8 $FILE_NAME.csv | grep "$KEYWORD"
```
