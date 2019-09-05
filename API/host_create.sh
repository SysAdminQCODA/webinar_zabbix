#!/bin/sh
#
# Cria host via API.
#
# Author: Ruan Carlos - contato@sonictecnologia.com

API='http://zabbix.laboratorio.cloud/zabbix/api_jsonrpc.php'
ZABBIX_USER='Admin'
ZABBIX_PASS='zabbix'
HOST=$1
IP=$2

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

echo "Autenticacao: $AUTH_TOKEN"

create_host(){
    wget --no-check-certificate -O- -o /dev/null $API --header 'Content-Type: application/json' --post-data "{
      \"jsonrpc\": \"2.0\",
      \"method\": \"host.create\",
      \"params\": {
          \"host\": \"$HOST\",
          \"interfaces\": [
              {
                  \"type\": 1,
                  \"main\": 1,
                  \"useip\": 1,
                  \"ip\": \"$IP\",
                  \"dns\": \"\",
                  \"port\": \"10050\"
              }
          ],
          \"groups\": [
              {
                  \"groupid\": \"15\"
              }
          ],
          \"templates\": [
              {
                  \"templateid\": \"10265\"
              }
          ],
          \"inventory_mode\": 0
      },
      \"auth\": \"$AUTH_TOKEN\",
      \"id\": 1}"
}

create_host;
