#!/bin/bash

echo "Physical Weekly Delete Start"

# Сначала надо сделать логический бэкап
sh /var/lib/postgresql/logical-backup-push.sh

# После мы удаляем старые бэкапы
sh /var/lib/postgresql/walg-backup-delete.sh

# И создаем новый бэкап
sh /var/lib/postgresql/walg-backup-push.sh

echo "Physical Weekly Delete End"
