#!/bin/bash

CONFIG_PATH=/usr/share/self-service-password/conf/config.inc.php
DOWN_URL="http://ltb-project.org/archives/self-service-password_1.3-1_all.deb"

if [ ! -d /etc/self-service-password/ ];
then
    mkdir -p /etc/self-service-password
    cp /init/self-service-password.conf /etc/self-service-password/
    cp /init/apache2.conf /etc/apache2/apache2.conf
    cp /init/ports.conf /etc/apache2/ports.conf
    ln -s /etc/self-service-password/self-service-password.conf /etc/apache2/conf-available/self-service-password.conf
    ln -s /etc/apache2/conf-available/self-service-password.conf /etc/apache2/conf-enabled/self-service-password.conf
fi

if [ ! -d /usr/share/self-service-password/ ];
then
    wget -O /self-service-password $DOWN_URL
    dpkg --install /self-service-password 
    cp /init/config.inc.php /usr/share/self-service-password/conf/config.inc.php
    cp -r /init/images/ /usr/share/self-service-password/
    echo TLS_REQCERT never >> /etc/ldap/ldap.conf
fi

sed -r -i "34s#($debug = ).*#\1$DEBUG;#g" $CONFIG_PATH
sed -r -i "37s#($ldap_url = ).*#\1$LDAP_SERVICE;#g" $CONFIG_PATH
sed -r -i "39s#($ldap_binddn = ).*#\1$LDAP_BINDDN;#g" $CONFIG_PATH
sed -r -i "40s#($ldap_bindpw = ).*#\1$LDAP_BINDPW;#g" $CONFIG_PATH
sed -r -i "41s#($ldap_base = ).*#\1$LDAP_BASEDN;#g" $CONFIG_PATH
sed -r -i "42s#($ldap_login_attribute = ).*#\1$LDAP_LOGIN_ATTR;#g" $CONFIG_PATH
sed -r -i "44s#($ldap_filter = ).*#\1$LDAP_FILTER;#g" $CONFIG_PATH

