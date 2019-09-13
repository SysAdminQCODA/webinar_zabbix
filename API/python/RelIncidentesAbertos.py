# -*- coding: utf-8 -*-

from zabbix_api import ZabbixAPI

webinar = ZabbixAPI(server="http://zabbix-webinar.sysadminqcoda.com")
webinar.login("api", "sysadminqcoda")

incidentes = webinar.trigger.get({
    "output": ["description", "lastchange"],
    "selectHosts": ["hostid", "host"],
    "selectLastEvent": ["eventid", "acknowledged", "objectid", "clock", "ns"],
    "sortfield": "lastchange",
    "monitored": "true",
    "only_true": "true",
    "maintenance": "false",
    "expandDescription": True,
    "filter": {"value": 1}
})

print(incidentes)