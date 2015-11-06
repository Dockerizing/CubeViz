
FROM debian:jessie

MAINTAINER Georges Alkhouri <georges.alkhouri@gmail.com>
MAINTAINER Natanael Arndt <arndt@informatik.uni-leipzig.de>

ENV DEBIAN_FRONTEND noninteractive
ENV PWDDBA dba

RUN apt-get update

# install dependencies
RUN apt-get install -y libldap-2.4-2 libssl1.0.0 unixodbc wget make git nginx-light \
    php5=5.6.7+dfsg-1 php5-fpm=5.6.7+dfsg-1 php5-common=5.6.7+dfsg-1 php5-cli=5.6.7+dfsg-1 \
    php5-odbc=5.6.7+dfsg-1 php5-curl=5.6.7+dfsg-1 nano

# install Virtuoso
COPY virtuoso-minimal_7.2_all.deb /
COPY virtuoso-opensource-7-bin_7.2_amd64.deb /
COPY libvirtodbc0_7.2_amd64.deb /
COPY virtuoso.ini.dist /

RUN dpkg  -i virtuoso-minimal_7.2_all.deb \
          virtuoso-opensource-7-bin_7.2_amd64.deb \
          libvirtodbc0_7.2_amd64.deb

# install OntoWiki
RUN rm -rf /var/www/*
RUN git clone https://github.com/AKSW/OntoWiki.git /var/www/
RUN cd /var/www/ && make deploy
RUN cp /var/www/config.ini.dist /var/www/config.ini

# install CubeViz extensions
RUN git clone https://github.com/AKSW/cubeviz.ontowiki.git /var/www/extensions/cubeviz
RUN cd /var/www/extensions/cubeviz && git checkout master && make install

# configure the OntoWiki site for Nginx
COPY ontowiki-nginx.conf /etc/nginx/sites-available/
RUN rm /etc/nginx/sites-enabled/default
RUN ln -s /etc/nginx/sites-available/ontowiki-nginx.conf /etc/nginx/sites-enabled/
COPY odbc.ini /etc/


#config php
RUN echo "upload_max_filesize = 100M" >> /etc/php5/fpm/php.ini
RUN echo "post_max_size = 100M" >> /etc/php5/fpm/php.ini
RUN echo "request_terminate_timeout = 3600" >> /etc/php5/fpm/php.ini

EXPOSE 1111
EXPOSE 8890
EXPOSE 80

VOLUME /import
VOLUME /var/lib/virtuoso/db

COPY run.sh /bin/
COPY import.sh /bin/

CMD ["run.sh"]
