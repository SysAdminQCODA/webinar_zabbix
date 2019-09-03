#!/bin/bash

wget http://repo.zabbix.com/zabbix/3.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_3.4-1+xenial_all.deb
dpkg -i zabbix-release_3.4-1+xenial_all.deb
apt update
apt-get install zabbix-agent
systemctl enable zabbix-agent
sed -i 's/^Server.*/Server=54.36.200.14/g' /etc/zabbix/zabbix_agentd.conf
systemctl start zabbix-agent
