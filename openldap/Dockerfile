FROM osixia/openldap:1.2.2
MAINTAINER Tao Shibo <taoshibo@shannonai.com>

ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && sed -i 's/http:\/\/deb\.debian\.org\/debian/http:\/\/mirrors\.aliyun\.com\/debian/g' /etc/apt/sources.list \
    && sed -i 's/http:\/\/security\.debian\.org\/debian-security/http:\/\/mirrors\.aliyun\.com\/debian-security/g' /etc/apt/sources.list

RUN set -ex \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends \
        iputils-ping \
        net-tools \
        apt-utils \
        bash \
        locales \
        ca-certificates \
        rsyslog \
    && sed -i 's/^# en_US.UTF-8 UTF-8$/en_US.UTF-8 UTF-8/g' /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
    && apt-get autoremove -yqq --purge \
    && apt-get clean \
    && rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base

# Define en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LC_MESSAGES en_US.UTF-8
ENV ENV /etc/profile

COPY bashrc /etc/bash.bashrc

COPY ldif /container/service/slapd/assets/config/bootstrap/ldif/custom
COPY process.sh /container/service/slapd/process.sh

RUN chmod +x /container/service/slapd/process.sh

VOLUME /var/log/ldap
