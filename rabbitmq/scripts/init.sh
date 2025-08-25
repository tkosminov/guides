#!/bin/sh

# Ждем запуска RabbitMQ
until rabbitmq-diagnostics -q ping; do
  echo "Ждём RabbitMQ..."
  sleep 2
done

# Создаем vhost
rabbitmqctl add_vhost vhost

# Даем права пользователю по умолчанию
rabbitmqctl set_permissions -p vhost admin ".*" ".*" ".*"

# Симлинк плагина
ln -sf /plugins_custom/rabbitmq_delayed_message_exchange-3.13.0.ez /opt/rabbitmq/plugins/
# ln -sf /plugins_custom/rabbitmq_delayed_message_exchange-4.1.0.ez /opt/rabbitmq/plugins/

# Включаем плагин
rabbitmq-plugins enable --offline rabbitmq_delayed_message_exchange
