FROM samirkherraz/alpine-s6

ENV GRAV_VERSION=1.5.3
ENV GRAV_ADMIN_USERNAME="admin"
ENV GRAV_ADMIN_PASSWORD="aQm445WYn"
ENV GRAV_ADMIN_EMAIL="samir.kherraz@outlook.fr"
ENV GRAV_ADMIN_FIRSTNAME="Samir"
ENV GRAV_ADMIN_LASTNAME="KHERRAZ"

RUN set -x \
    && apk --no-cache --virtual add php7 php7-fpm php7-curl php7-ctype php7-dom php7-gd php7-json php7-mbstring php7-openssl php7-session php7-simplexml php7-xml php7-zip php7-memcached php7-yaml  

RUN set -x \
    && apk --no-cache --virtual add nginx \
    && mkdir -p /var/www/ /run/nginx/ \
    && chown nginx:nginx /var/www/ /run/nginx/

RUN set -x \
    && wget https://getgrav.org/download/core/grav-admin/${GRAV_VERSION} -O /var/www/${GRAV_VERSION}.zip \
    && su - nginx -s /bin/ash -c "cd /var/www/ && unzip ${GRAV_VERSION}.zip && mv grav-admin html" \
    && rm /var/www/${GRAV_VERSION}.zip


RUN set -x \
    && su - nginx -s /bin/ash -c 'cd /var/www/html && \ 
    ./bin/plugin login new-user -u "'${GRAV_ADMIN_USERNAME}'" -p "'${GRAV_ADMIN_PASSWORD}'" -e "'${GRAV_ADMIN_EMAIL}'" -N "'${GRAV_ADMIN_FIRSTNAME}' '${GRAV_ADMIN_LASTNAME}'" -P b \
    && ./bin/gpm self-upgrade'

RUN set -x \
    && rm /etc/nginx/conf.d/* \
    && rm /etc/php7/php-fpm.d/* 

ADD init/* /etc/cont-init.d/

RUN set -x \
    && chmod +x /etc/cont-init.d/*

ADD phpfpm/* /etc/php7/php-fpm.d/
ADD nginx/* /etc/nginx/conf.d/




