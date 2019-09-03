#!/bin/bash
# Autor: Ruan Carlos (ruan.oliveira@b2br.com.br)

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<zabbix_export>
    <version>3.4</version>
    <date>2017-12-11T23:19:24Z</date>
    <groups>
        <group>
            <name>Zabbix servers</name>
        </group>
    </groups>
    <hosts>
" > $1.xml

while IFS=, read col1
do
ip=$(echo $col1 | cut -d, -f2)
name=$(echo $col1 | cut -d, -f1)

			echo "
      <host>
          <host>$name</host>
          <name>$name</name>
          <description/>
          <proxy/>
          <status>0</status>
          <ipmi_authtype>-1</ipmi_authtype>
          <ipmi_privilege>2</ipmi_privilege>
          <ipmi_username/>
          <ipmi_password/>
          <tls_connect>1</tls_connect>
          <tls_accept>1</tls_accept>
          <tls_issuer/>
          <tls_subject/>
          <tls_psk_identity/>
          <tls_psk/>
          <templates>
              <template>
                  <name>Template_Apache_Stats</name>
              </template>
          </templates>
          <groups>
              <group>
                  <name>Zabbix servers</name>
              </group>
          </groups>
          <interfaces>
              <interface>
                  <default>1</default>
                  <type>1</type>
                  <useip>1</useip>
                  <ip>$ip</ip>
                  <dns/>
                  <port>10050</port>
                  <bulk>1</bulk>
                  <interface_ref>if1</interface_ref>
              </interface>
          </interfaces>
          <applications/>
          <items/>
          <discovery_rules/>
          <httptests/>
          <macros/>
          <inventory>
              <inventory_mode>1</inventory_mode>
              <type>Apache</type>
              <type_full/>
              <name/>
              <alias/>
              <os/>
              <os_full/>
              <os_short/>
              <serialno_a/>
              <serialno_b/>
              <tag/>
              <asset_tag/>
              <macaddress_a/>
              <macaddress_b/>
              <hardware/>
              <hardware_full/>
              <software/>
              <software_full/>
              <software_app_a/>
              <software_app_b/>
              <software_app_c/>
              <software_app_d/>
              <software_app_e/>
              <contact/>
              <location/>
              <location_lat/>
              <location_lon/>
              <notes/>
              <chassis/>
              <model/>
              <hw_arch/>
              <vendor/>
              <contract_number/>
              <installer_name/>
              <deployment_status/>
              <url_a/>
              <url_b/>
              <url_c/>
              <host_networks/>
              <host_netmask/>
              <host_router/>
              <oob_ip/>
              <oob_netmask/>
              <oob_router/>
              <date_hw_purchase/>
              <date_hw_install/>
              <date_hw_expiry/>
              <date_hw_decomm/>
              <site_address_a/>
              <site_address_b/>
              <site_address_c/>
              <site_city/>
              <site_state/>
              <site_country/>
              <site_zip/>
              <site_rack/>
              <site_notes/>
              <poc_1_name/>
              <poc_1_email/>
              <poc_1_phone_a/>
              <poc_1_phone_b/>
              <poc_1_cell/>
              <poc_1_screen/>
              <poc_1_notes/>
              <poc_2_name/>
              <poc_2_email/>
              <poc_2_phone_a/>
              <poc_2_phone_b/>
              <poc_2_cell/>
              <poc_2_screen/>
              <poc_2_notes/>
          </inventory>
      </host>
" >> $1.xml
done < arquivo

echo "
    </hosts>
</zabbix_export>
">> $1.xml
