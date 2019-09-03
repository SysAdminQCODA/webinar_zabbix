#!/bin/sh
#
# Author: Ruan Carlos - ruan.oliveira@b2br.com.br

API='http://192.168.56.103/zabbix/api_jsonrpc.php'
ZABBIX_USER='Admin'
ZABBIX_PASS='zabbix'
evento=$1
texto="$2"

authenticate()
{
    wget --no-check-certificate -O- -o /dev/null $API --header 'Content-Type: application/json' --post-data "{
        \"jsonrpc\": \"2.0\",
        \"method\": \"user.login\",
        \"params\": {
                \"user\": \"$ZABBIX_USER\",
                \"password\": \"$ZABBIX_PASS\"},
        \"auth\": null,
        \"id\": 1}" | cut -d'"' -f8
}
AUTH_TOKEN=$(authenticate)

echo "$AUTH_TOKEN"

event_acknowledge()
{
    wget --no-check-certificate -O- -o /dev/null $API --header 'Content-Type: application/json' --post-data "{
        \"jsonrpc\": \"2.0\",
        \"method\": \"event.acknowledge\",
        \"params\": {\"eventids\": $evento,\"message\": \"$texto\"},
        \"auth\": \"$AUTH_TOKEN\",
        \"id\": 2}"
}
EVENTO=$(event_acknowledge);

echo "$EVENTO"
