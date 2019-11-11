#!/usr/bin/env bash
sudo docker rm -v -f "/mockserver" || true
sudo docker run -d -P --name=mockserver --restart=always -p 1080:1080 jamesdbloom/mockserver