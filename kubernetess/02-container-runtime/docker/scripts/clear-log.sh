#!/bin/bash

echo "Delete log files Start"

log_files=$(find /var/lib/docker/containers -print | grep -E '[a-z0-9]{64}-json.log$' | awk '{print $1}')

for log_file in ${log_files}; do
  if [ -f ${log_file} ]; then
    find ${log_file} -delete
  fi

  if [ -f ${log_file} ]; then
    echo "${log_file} is not removed"
  else
    echo "${log_file} is removed"
  fi
done

echo "Delete log files Complete"
