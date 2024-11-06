# [Certbot](https://certbot.eff.org/)

## Установка

```bash
sudo snap install --classic certbot
```

```bash
sudo ln -s /snap/bin/certbot /usr/bin/certbot
```

## Настройка

### Создание папки для хранения сертификатов

```bash
mkdir -p /var/lib/certbot/certs.d
```

## Сертификаты

### Список

```bash
/usr/bin/certbot certificates
```

### Создание сертификата

```bash
/usr/bin/certbot certonly -a webroot --webroot-path=/var/lib/certbot/certs.d -d ${DOMAIN}
```

### Продление сертификата

```bash
/usr/bin/certbot renew --cert-name ${DOMAIN}
```

### Удаление сертификата

```bash
/usr/bin/certbot delete --cert-name ${DOMAIN}
```

### Продление всех сертификатов

```bash
/usr/bin/certbot renew
```

## Подключение сертификата к проекту

Пример конфига для Nginx:

```conf
upstream ${APP_NAME} {
  server localhost:${APP_PORT};
}

server {
  server_name ${DOMAIN};
  listen ${IP};

  location /.well-known {
    root /var/lib/certbot/certs.d;
  }

  location / {
    return 301 https://$server_name$request_uri;
  }
}

server {
  server_name ${DOMAIN};    
  listen ${IP} ssl;

  ssl_certificate     /var/lib/certbot/certs.d/${DOMAIN}/fullchain.pem;
  ssl_certificate_key /var/lib/certbot/certs.d/${DOMAIN}/privkey.pem;

  location / {
    add_header X-Content-Type-Options nosniff;
    add_header Referrer-Policy 'strict-origin-when-cross-origin';
    add_header Content-Security-Policy "default-src 'self'; connect-src * 'self'; frame-src * 'self'; font-src * blob: data:; img-src * blob: data:; media-src * blob: data:; script-src * 'unsafe-inline' 'unsafe-eval'; worker-src * data: blob:; style-src * 'unsafe-inline'; base-uri 'self'; form-action 'self';";
    add_header Cache-Control 'no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0';

    if_modified_since off;
    expires off;
    etag off;
    proxy_no_cache 1;
    proxy_cache_bypass 1;
    proxy_http_version 1.1;

    proxy_pass http://${APP_NAME};

    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

    client_max_body_size 10g;
  }

  location /robots.txt {
    return 200 'User-agent: *\nDisallow: /';
  }
}
```

## Проверка сертификата

1. [онлайн сервис](https://www.ssllabs.com/ssltest/analyze.html)
2. openssl
   ```bash
   DOMAIN=

   openssl s_client -connect $DOMAIN:443 -servername $DOMAIN -tls1_3 | openssl x509 -noout -text
   ```
   Если используется ESNI, в выводе команды вы увидите строку "extendedKeyUsage = TLS Web Server Authentication".
3. curl
   ```bash
   DOMAIN=

   curl --tlsv1.3 -v https://$DOMAIN
   ```
   Если ESNI используется, в выводе будет видна информация о шифровании "Encrypted Client Hello".
4. Создаем файл `check-domains.txt`
   ```txt
   example.com
   example1.com
   ...
   ```
   Запускам
   ```bash
   truncate -s 0 ./output_check.txt && for suite_check in $(cat check-domains.txt); do curl -4s "https://dns.google/resolve?name=${suite_check}&type=HTTPS" | jq; done >> ./output_check.txt
   ```
   Если в инфе о домене присутствует `ech=`, то используется ESNI
