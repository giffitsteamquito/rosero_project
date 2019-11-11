#!/usr/bin/env bash
function setupSwarm(){
    if [[ "$(sudo docker info | grep Swarm | sed 's/Swarm: //g')" == "inactive" ]]; then
        sudo docker swarm init --advertise-addr=192.168.33.10;
    fi
}

setupSwarm


