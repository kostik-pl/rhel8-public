# rhel8-public
mkdir install
su root
cd install
curl -LJO https://raw.githubusercontent.com/kostik-pl/rhel8-public/main/install.sh
bash install.sh
# Скопировать файли установки 1С в install
curl -LJO https://raw.githubusercontent.com/kostik-pl/rhel8-public/main/install1.sh
bash install1.sh
