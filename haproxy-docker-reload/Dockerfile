FROM haproxy:1.8.4-alpine

RUN set -x && apk add --update --no-cache procps bash inotify-tools 

RUN mkdir /etc/haproxy
RUN touch /var/run/haproxy.pid

COPY run.sh /run.sh

ENTRYPOINT ["/run.sh"]
