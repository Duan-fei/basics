#!/bin/bash

case "$1" in
    dnsmasq)
        nohup ./host_watch_dog.sh  &
        mkdir -p /var/log/dnsmasq
        chown root:root /var/log/dnsmasq
        if [ ! -f /etc/dnsmasq/dnsmasq.conf ]
        then
            cp /root/dnsmasq_need/dnsmasq.conf   /etc/dnsmasq/
            echo "/etc/dnsmasq/dnsmasq.conf initialized"
        fi
        if [ ! -f /etc/dnsmasq/dnsmasq.resolv ]
        then
            cp /root/dnsmasq_need/dnsmasq.resolv /etc/dnsmasq/
            echo "/etc/dnsmasq/dnsmasq.resolv initialized"
        fi
        if [ ! -f /etc/dnsmasq/dnsmasq.hosts ]
        then
            cp /root/dnsmasq_need/dnsmasq.hosts  /etc/dnsmasq/
            echo "/etc/dnsmasq/dnsmasq.hosts initialized"
        fi
        if [ ! -f /etc/logrotate.d/logrotate_dnsmasq ]
        then
            cp /root/dnsmasq_need/logrotate_dnsmasq /etc/logrotate.d/
            echo "/etc/logrotate.d/logrotate_dnsmasq initialized"
        fi

        /etc/init.d/cron start # start cron service
        exec dnsmasq -k ${@:2}
        ;;
    *)
        exec $@
        ;;
esac

