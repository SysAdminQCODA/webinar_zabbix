# -*- coding: utf-8 -*-

from zabbix_api import ZabbixAPI
import json
import csv
import pandas

webinar = ZabbixAPI(server="http://zabbix-webinar.sysadminqcoda.com")
webinar.login("api", "sysadminqcoda")

itens = webinar.item.get({
    "output": "extend",
    "filter": {"state": 1}
})

# transforma dict em json
dados = json.dumps(itens)
# ler json pelo pandas
dados_json = pandas.read_json(dados)
# converte para csv
dados_json.to_csv('rel_itens_nao_suportados.csv', mode='w')

# escreve total
toCSV = csv.writer(open("rel_itens_nao_suportados.csv", "a"))
toCSV.writerow(["Total de itens nao suportados: ", len(itens)])