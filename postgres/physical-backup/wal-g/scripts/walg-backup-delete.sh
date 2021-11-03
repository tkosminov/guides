#!/bin/bash

su - postgres -c "/usr/local/bin/wal-g delete before FIND_FULL \$(date -d '-30 days' '+\\%FT\\%TZ') --config /var/lib/postgresql/.walg.json --confirm >> /var/log/postgresql/walg_delete.log 2>&1"