FROM registry.cn-beijing.aliyuncs.com/shannonai/debian

COPY ./init/sources.list /etc/apt/sources.list

# runtime dependencies
RUN apt-get update -yqq\
        && apt-get install -yqq \
        php \
        php7.0-xml \
        php7.0-readline \
        php7.0-ldap \
        php7.0-mbstring \
        php7.0-common \
        apache2 \
        wget \
        && apt-get autoremove -yqq --purge \
        && apt-get clean \
        && rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base

COPY init /init

ENTRYPOINT ["/init/entrypoint.sh"]
CMD ["self-service-password"]
