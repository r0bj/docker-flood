FROM alpine:3.7

ARG FLOOD_VER=1.0.0
ARG CONFD_VER=0.16.0

RUN wget -qO /usr/bin/confd https://github.com/kelseyhightower/confd/releases/download/v${CONFD_VER}/confd-${CONFD_VER}-linux-amd64 && chmod +x /usr/bin/confd
COPY config.js.toml /etc/confd/conf.d/
COPY config.js.tmpl /etc/confd/templates/

RUN apk add --no-cache nodejs

RUN mkdir /flood && cd /flood && wget -qO- https://github.com/jfurrow/flood/archive/v${FLOOD_VER}.tar.gz | tar xz --strip 1 \
  && cp config.template.js config.js \
  && sed -i "s/floodServerHost: '127.0.0.1'/floodServerHost: '0.0.0.0'/" /flood/config.js \
  && npm install --production \
  && chown -R nobody:nogroup /flood

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

USER nobody
WORKDIR /flood

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/flood/server/bin/www"]
