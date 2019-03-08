FROM registry.cn-beijing.aliyuncs.com/shannonai/debian

# runtime dependencies
RUN apt-get update \
    && apt-get install -yqq --no-install-recommends \
        dnsmasq \
        logrotate \
        cron \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/log/dnsmasq

COPY entrypoint.sh /root/
COPY host_watch_dog.sh /root/
COPY dnsmasq_need /root/dnsmasq_need

RUN chmod u+x /root/entrypoint.sh
RUN chmod u+x /root/host_watch_dog.sh 
VOLUME /etc/dnsmasq

EXPOSE 53
WORKDIR /root/
ENTRYPOINT ["/root/entrypoint.sh"]
CMD ["dnsmasq", "-C", "/etc/dnsmasq/dnsmasq.conf"]
