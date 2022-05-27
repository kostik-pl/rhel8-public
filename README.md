# rhel8-public
mkdir install
su root
cd install
curl -LJO https://raw.githubusercontent.com/kostik-pl/rhel8-public/main/install.sh
bash install.sh
# Скопировать файли установки 1С в install
curl -LJO https://raw.githubusercontent.com/kostik-pl/rhel8-public/main/install1.sh
bash install1.sh
#Восстановление базы из файла резервной копии созданого по комманде pg_dumpall > /_data/pg_backup/workout
chmod 744 /_data/pg_backup/workout
podman exec -ti pgpro bash
psql < /_data/pg_backup/workout
podman exec -ti pgpro psql -c "ALTER USER srv1c WITH PASSWORD '\$GitybwZ - ZxvtyM\$';"
