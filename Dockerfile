FROM jesec/flood:4.3.1

USER root

RUN deluser download \
  && adduser -h /home/download -s /sbin/nologin -D -u 3000 download download

USER download
