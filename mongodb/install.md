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
             { role: "clusterMonitor", db: "admin" }, 
             { role: "readWriteAnyDatabase", db: "admin" } ]
  }
)
```

Добавить роль:

```mongosh
db.grantRolesToUser(
    "admin",
    [
      { role: "clusterMonitor", db: "admin" }
    ]
)
```

Убрать роль:

```mongosh
db.revokeRolesFromUser(
    "admin",
    [
      { role: "clusterMonitor", db: "accounts" }
    ]
)
```

## Базовые команды

1. Консоль
   ```bash
   mongosh
   ```
2. Список БД
   ```bash
   db.adminCommand( { listDatabases: 1 } )
   ```
3. Подключиться к БД
   ```bash
   use $db_name
   ```
4. Список таблиц (коллекций) в БД
   ```bash
   show collections
   ```
5. Поиск строки в коллекции
   ```bash
   # db.$collection_name.find($filter, $select)
   # $select, не обязательно передавать 

   db.$collection_name.find({ $column_name: "$column_value" })
   db.$collection_name.find({ $column_name: "$column_value" }, { _id: 1, $column_name: 1 })
   ```
6. Изменение строки
   ```bash
   # db.$collection_name.update($filter, $update, $options)
   # $options, не обязательно передавать, если обновлять несколько строк то { multi: true }

   db.$collection_name.update({ _id: ObjectId("$object_id") }, { $set: { $column_name: $column_value } })
   ```
