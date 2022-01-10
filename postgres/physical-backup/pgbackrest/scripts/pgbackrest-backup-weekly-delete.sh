#!/bin/bash

echo "Physical Weekly Delete Start"

# Сначала надо сделать логический бэкап, т.к. удаление станзы требует остановки кластера
sh /var/lib/postgresql/logical-backup.sh

# После мы удаляем текущую станзу
sh /var/lib/postgresql/pgbackrest-backup-delete.sh

# И создаем новый бэкап
sh /var/lib/postgresql/pgbackrest-backup-push.sh

echo "Physical Weekly Delete End"
