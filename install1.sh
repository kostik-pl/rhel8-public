#!/bin/bash

#Setup PODMAN
dnf -y module install container-tools
dnf -y install podman-docker
sed -i 's/graphroot = "\/var\/lib\/containers\/storage"/graphroot = "\/_container"/g' /etc/containers/storage.conf
#Create adn configure rootless user for pomdman
#sudo useradd -m -p $(perl -e 'print crypt($ARGV[0], "password")' 'RheujvDhfub72') podman
#mkdir -p /home/podman/.config/systemd/user

podman run --name pgpro -d -v /_data:/_data docker.io/kostikpl/rhel8:pgpro-rhel8
