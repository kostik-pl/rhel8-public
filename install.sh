#!/bin/bash

#Setup system
dnf -y update
dnf -y install mc
dnf -y install pcp-system-tools
systemctl enable pmcd
sed 's/enforcing/disabled/g' /etc/selinux/config

#Setup disk
disk1="/dev/disk/by-label/_container /_container auto nosuid,nodev,nofail,x-gvfs-show 0 0"
disk2="/dev/disk/by-label/_data /_data auto nosuid,nodev,nofail,x-gvfs-show 0 0"
if ! grep -q '/_container' /etc/fstab ; then
	printf "$disk1\n" >> /etc/fstab
fi
if ! grep -q '/_data' /etc/fstab ; then
	printf "$disk2\n" >> /etc/fstab
fi

#Reboot
reboot
