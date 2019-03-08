#!/bin/bash

if [ ! -f /var/log/apache2/is_first ]
then
    rm -rf /var/log/apache2
    mkdir /var/log/apache2
    touch /var/log/apache2/error.log
    touch /var/log/apache2/access.log
    touch /var/log/apache2/other_vhosts_access.log
    touch /var/log/apache2/is_first
    chgrp -v adm /var/log/apache2
fi

sed -i "286s#.*#\$servers->setValue('server','name','${SERVER_NAME}');#" /etc/phpldapadmin/config.php
sed -i "293s#.*#\$servers->setValue('server','host','${LDAP_HOST}');#" /etc/phpldapadmin/config.php
sed -i "300s#.*#\$servers->setValue('server','base',array('${BASE_DN}'));#" /etc/phpldapadmin/config.php
sed -i "326s#.*#\$servers->setValue('login','bind_id','cn=admin,${BASE_DN}');#" /etc/phpldapadmin/config.php
