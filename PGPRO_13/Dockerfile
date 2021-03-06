FROM registry.access.redhat.com/ubi8/ubi:8.4

ENV LANG=ru_RU.UTF-8
# add locales
RUN dnf install -y glibc-langpack-ru
# update from repository
RUN dnf update -y

# Set POSTGRES PRO variables
ENV PGDATA=/_data/pg_data

# explicitly set user/group IDs and data dir
RUN groupadd -r postgres --gid=9999 ; \
    useradd -r -g postgres --uid=9999 postgres ; \
    mkdir -p $PGDATA ; \
    chown -R postgres:postgres $PGDATA ; \
    chmod 700 $PGDATA

# add repository to list
RUN dnf install -y http://repo.postgrespro.ru/pgpro-13/keys/postgrespro-std-13.rhel.yum-13-0.3.noarch.rpm

# install packages
RUN dnf install -y postgrespro-std-13-server postgrespro-std-13-client postgrespro-std-13-libs postgrespro-std-13-contrib

# change settings
RUN sed -ri "s!^#?(listen_addresses)\s*=\s*\S+.*!\1 = '*'!" /opt/pgpro/std-13/share/postgresql.conf.sample ; \
    sed -ri "s!^#?(logging_collector)\s*=\s*\S+.*!\1 = on!" /opt/pgpro/std-13/share/postgresql.conf.sample ; \
    sed -ri "s!^#?(log_directory)\s*=\s*\S+.*!\1 = 'log'!" /opt/pgpro/std-13/share/postgresql.conf.sample ; \
    sed -ri "s!^#?(lc_messages)\s*=\s*\S+.*!\1 = 'C.UTF-8'!" /opt/pgpro/std-13/share/postgresql.conf.sample

# dnf cache clean
RUN dnf clean all

# setup for start
ENV PATH $PATH:/opt/pgpro/std-13/bin
COPY pgpro-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/pgpro-entrypoint.sh

# change user
USER postgres

EXPOSE 5432

ENTRYPOINT ["pgpro-entrypoint.sh"]

CMD ["postgres"]
