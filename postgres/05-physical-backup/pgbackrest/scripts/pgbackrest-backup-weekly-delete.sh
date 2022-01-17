#!/bin/bash

echo "Physical Weekly Delete Start"

source /var/lib/postgresql/base-config.sh

# Сначала надо сделать логический бэкап, т.к. удаление станзы требует остановки кластера
/bin/bash /var/lib/postgresql/logical-backup-push.sh

# После мы удаляем текущую станзу
/bin/bash /var/lib/postgresql/pgbackrest-backup-delete.sh

# И создаем новый бэкап
/bin/bash /var/lib/postgresql/pgbackrest-backup-push.sh

echo "Physical Weekly Delete End"
