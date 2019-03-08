#!/usr/bin/env bash

case "$1" in
  ldap-api)
    exec ./ldap-api
    ;;
  *)
    # The command is something like bash, not an airflow subcommand. Just run it in the right environment.
    exec "$@"
    ;;
esac
