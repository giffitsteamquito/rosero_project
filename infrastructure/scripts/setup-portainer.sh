#!/usr/bin/env bash

sudo docker rm -v -f "/portainer" || true

sudo docker volume create "portainer_data"
sudo docker run -d --name=portainer --restart=always -p 9200:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer
