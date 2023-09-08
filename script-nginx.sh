#!/bin/bash

# -m= memoria RAM total
# --cpus= processador total
# --memory-swap= total memoria RAM swap
# -v= Mapeamento pasta local
# -p= mapeamento porta de acesso

# Criar diretorio para ser mapeado
mkdir -p ./docker-nginx

#Docker installl conteiner

docker run -d \
	--memory-swap 2G \
	-m 1G \
	--cpus 1 \
	--name nginx \
	--restart=always \
	-p 80:80 \
	-v ~/docker-nginx/html:/usr/share/nginx/html nginx
