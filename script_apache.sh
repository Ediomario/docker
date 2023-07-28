
#!/bin/bash

docker volume create dbData

#Criar container Banco de dados MariaDB
docker run --name mariadb -t \
             -e MYSQL_DATABASE="sitebase" \
             -e MYSQL_USER="user" \
             -e MYSQL_PASSWORD="pass_wd" \
             -e MYSQL_ROOT_PASSWORD="mariadb" \
             --network=bridge \
             --restart unless-stopped \
             -v ./dbData:/var/lib/mysql \
             -p 3306:3306 \
             -d mariadb:10.6 \
             --character-set-server=utf8 --collation-server=utf8_bin \
             --default-authentication-plugin=mysql_native_password

# Criar diretorio na raiz root para ser mapeado
mkdir -p ./html/www
#Criar container Apache+PhP
docker run --name php-apache  \
             --network=bridge \
             --restart unless-stopped \
             -p 80:80 \
             -v ./html/www/:/var/www/html \
             -d php:7.4-apache
