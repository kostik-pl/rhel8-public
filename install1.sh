#!/bin/bash

#Setup PODMAN
dnf -y module install container-tools
dnf -y install podman-docker
sed -i 's/graphroot = "\/var\/lib\/containers\/storage"/graphroot = "\/_container"/g' /etc/containers/storage.conf
#Create adn configure rootless user for pomdman
#sudo useradd -m -p $(perl -e 'print crypt($ARGV[0], "password")' 'RheujvDhfub72') podman
#mkdir -p /home/podman/.config/systemd/user

#Add GROUP and USER same as in container
groupadd -r postgres --gid=9999
useradd -r -M -g postgres --uid=9999 postgres
groupadd -r srv1c --gid=9998
useradd -r -M -g srv1c --uid=9998 srv1c

#Check access rights
chown -R root:root /_data
chown -R root:root /_container
chmod -R 40777 /_data
chmod -R 40700 /_container

if [ ! -d "/_data/pg_backup" ] ; then
    mkdir /_data/pg_backup
fi
chown -R postgres:postgres /_data/pg_backup
chmod -R 40700 /_data/pg_backup

#Start PGPRO container and restore database
podman run --name pgpro --ip 10.88.0.2 --hostname pgpro.local -dt -p 5432:5432 -v /_data:/_data docker.io/kostikpl/rhel8:pgpro-11.12.1_rhel-8.4
podman generate systemd --new --name pgpro > /etc/systemd/system/pgpro.service
systemctl enable --now pgpro

#Start SRV1C container and restore database
podman run --name srv1c --ip 10.88.0.3 --hostname rhel8.local --add-host=pgpro.local:10.88.0.2 -dt -p 1540-1541:1540-1541 -p 1560-1591:1560-1591 -v /_data:/_data docker.io/kostikpl/rhel8:srv1c-8.3.1_rhel-8.4
podman generate systemd --new --name srv1c > /etc/systemd/system/srv1c.service
systemctl enable --now srv1c
