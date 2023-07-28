#!/bin/bash

# Criar rede interna para integrar zabbix+postgres+grafana

docker network create -d bridge rede-interna --subnet 172.20.0.0/28

sudo docker run --name postgres-server -t \
      -e POSTGRES_USER="zabbix" \
      -e POSTGRES_PASSWORD="zabbix_pwd" \
      -e POSTGRES_DB="zabbix" \
      --network=rede-interna \
      --restart unless-stopped \
      -d postgres:latest

sudo docker run --name zabbix-snmptraps -t \
      -v /zbx_instance/snmptraps:/var/lib/zabbix/snmptraps:rw \
      -v /var/lib/zabbix/mibs:/usr/share/snmp/mibs:ro \
      --network=rede-interna \
      -p 162:1162/udp \
      --restart unless-stopped \
      -d zabbix/zabbix-snmptraps:alpine-6.4-latest

sudo docker run --name zabbix-server-pgsql -it \
      -e DB_SERVER_HOST="postgres-server" \
      -e POSTGRES_USER="zabbix" \
      -e POSTGRES_PASSWORD="zabbix_pwd" \
      -e POSTGRES_DB="zabbix" \
      -e ZBX_ENABLE_SNMP_TRAPS="true" \
      -e DB_SERVER_HOST="postgres-server" \
      -e POSTGRES_USER="zabbix" \
      -e POSTGRES_PASSWORD="zabbix_pwd" \
      -e POSTGRES_DB="zabbix" \
      -e ZBX_ENABLE_SNMP_TRAPS="true" \
      -e ZBX_STARTPOLLERS="20" \
      -e ZBX_STARTPINGERS="20" \
      -e ZBX_CACHESIZE="64M" \
      -e ZBX_HISTORYCACHESIZE="32M" \
      -e ZBX_HISTORYINDEXCACHESIZE="16M" \
      -e ZBX_TRENDCACHESIZE="16M" \
      -e ZBX_VALUECACHESIZE="32M" \
      --network=rede-interna \
      -p 10051:10051 \
      --volumes-from zabbix-snmptraps \
      --restart unless-stopped \
      -d zabbix/zabbix-server-pgsql:alpine-6.4-latest
sudo docker run --name zabbix-web-nginx-pgsql -t \
      -e ZBX_SERVER_HOST="zabbix-server-pgsql" \
      -e DB_SERVER_HOST="postgres-server" \
      -e POSTGRES_USER="zabbix" \
      -e POSTGRES_PASSWORD="zabbix_pwd" \
      -e POSTGRES_DB="zabbix" \
      --network=rede-interna \
      -p 443:8443 \
      -p 80:8080 \
      -v /etc/ssl/nginx:/etc/ssl/nginx:ro \
      --restart unless-stopped \
      -d zabbix/zabbix-web-nginx-pgsql:alpine-6.4-latest

# Instalar Conteiner Grafana

docker volume create grafana-storage

docker run -d --name=grafana \
      -e "GF_SERVER_ROOT_URL=http://grafana.local" \
      -e "GF_SECURITY_ADMIN_PASSWORD=passwd" \
      -e "GF_INSTALL_PLUGINS=alexanderzobnin-zabbix-app" \
      -e "GF_PLUGINS_ALLOW_LOADING_USIGNED_PLUGINS=alexanderzobnin-zabbix-datasource" \
      --network=rede-interna \
        --restart unless-stopped \
      -p 3000:3000 \
      -v grafana-storage:/var/lib/grafana \
      grafana/grafana-enterprise

      
