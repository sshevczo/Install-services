#!/bin/bash




#Unistall docker 
sudo apt-get purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras


#Delete images, contsiners, volumes
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd
