#!/bin/bash

#Mariadb:

docker run --name mariadb -v /home/de:/var/lib/mysql \
 -e MYSQL_ROOT_PASSWORD=powerdns -d mariadb:latest

#Master server: 

docker run -d -p 53:53 -p 53:53/udp --name pdns-master \
  --hostname ns1.koti.local --link mariadb:mysql \
  -e PDNS_master=yes \
  -e PDNS_api=yes \
  -e PDNS_api_key=secret \
  -e PDNS_webserver=yes \
  -e PDNS_webserver_address=0.0.0.0 \
  -e PDNS_webserver_password=secret2 \
  -e PDNS_version_string=anonymous \
  -e PDNS_default_ttl=1500 \
  -e PDNS_soa_minimum_ttl=1200 \
  -e PDNS_default_soa_name=ns1.koti.local \
  -e PDNS_default_soa_mail=hostmaster.koti.local \
  -e PDNS_allow_axfr_ips=192.168.100.45 \
  -e PDNS_webserver-allow-from=172.17.0.0/24 \
  -e PDNS_only_notify=192.168.100.45 \
  pschiffe/pdns-mysql

#webadmin:

docker run -d --name pdns-admin-uwsgi \
  --link mariadb:mysql --link pdns-master:pdns \
    pschiffe/pdns-admin-uwsgi:ngoduykhanh

docker run -d -p 8080:80 --name pdns-admin-static \
  --link pdns-admin-uwsgi:pdns-admin-uwsgi \
  pschiffe/pdns-admin-static:ngoduykhanh

#Slave server: 

docker run -d -p 53:53 -p 53:53/udp --name pdns-slave \
  --hostname ns2.koti.local --link mariadb:mysql \
  -e PDNS_gmysql_dbname=powerdnsslave \
  -e PDNS_slave=yes \
  -e PDNS_version_string=anonymous \
  -e PDNS_disable_axfr=yes \
  -e PDNS_allow_notify_from=192.168.100.160 \
  -e SUPERMASTER_IPS=192.168.100.160 \
  pschiffe/pdns-mysql
