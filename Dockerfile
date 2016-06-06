FROM aksw/dld-present-ontowiki

MAINTAINER Georges Alkhouri <georges.alkhouri@gmail.com>
MAINTAINER Natanael Arndt <arndt@informatik.uni-leipzig.de>
MAINTAINER Simeon Ackerman <s.ackermann@mail.de>

ENV PWDDBA dba

# RUN apt-get update

# install dependencies
# RUN apt-get install -y libldap-2.4-2 libssl1.0.0 wget nano

# install Virtuoso
COPY virtuoso-minimal_7.2_all.deb /
COPY virtuoso-opensource-7-bin_7.2_amd64.deb /
COPY libvirtodbc0_7.2_amd64.deb /
COPY virtuoso.ini.dist /

RUN dpkg  -i virtuoso-minimal_7.2_all.deb \
          virtuoso-opensource-7-bin_7.2_amd64.deb \
          libvirtodbc0_7.2_amd64.deb

+# the latest ontowiki doenst work, ne need to go back to a8eb80ecc43f47b0bfc2584ae465e724b28c6bd2 (before using composer)
+RUN cd /var/www/ && git checkout a8eb80ecc43f47b0bfc2584ae465e724b28c6bd2
+RUN cd /var/www/ && make deploy

# install CubeViz extensions
RUN git clone https://github.com/AKSW/cubeviz.ontowiki.git /var/www/extensions/cubeviz
RUN cd /var/www/extensions/cubeviz && git checkout master && make install

#config php
RUN echo "upload_max_filesize = 100M" >> /etc/php5/fpm/php.ini
RUN echo "post_max_size = 100M" >> /etc/php5/fpm/php.ini
RUN echo "request_terminate_timeout = 3600" >> /etc/php5/fpm/php.ini

# configure odbc for virtuoso
ADD odbc.ini /etc/

EXPOSE 1111
EXPOSE 8890
EXPOSE 80

VOLUME /var/lib/virtuoso/db

COPY run.sh /bin/

CMD ["run.sh"]
