#!/bin/bash

PATH=/bin:/usr/bin

TELEGRAM_TOKEN=''
TELEGRAM_CHAT_ID=''

serverName=$HOSTNAME
my_ip="$(dig +short myip.opendns.com @resolver1.opendns.com)"

users='{
  "127.0.0.1":"Self"
}'

user=$(echo "$users" | jq -r .\"$PAM_RHOST\")

if [[ "$user" == *"null"* ]]; then
  user="unrecognized ip: $PAM_RHOST"
else
  user="$PAM_RHOST ($user)"
fi

message="$PAM_TYPE $PAM_USER@$serverName-$my_ip from $user"

if [ ! -z "$TELEGRAM_CHAT_ID" ] && [ ! -z "$TELEGRAM_TOKEN" ]; then
  /usr/bin/curl --max-time 60 \
    --header 'Content-Type: application/json' \
    --request 'POST' --data "{\"chat_id\":\"${TELEGRAM_CHAT_ID}\",\"text\":\"${message}\"}" "https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage"
else
  echo "Login Notify chat_id and token not provided"
  echo $message
fi
