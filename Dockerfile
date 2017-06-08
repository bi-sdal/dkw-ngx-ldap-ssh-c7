FROM dads2busy/c7-ssh-ldap-ngx
MAINTAINER "Aaron D. Schroeder" <aschroed@vt.edu>

## Install Prerequisites
RUN yum -y install php-fpm php-cli php-mcrypt php-gd php-ldap
RUN systemctl enable php-fpm

RUN groupadd  www
RUN useradd -g www -r -M www
RUN mkdir -p /var/www/dokuwiki /var/lib/php/session
RUN wget http://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz
RUN tar xzvf dokuwiki-stable.tgz --strip-components=1 -C /var/www/dokuwiki
RUN chown -R www:www /var/www /var/lib/php/session
COPY dokuwiki-entrypoint.sh /
COPY etc/ /etc/

EXPOSE 80

VOLUME [ \
    "/var/www/dokuwiki/data/pages", \
    "/var/www/dokuwiki/data/meta", \
    "/var/www/dokuwiki/data/media", \
    "/var/www/dokuwiki/data/media_attic", \
    "/var/www/dokuwiki/data/media_meta", \
    "/var/www/dokuwiki/data/attic", \
    "/var/www/dokuwiki/conf", \
    "/var/www/dokuwiki/lib/plugins", \
    "/var/log" \
]

ENTRYPOINT ["/dokuwiki-entrypoint.sh"]
CMD ["/lib/systemd/systemd"]
