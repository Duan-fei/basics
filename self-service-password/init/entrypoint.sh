#!/bin/bash

case "$1" in
  self-service-password)
    /init/init_password.sh
    exec /usr/sbin/apache2ctl -D FOREGROUND
  ;;
  *)
    exec "$@"
  ;;
esac
