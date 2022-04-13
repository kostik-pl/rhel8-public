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

#Change access rights
if [ ! -d "/_data/httpd" ] ; then
    mkdir /_data/httpd
fi
if [ ! -d "/_data/httpd" ] ; then
    mkdir /_data/httpd
fi
if [ ! -f "/_data/httpd/conf/extra/httpd-1C-pub.conf" ] ; then
    mkdir /_data/httpd/conf
    mkdir /_data/httpd/conf/extra
    curl -LJO https://github.com/kostik-pl/rhel8-public/raw/main/HTTPD/httpd-1C-pub.conf
    cp httpd-1C-pub.conf /_data/httpd/conf/extra
fi
if [ ! -f "/_data/httpd/pub_1c/default.vrd" ] ; then
    mkdir /_data/httpd/pub_1c
    curl -LJO https://github.com/kostik-pl/rhel8-public/raw/main/HTTPD/default.vrd
    cp default.vrd /_data/httpd/pub_1c
fi
if [ ! -d "/_data/pg_backup" ] ; then
    mkdir /_data/pg_backup
fi
if [ ! -d "/_data/srv1c_inf_log" ] ; then
    mkdir /_data/srv1c_inf_log
fi
chown -R root:root /_data
chmod -R 777 /_data
chown -R root:root /_container
chmod -R 700 /_container
chown -R root:root /_data/httpd
chmod -R 700 /_data/httpd
chown -R postgres:postgres /_data/pg_backup
chmod -R 777 /_data/pg_backup
chown -R postgres:postgres /_data/pg_data
chmod -R 700 /_data/pg_data
chown -R usr1cv8:grp1cv8 /_data/srv1c_inf_log
chmod -R 700 /_data/srv1c_inf_log

#Clean old 1c work directory
shopt -s extglob
rm -rf /_data/srv1c_inf_log/reg_1541/!(*.lst)
shopt -u extglob

#Change firewall rules
curl -LJO https://github.com/kostik-pl/rhel8-public/raw/main/public.xml
cp public.xml /etc/firewalld/zones/
firewall-cmd --reload

HOSTNAME=`hostname`

#Start PGPRO container and restore database
podman run --name pgpro --ip 10.88.0.2 --hostname $HOSTNAME -dt -p 5432:5432 -v /_data:/_data docker.io/kostikpl/rhel8:pgpro-14.2.1_rhel-ubi-8.5
podman generate systemd --new --name pgpro > /etc/systemd/system/pgpro.service
systemctl enable --now pgpro
podman exec -ti pgpro psql -c "ALTER USER postgres WITH PASSWORD RheujvDhfub12;"
podman exec -ti pgpro psql -c "ALTER USER srv1c WITH PASSWORD '\'\$'GitybwZ ''-'' ZxvtyM'\$\';"

#Install HASP
curl -LJO https://raw.githubusercontent.com/kostik-pl/rhel8-public/main/hasp.sh
bash hasp.sh

#Start SRV1C container and restore database
#podman run --name srv1c --ip 10.88.0.3 --hostname $HOSTNAME --add-host=pgpro.local:10.88.0.2 -dt -p 80:80 -p 1540-1541:1540-1541 -p 1545:1545 -p 1560-1591:1560-1591 -v /_data:/_data -v /dev/bus/usb:/dev/bus/usb docker.io/kostikpl/rhel8:srv1c-8.3.1_rhel-ubi-init-8.4
#podman generate systemd --new --name srv1c > /etc/systemd/system/srv1c.service
#systemctl enable --now srv1c

#Install 1C Enterprise server and httpd(Apache)
curl -LJO https://raw.githubusercontent.com/kostik-pl/rhel8-public/main/1c.sh
bash 1c.sh

#Clean
dnf clean all
