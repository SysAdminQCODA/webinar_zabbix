# -*- coding: utf-8 -*-

from zabbix_api import ZabbixAPI
import json

webinar = ZabbixAPI(server="http://zabbix-webinar.sysadminqcoda.com")
webinar.login("api", "sysadminqcoda")

itens = webinar.item.get({
    "output": "extend",
    "filter": {"state": 1}
})

print("############### \n"
      "ID do host - ID do item - Nome - Erro\n"
      "###############")

for item in itens:
    print(item["hostid"], "-", item["itemid"], "-", item["name"], "-", item["error"])

print("Total de itens não suportados: ", len(itens))