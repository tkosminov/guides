# [MongoDB](https://www.mongodb.com/)

## Установка

```bash
sudo apt-get install gnupg
```

```bash
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -

echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list

sudo apt-get update
sudo apt-get install -y mongodb-org
```

## Настройка

```bash
sudo nano /etc/mongod.conf
```

```conf
net:
  port: 27017
  bindIp: 0.0.0.0
```

```bash
sudo systemctl daemon-reload
sudo systemctl enable mongod
sudo systemctl start mongod
```

## Пользователь

```bash
mongosh
```

```mongo
db.adminCommand( { listDatabases: 1 } )

use admin

db.createUser(
  {
    user: "admin",
    pwd: "password",
    roles: [ { role: "userAdminAnyDatabase", db: "admin" }, 
             { role: "dbAdminAnyDatabase", db: "admin" }, 
             { role: "readWriteAnyDatabase", db: "admin" } ]
  }
)
```
