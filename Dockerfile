
FROM debian:jessie

MAINTAINER Georges Alkhouri <georges.alkhouri@gmail.com>
MAINTAINER Natanael Arndt <arndt@informatik.uni-leipzig.de>

ENV DEBIAN_FRONTEND noninteractive
ENV PWDDBA dba

RUN apt-get update

# install dependencies for virtuoso
RUN apt-get install -y libldap-2.4-2 libssl1.0.0 unixodbc

COPY virtuoso-minimal_7.2_all.deb /
COPY virtuoso-opensource-7-bin_7.2_amd64.deb /
COPY libvirtodbc0_7.2_amd64.deb /
COPY virtuoso.ini.dist /
COPY run.sh /bin/

RUN dpkg  -i virtuoso-minimal_7.2_all.deb \
          virtuoso-opensource-7-bin_7.2_amd64.deb \
          libvirtodbc0_7.2_amd64.deb

EXPOSE 1111
EXPOSE 8890

VOLUME /var/lib/virtuoso/db
WORKDIR /var/lib/virtuoso/db
