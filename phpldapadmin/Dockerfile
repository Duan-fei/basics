FROM registry.cn-beijing.aliyuncs.com/shannonai/debian

COPY ./dependent/sources.list /etc/apt/sources.list

# runtime dependencies
RUN apt-get update -yqq\
        && apt-get install -yqq \
        php \
        php7.0-xml \
        php7.0-readline \
        phpldapadmin \
        && apt-get autoremove -yqq --purge \
        && apt-get clean \
        && rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base

WORKDIR /root
COPY ./dependent/config.php /etc/phpldapadmin/config.php
COPY ./dependent/ports.conf /etc/apache2/ports.conf
COPY ./dependent/apache2.conf /etc/apache2/apache2.conf
COPY ./entrypoint.sh . 
COPY ./init_ldapadmin.sh .
EXPOSE 80

ENTRYPOINT ["./entrypoint.sh"]
CMD ["phpldapadmin"]
