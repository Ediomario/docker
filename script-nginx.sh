#!/bin/bash

# Criar diretorio para ser mapeado
mkdir -p ./docker-nginx

#Docker installl conteiner
docker run --name nginx --restart=always -p 80:80 -d -v ~/docker-nginx/html:/usr/share/nginx/html nginx
