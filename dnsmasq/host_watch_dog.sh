#!/bin/bash    
old_change_time=0 
while true
do
    new_change_time=$(stat --format="%Z" /etc/dnsmasq/dnsmasq.hosts)
    if [[ $old_change_time == $new_change_time ]]; then 
        sleep 5
    else
        dnsmasq_pid=$(ps -ef |grep dnsmas[q]|awk '{print $2}')
        kill -s SIGHUP $dnsmasq_pid
        old_change_time=$new_change_time
    fi
done    
