FROM alpine:3.7

ARG FLOOD_VER=1.0.0
ARG CONFD_VER=0.16.0

RUN wget -qO /usr/bin/confd https://github.com/kelseyhightower/confd/releases/download/v${CONFD_VER}/confd-${CONFD_VER}-linux-amd64 && chmod +x /usr/bin/confd \
  && apk add --no-cache bash nodejs su-exec mediainfo \
  && mkdir /flood && cd /flood && wget -qO- https://github.com/jfurrow/flood/archive/v${FLOOD_VER}.tar.gz | tar xz --strip 1 && npm install --production

COPY etc /etc

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

WORKDIR /flood

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/flood/server/bin/www"]
