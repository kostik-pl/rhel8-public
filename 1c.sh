#!/bin/bash

# install 1C Enterprise server requirements from custom packages
curl -LJO https://raw.githubusercontent.com/kostik-pl/rhel8-public/main/SRV1C_host/msttcorefonts-2.5-1.noarch.rpm
dnf localinstall -y msttcorefonts-2.5-1.noarch.rpm

# install 1C Enterprise requirements from repositories
dnf install -y libpng12 #fontconfig libgsf freetype glib2 bzip2

# install 1C Enterprise server packages from work dir
rm /etc/rc.d/init.d/srv1cv83
curl -LJO https://www.dropbox.com/s/88q19pt9of2qok0/setup-full-8.3.20.1789-x86_64.run?dl=0
chmod +x setup-full-8.3.20.1789-x86_64.run
#./setup-full-8.3.20.1789-x86_64.run --mode unattended --enable-components server,server_admin,ws,uk,ru
#curl -LJO https://raw.githubusercontent.com/kostik-pl/rhel8-public/main/SRV1C_host/srv1cv83.service
#cp srv1cv83.service /etc/systemd/system/
#curl -LJO https://raw.githubusercontent.com/kostik-pl/rhel8-public/main/SRV1C_host/ras1cv83.service
#cp srv1cv83-ras.service /etc/systemd/system/
#systemctl enable srv1cv83
#systemctl enable srv1cv83-ras
