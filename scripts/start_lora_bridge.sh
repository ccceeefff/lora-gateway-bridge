#!/bin/bash

#set -eo pipefail

# terminate all previous running instances
kill -9 `ps ax | grep lora-gateway-bridge -m 1 | awk '{print $1}'`

# source the environment parameters
. /etc/lora/gateway.env

# launch the app
lora-gateway-bridge --mqtt-server $MQTT_SERVER >> /var/log/lora-gw/lora-gw.log 2>&1 &
