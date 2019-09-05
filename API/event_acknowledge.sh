#!/bin/sh
#
# Cria host via API - SysAadmin QCODA
#
# Author: Ruan Carlos - contato@sonictecnologia.com

API=$API
ZABBIX_USER='api'
ZABBIX_PASS=$ZABBIX_PASS
evento=$1
texto="$2"
action=${3:-2}
severity=$4

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
        \"params\": {
            \"eventids\": \"$evento\",
            \"action\": \"$action\",
            \"message\": \"$texto\",
            \"severity\": \"$severity\"
        },
        \"auth\": \"$AUTH_TOKEN\",
        \"id\": 1}"
}
EVENTO=$(event_acknowledge);

echo "$EVENTO"
