## Instalndo Docker no linux usando um script

 ```sh
 curl -fsSL https://get.docker.com -o get-docker.sh
```
 ```sh
 sudo sh get-docker.sh
```
 ```sh
 sudo docker run hello-world
```
## Comandos Basicos Docker
  - Criar um container Nginx web server basico 
```sh
docker run --name nginx -d -p 80:80 nginx
```
  - Mostrar containers instalados
```sh
docker docker ps -a
```
  - Remover containers
```sh
docker rm -f {id}
```

## Docker Swarm
- Iniciar o Swarm na Aplicação Docker
  - Comando para criar o cluster swarm
 ```sh
docker swarm init --advertise-addr 192.168.XX.XX
```
  - Comando para promover um node para manager
```sh
docker node promote (hostname)
```
  - Subir serviços no Swarm

```sh
docker stack deploy -c docker-swarm.yml app
```
  - Comando para verificar os nodes do cluster
```sh
docker node ls
```

  - Remover um um node prara testar balanceamento de carga 
```sh
docker node rm (idnode)
```

  - Derrubar serviços no Swarm

```sh
docker stack rm app
```

  - Ver serviços em execução

```sh
docker service ls
```

  - Ver containers em execução

```sh
docker stats
```

- Atualizar servico no cluster
```sh
docker service update --force (nomedastack)
```
 
  - Entrar em um container:
```sh
# primeiro obtenha o id do container, pode ser via 'docker stats'
# com o id em mãos substitua '{id}' pelo id obtido
docker exec -it {id} bash
```

