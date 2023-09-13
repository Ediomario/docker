#!/bin/bash

# Criar volume para manter dados presistente no container
cd
docker volume create uptime-kuma

# Criar container com configurações restritas
docker run -d \
             -m 512m \
             --memory-swap 1G \
             --cpus 0.25 \
              --restart=always \
              -p 3001:3001 \
              -v uptime-kuma:/app/data \
              --name kuma louislam/uptime-kuma:latest
