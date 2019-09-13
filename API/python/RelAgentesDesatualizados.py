# -*- coding: utf-8 -*-

from zabbix_api import ZabbixAPI

webinar = ZabbixAPI(server="http://zabbix-webinar.sysadminqcoda.com")
webinar.login("api", "sysadminqcoda")

agent = webinar.item.get({
    "groupids": "2",
    "filter": {"key_": "agent.version"},
    "output": [
        "lastvalue",
        "hostid"
    ]
})

versao = "4.0"

for i in agent:
    if i["lastvalue"] < versao:
        host = webinar.host.get({"hostids":i['hostid'], "output": ["name"]})
        print(i["hostid"], host[0]["name"], i["lastvalue"])