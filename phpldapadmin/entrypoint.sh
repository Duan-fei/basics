#!/bin/bash

case "$1" in
  phpldapadmin)
    ./init_ldapadmin.sh
    chown www-data /etc/phpldapadmin/config.php
    exec /usr/sbin/apache2ctl -D FOREGROUND
  ;;
  *)
    exec "$@"
  ;;
esac
