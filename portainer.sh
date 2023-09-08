#!/bin/bash

#Install Portainer --- Gerenciador de container

cd 
docker volume create portainer_data

docker run -d \
	-p 8000:8000 \
	-p 7900:9000 \
	--name portainer \
	--restart=always \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v portainer_data:/data portainer/portainer-ce


#Templates:
#alterar repositorio portainer em settiings
#colaressa URL

#https://raw.githubusercontent.com/Lissy93/portainer-templates/main/templates.json

#https://raw.githubusercontent.com/SelfhostedPro/selfhosted_templates/master/Template/portainer-v2.json
