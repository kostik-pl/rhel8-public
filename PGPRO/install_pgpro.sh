curl -LJO https://raw.githubusercontent.com/kostik-pl/rhel8-public/main/PGPRO/Dockerfile
curl -LJO https://raw.githubusercontent.com/kostik-pl/rhel8-public/main/PGPRO/RPM-GPG-KEY-POSTGRESPRO
curl -LJO https://raw.githubusercontent.com/kostik-pl/rhel8-public/main/PGPRO/pgpro-14.repo
curl -LJO https://raw.githubusercontent.com/kostik-pl/rhel8-public/main/PGPRO/pgpro-entrypoint.sh
podman build -t pgpro .
podman run --name pgpro --ip 10.88.0.2 --hostname pgpro.local -dt -p 5432:5432 -v /_data:/_data localhost/pgpro
podman login -u=kostikpl -p=RheujvDhfub12 docker.io
podman push pgpro docker.io/kostikpl/rhel8:pgpro-14.2.1_rhel-ubi-8.5

#podman run --name pgpro --ip 10.88.0.2 --hostname pgpro.local -dt -p 5432:5432 -v /_data:/_data docker.io/kostikpl/rhel8:rhel8:pgpro-14.2.1_rhel-ubi-8.5
#podman exec -ti pgpro psql -f /_data/pg_backup/work.out
