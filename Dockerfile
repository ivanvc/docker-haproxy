FROM haproxy:1.5
MAINTAINER Ivan Valdes <ivan@vald.es>

RUN apt-get update && apt-get install -y --no-install-recommends libpcre3-dev rsyslog curl && \
    curl -kL https://github.com/kelseyhightower/confd/releases/download/v0.8.0/confd-0.8.0-linux-amd64 > /usr/local/bin/confd && \
    chmod +x /usr/local/bin/confd &&\
    mkdir -p /etc/confd/conf.d && \
    mkdir -p /etc/confd/templates 

RUN mkdir /haproxy

ADD files/boot.sh /haproxy/boot.sh
ADD files/haproxy.toml /etc/confd/conf.d/haproxy.toml
ADD files/rsyslog.conf /etc/rsyslog.conf
ADD files/rsyslog-haproxy.conf /etc/rsyslog.d/haproxy.conf
ADD files/haproxy.cfg.tmpl /etc/confd/templates/haproxy.cfg.tmpl

RUN service rsyslog restart

CMD "/haproxy/boot.sh"
