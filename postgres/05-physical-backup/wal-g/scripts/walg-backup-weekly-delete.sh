#!/bin/bash

echo "Physical Weekly Delete Start"

# Сначала надо сделать логический бэкап
/bin/bash /var/lib/postgresql/logical-backup-push.sh

# После мы удаляем старые бэкапы
/bin/bash /var/lib/postgresql/walg-backup-delete.sh

# И создаем новый бэкап
/bin/bash /var/lib/postgresql/walg-backup-push.sh

echo "Physical Weekly Delete End"
