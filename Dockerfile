FROM ubuntu:14.04
MAINTAINER senggen <jackiecui@gmail.com>

# ENV DEBIAN_FRONTEND noninteractive

RUN echo "deb http://cn.archive.ubuntu.com/ubuntu/ trusty main universe restricted multiverse" > /etc/apt/sources.list \
    && echo "deb http://security.ubuntu.com/ubuntu trusty-security main universe restricted multiverse" > /etc/apt/sources.list \
    && echo "deb http://cn.archive.ubuntu.com/ubuntu/ trusty-updates main universe restricted multiverse" > /etc/apt/sources.list 
RUN apt-get update && \
    apt-get -y dist-upgrade

RUN apt-get -y install php5 php5-fpm php5-gd php5-ldap \
    php5-sqlite php5-pgsql php-pear php5-mysql \
    php5-mcrypt php5-xcache php5-xmlrpc

RUN sed -i '/daemonize /c \
daemonize = no' /etc/php5/fpm/php-fpm.conf

RUN sed -i '/^listen /c \
listen = 0.0.0.0:9000' /etc/php5/fpm/pool.d/www.conf

RUN sed -i 's/^listen.allowed_clients/;listen.allowed_clients/' /etc/php5/fpm/pool.d/www.conf

RUN mkdir -p /srv/http && \
    echo "<?php phpinfo(); ?>" > /srv/http/index.php && \
    chown -R www-data:www-data /srv/http

EXPOSE 9000
VOLUME /srv/http
ENTRYPOINT ["php5-fpm"]