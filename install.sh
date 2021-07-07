#!/bin/bash

#Setup system
dnf -y update
dnf -y install mc
dnf -y install pcp-system-tools
systemctl enable pmcd
sed -i 's/enforcing/disabled/g' /etc/selinux/config

#Setup disk
FILE1="/dev/disk/by-label/_container"
DISK1="/dev/disk/by-label/_container /_container auto nosuid,nodev,nofail,x-gvfs-show 0 0"
FILE2="/dev/disk/by-label/_data"
DISK2="/dev/disk/by-label/_data /_data auto nosuid,nodev,nofail,x-gvfs-show 0 0"
if [ -L "$FILE1" ]
then
    if ! grep -q '/_container' /etc/fstab ; then
	printf "$DISK1\n" >> /etc/fstab
    fi
else
    echo "Disk labeled as $FILE1 not found"
    exit 1
fi
if [ -L "$FILE2" ]
then
    if ! grep -q '/_data' /etc/fstab ; then
	printf "$DISK2\n" >> /etc/fstab
    fi
else
    echo "Disk labeled as $FILE2 not found"
    exit 1
fi


#Reboot
reboot
