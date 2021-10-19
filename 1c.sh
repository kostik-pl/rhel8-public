INSTALL_PATH='/home/sa.dru/install'
# install 1C Enterprise server requirements from custom packages
dnf localinstall -y $INSTALL_PATH/webkitgtk3-2.4.11-7.el8.x86_64.rpm
dnf localinstall -y $INSTALL_PATH/msttcorefonts-2.5-1.noarch.rpm

# install 1C Enterprise requirements from repositories
dnf install -y libpng12 fontconfig libgsf freetype glib2 bzip2

# install 1C Enterprise server packages from work dir
dnf localinstall -y $INSTALL_PATH/1C_Enterprise*.rpm
#sed -i '4iSRV1CV8_DEBUG=1' /etc/init.d/srv1cv83
#sed -i '5iSRV1CV8_DATA=/_data/srv1c_inf_log' /etc/init.d/srv1cv83
rm /etc/rc.d/init.d/srv1cv83
curl -LJO https://raw.githubusercontent.com/kostik-pl/rhel8-public/main/SRV1C_host/srv1cv83
cp srv1cv83 /etc/sysconfig/
curl -LJO https://raw.githubusercontent.com/kostik-pl/rhel8-public/main/SRV1C_host/srv1cv83.service
cp srv1cv83.service /etc/systemd/system/
curl -LJO https://raw.githubusercontent.com/kostik-pl/rhel8-public/main/SRV1C_host/srv1cv83-ras.service
cp srv1cv83-ras.service /etc/systemd/system/
systemctl enable --now srv1cv83
systemctl enable --now srv1cv83-ras

# install httpd
dnf -y install httpd
mkdir -p /_data/httpd
chown root:root /_data/httpd
chmod 700 /_data/httpd
printf "\nInclude /_data/httpd/conf/extra/httpd-1C-pub.conf\n" >> /etc/httpd/conf/httpd.conf
systemctl enable --now httpd
