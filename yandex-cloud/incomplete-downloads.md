# Как удалить незавершенные закгрузки в Yandex Cloud

## Установки

### pip

```bash
sudo apt install python3-pip
```

### s3cmd

```bash
sudo pip3 install s3cmd
```

```bash
s3cmd --configure
```

Данные используем от сервисного аккаунта.

* `Access Key` — введите идентификатор ключа, который вы получили при генерации статического ключа.

* `Secret Key` — введите секретный ключ, который вы получили при генерации статического ключа.

* `Default Region` — введите `ru-central1`.

* `S3 Endpoint` — введите `storage.yandexcloud.net`.

* `DNS-style bucket+hostname:port template for accessing a bucket` — введите `%(bucket)s.storage.yandexcloud.net`.

* Значения остальных параметров оставьте без изменений.

### awscli

```bash
sudo pip3 install awscli
```

```bash
awscli configure
```

Данные используем от сервисного аккаунта.

* `AWS Access Key ID` — введите идентификатор ключа, который вы получили при генерации статического ключа.

* `AWS Secret Access Key` — введите секретный ключ, который вы получили при генерации статического ключа.

* `Default region name` — введите `ru-central1`.

* Значения остальных параметров оставьте без изменений.

## Удаление

### Список незавершенных загрузок

```bash
aws --endpoint-url=https://storage.yandexcloud.net s3api list-multipart-uploads --bucket ${BUCKET}
```

Пример вывода:

```ts
{
  "Uploads": [
    {
      "UploadId": :string;
      "Key": string;
      "Initiated": string;
      "StorageClass": "STANDARD"
    },
  ]
}
```

### Удалить незавершенную загрузку

`Key` и `UploadId` в команде нижу берутся из ответа, который возвращается при запросе списка незавершенных загрузок

```bash
aws --endpoint-url=https://storage.yandexcloud.net s3api abort-multipart-upload --bucket ${BUCKET} --key "${Key}" --upload-id "${UploadId}"
```