#!/bin/bash

# install 1C Enterprise server requirements from custom packages
curl -LJO https://raw.githubusercontent.com/kostik-pl/rhel8-public/main/SRV1C_host/msttcorefonts-2.5-1.noarch.rpm
dnf localinstall -y msttcorefonts-2.5-1.noarch.rpm

# install 1C Enterprise requirements from repositories
dnf install -y libpng12 #fontconfig libgsf freetype glib2 bzip2

# install 1C Enterprise server packages from work dir
rm /etc/rc.d/init.d/srv1cv83
#Download form GOOGLE
filename="setup-full-8.3.21.1302-x86_64.run"
fileid="1-a8DWtOLPhGgpow92x6ziFYPCE4lXlOc"
html=`curl -c ./cookie -s -L "https://drive.google.com/uc?export=download&id=${fileid}"`
curl -Lb ./cookie "https://drive.google.com/uc?export=download&`echo ${html}|grep -Po '(confirm=[a-zA-Z0-9\-_]+)'`&id=${fileid}" -o ${filename}
#Donload from DROPBOX
#curl -LJO https://www.dropbox.com/s/88q19pt9of2qok0/setup-full-8.3.20.1789-x86_64.run?dl=0
chmod +x setup-full-8.3.21.1302-x86_64.run
#ATTENTION! Batch installation will always install the 1c client and, if missing, the trimmed GNOME
#./setup-full-8.3.20.1789-x86_64.run --mode unattended --enable-components server,server_admin,ws,uk,ru
#We use pre-installed GNOME and manual installation
./setup-full-8.3.21.1302-x86_64.run

sed -i 's/Environment=SRV1CV8_DEBUG=\n/Environment=SRV1CV8_DEBUG=1/\n' /opt/1cv8/x86_64/8.3.21.1302/srv1cv8-8.3.21.1302@.service
sed -i 's/Environment=SRV1CV8_DATA=/home/usr1cv8/.1cv8/1C/1cv8\n/Environment=SRV1CV8_DATA=\/_data\/srv1c_inf_log/\n' /opt/1cv8/x86_64/8.3.21.1302/srv1cv8-8.3.21.1302@.service


ln /opt/1cv8/x86_64/8.3.21.1302/srv1cv8-8.3.21.1302@{,default}.service
systemctl link /opt/1cv8/x86_64/8.3.21.1302/srv1cv8-8.3.21.1302@default.service
curl -LJO https://raw.githubusercontent.com/kostik-pl/rhel8-public/main/SRV1C_host/ras1cv83.service
cp ras1cv83.service /etc/systemd/system/
systemctl enable ras1cv83
