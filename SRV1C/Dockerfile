FROM registry.access.redhat.com/ubi8/ubi-init

ENV LANG=ru_RU.UTF-8
# add locales
RUN dnf install -y glibc-langpack-ru
# update from repository
RUN dnf update -y

RUN dnf install -y realmd sssd oddjob oddjob-mkhomedir adcli samba-common samba-common-tools krb5-workstation authselect-compat

#Set 1C Enterprise variables
ENV SRV1CV8_DATA=/_data/srv1c_inf_log
ENV SRV1CV8_DEBUG=1
ARG INSTALL_PATH=/root/srv1c

# explicitly set user/group IDs and data dir
RUN groupadd -r grp1cv8 --gid=9998 ; \
    useradd -r -g grp1cv8 --uid=9998 usr1cv8 ; \
    mkdir -p /home/usr1cv8 ; \
    chown usr1cv8:grp1cv8 /home/usr1cv8 ; \
    chmod 700 /home/usr1cv8 ; \
    mkdir -p $SRV1CV8_DATA ; \
    chown usr1cv8:grp1cv8 $SRV1CV8_DATA ; \
    chmod 700 $SRV1CV8_DATA

# create install environment
RUN mkdir -p $INSTALL_PATH

# copy install files from build context
COPY install $INSTALL_PATH

# install 1C requirements from local files (webkitgtk3 not found in repository)
RUN dnf localinstall -y $INSTALL_PATH/webkitgtk3-2.4.11-7.el8.x86_64.rpm
RUN dnf localinstall -y $INSTALL_PATH/msttcorefonts-2.5-1.noarch.rpm

# install 1C Enterprise requirements from repositories
RUN dnf install -y libpng12 fontconfig libgsf freetype glib2 bzip2

# install 1C Enterprise server packages from work dir
RUN dnf localinstall -y $INSTALL_PATH/1C_Enterprise*.rpm
RUN rm /etc/rc.d/init.d/srv1cv83
RUN rm -rf $INSTALL_PATH
COPY srv1cv83.service /etc/systemd/system
RUN systemctl enable srv1cv83
COPY srv1cv83-ras.service /etc/systemd/system
RUN systemctl enable srv1cv83-ras

# install httpd
RUN yum -y install httpd; yum clean all; systemctl enable httpd
RUN mkdir -p /_data/httpd ; \
    chown root:root /_data/httpd ; \
    chmod 700 /_data/httpd
RUN printf "\nInclude /_data/httpd/conf/extra/httpd-1C-pub.conf\n" >> /etc/httpd/conf/httpd.conf

# dnf cache clean
RUN dnf clean all

EXPOSE 80
CMD [ "/sbin/init" ]
