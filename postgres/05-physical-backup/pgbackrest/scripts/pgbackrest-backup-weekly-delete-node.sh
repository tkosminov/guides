#!/bin/bash

echo "Physical Weekly Delete Start"

source /var/lib/postgresql/base-config.sh

# Сначала надо сделать логический бэкап
sh /var/lib/postgresql/logical-backup-push.sh

# После мы удаляем текущую станзу
/root/.nvm/versions/node/v14.18.2/bin/node /var/lib/postgresql/pgbackrest-stanza-delete/index.js stanzaDelete

# И создаем новый бэкап
sh /var/lib/postgresql/pgbackrest-backup-push.sh

echo "Physical Weekly Delete End"
