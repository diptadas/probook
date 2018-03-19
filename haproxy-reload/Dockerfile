FROM haproxy:1.8.4-alpine

# Installs runit and inotify-tool
RUN set -x \
  && apk add --update --no-cache runit bash inotify-tools \
  && rm -rf /etc/sv /etc/service

# Create haproxy.cfg dir
RUN mkdir /etc/haproxy
RUN touch /var/run/haproxy.pid

# COPY haproxy.cfg /etc/haproxy/haproxy.cfg

# Setup runit scripts
COPY sv /etc/sv/
RUN ln -s /etc/sv /etc/service

COPY runit.sh /runit.sh

ENTRYPOINT ["/runit.sh"]
