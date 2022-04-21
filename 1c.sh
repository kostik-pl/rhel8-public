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
#ATTENTION! Batch installation will always install the 1c client and, if missing, the trimmed GNOME
#./setup-full-8.3.20.1789-x86_64.run --mode unattended --enable-components server,server_admin,ws,uk,ru
#We use pre-installed GNOME and manual installation
./setup-full-8.3.20.1789-x86_64.run

ln -s /opt/1cv8/x86_64/8.3.20.1789/srv1cv83 /etc/init.d/srv1cv83
ln -s /opt/1cv8/x86_64/8.3.20.1789/srv1cv83.conf /etc/sysconfig/srv1cv83
sed -i 's/#SRV1CV8_DEBUG=/SRV1CV8_DEBUG=1/' /etc/sysconfig/srv1cv83
sed -i 's/#SRV1CV8_DATA=/SRV1CV8_DATA=\/_data\/srv1c_inf_log/' /etc/sysconfig/srv1cv83
chkconfig --add srv1cv83
chkconfig srv1cv83 on

curl -LJO https://raw.githubusercontent.com/kostik-pl/rhel8-public/main/SRV1C_host/ras1cv83.service
cp ras1cv83.service /etc/systemd/system/
systemctl enable ras1cv83
