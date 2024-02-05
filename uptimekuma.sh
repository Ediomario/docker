#!/bin/bash

cd
docker volume create uptime-kuma

docker run -d \
             -m 512m \
             --memory-swap 1G \
             --cpus 0.25 \
              --restart=always \
              -p 3001:3001 \
              -v uptime-kuma:/app/data \
              --name kuma louislam/uptime-kuma:latest
