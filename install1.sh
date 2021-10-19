#!/bin/bash

#Setup PODMAN
dnf -y module install container-tools
dnf -y install podman-docker
sed -i 's/graphroot = "\/var\/lib\/containers\/storage"/graphroot = "\/_container"/g' /etc/containers/storage.conf

#Add GROUP and USER same as in container
groupadd -r postgres --gid=9999
useradd -r -M -g postgres --uid=9999 postgres
groupadd -r grp1cv8 --gid=9998
useradd -r -M -g grp1cv8 --uid=9998 usr1cv8

#Check access rights
chown -R root:root /_data
chown -R root:root /_container
chmod -R 777 /_data
chmod -R 700 /_container

if [ ! -d "/_data/pg_backup" ] ; then
    mkdir /_data/pg_backup
fi
chown -R postgres:postgres /_data/pg_backup
chmod -R 700 /_data/pg_backup

HOSTNAME=`hostname`

#Start PGPRO container and restore database
podman run --name pgpro --ip 10.88.0.2 --hostname $HOSTNAME -dt -p 5432:5432 -v /_data:/_data docker.io/kostikpl/rhel8:pgpro-11.12.1_rhel-ubi-8.4
podman generate systemd --new --name pgpro > /etc/systemd/system/pgpro.service
systemctl enable --now pgpro

#Start SRV1C container and restore database
#podman run --name srv1c --ip 10.88.0.3 --hostname $HOSTNAME --add-host=pgpro.local:10.88.0.2 -dt -p 80:80 -p 1540-1541:1540-1541 -p 1545:1545 -p 1560-1591:1560-1591 -v /_data:/_data -v /dev/bus/usb:/dev/bus/usb docker.io/kostikpl/rhel8:srv1c-8.3.1_rhel-ubi-init-8.4
#podman generate systemd --new --name srv1c > /etc/systemd/system/srv1c.service
#systemctl enable --now srv1c

#Install HASP
curl -LJO https://raw.githubusercontent.com/kostik-pl/rhel8-public/main/hasp.sh
bash hasp.sh

#Install 1C Enterprise server and httpd(Apache)
curl -LJO https://raw.githubusercontent.com/kostik-pl/rhel8-public/main/1c.sh
bash 1c.sh

#Clean
dnf clean all
