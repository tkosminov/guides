#!/bin/bash

echo "Physical Weekly Delete Start"

source /var/lib/postgresql/base-config.sh

# Сначала надо сделать логический бэкап
/bin/bash /var/lib/postgresql/logical-backup-push.sh

# После мы удаляем текущую станзу
/usr/bin/node /var/lib/postgresql/pgbackrest-stanza-delete/index.mjs stanzaDelete

# И создаем новый бэкап
/bin/bash /var/lib/postgresql/pgbackrest-backup-push.sh

echo "Physical Weekly Delete End"
