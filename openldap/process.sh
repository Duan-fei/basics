#!/bin/bash -e

# set -x (bash debug) if log level is trace
# https://github.com/osixia/docker-light-baseimage/blob/stable/image/tool/log-helper
log-helper level eq trace && set -x

# Reduce maximum number of number of open file descriptors to 1024
# otherwise slapd consumes two orders of magnitude more of RAM
# see https://github.com/docker/docker/issues/8231
ulimit -n $LDAP_NOFILE

if [ ! -e /var/log/ldap/slapd.log ]; then
    mkdir -p /var/log/ldap
    touch /var/log/ldap/slapd.log
    chown -R openldap:openldap /var/log/ldap
    chmod 664 -R /var/log/ldap
    echo 'local4.* /var/log/ldap/slapd.log' >> /etc/rsyslog.conf
fi

/usr/sbin/rsyslogd
exec /usr/sbin/slapd -h "ldap://$HOSTNAME ldaps://$HOSTNAME ldapi:///" -u openldap -g openldap -d $LDAP_LOG_LEVEL
