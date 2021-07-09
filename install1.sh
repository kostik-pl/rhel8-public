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

#if [ ! -d "/_data/pg_data" ] ; then
#    mkdir /_data/pg_data
#fi
#chown -R postgres:postgres /_data/pg_data
#chmod -R 40700 /_data/pg_data

#Start PGPRO container and restore database
podman run --name pgpro -d -v /_data:/_data docker.io/kostikpl/rhel8:pgpro-11.12.1_rhel-8.4
podman exec -ti pgpro psql -f /_data/pg_backup/work.out  postgres
