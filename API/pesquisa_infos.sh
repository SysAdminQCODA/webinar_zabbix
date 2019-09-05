#!/bin/sh
#
# Cria host via API - SysAadmin QCODA
#
# Author: Ruan Carlos - contato@sonictecnologia.com

API=$API
ZABBIX_USER='api'
ZABBIX_PASS=$ZABBIX_PASS

jq=jq

HOSTNAME=$1


help() {
	echo "**********************************"
	echo "**      PESQUISA DE GRUPOS      **"
	echo "**                              **"
	echo "**********************************"
	echo
}


authenticate()
{
    wget -O- -o /dev/null $API --header 'Content-Type: application/json-rpc' --post-data "{
        \"jsonrpc\": \"2.0\",
        \"method\": \"user.login\",
        \"params\": {
                \"user\": \"$ZABBIX_USER\",
                \"password\": \"$ZABBIX_PASS\"},
        \"id\": 0}" | cut -d'"' -f8
}
AUTH_TOKEN=$(authenticate)

get_host_id() {
  wget -O- -o /dev/null $API --header 'Content-Type: application/json-rpc' --post-data "{
        \"jsonrpc\": \"2.0\",
        \"method\": \"host.get\",
        \"params\": {
        	\"output\": [\"hostid\",\"name\"],
			\"selectGroups\": [\"groupid\",\"name\"],
        	\"filter\": {\"host\" : [$HOSTNAME]}
        },
        \"auth\": \"$AUTH_TOKEN\",
        \"id\": 1}"
}
HOSTID=$(get_host_id);
#echo $HOSTID

HOST=$(echo $HOSTID | $jq -r '.result[].name')
GROUP=$(echo $HOSTID | $jq -r '.result[].groups[].name')

help;
echo "ATIVO: "$HOST
echo "IP: "$2
echo
echo "Grupos:"
echo "$GROUP"
