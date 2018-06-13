#!/bin/bash -e

confd -onetime -backend env

USER="flood"
FLOOD_UID=${FLOOD_UID:-1000}
FLOOD_GID=${FLOOD_GID:-1000}

if [ -n "$FLOOD_UID" ]; then
    OPTS="-u $FLOOD_UID"
fi

if [ -n "$FLOOD_GID" ]; then
    OPTS="$OPTS -G $USER"
    addgroup -g $FLOOD_GID $USER
fi

adduser -D -H -h /nonexistent -g $USER -s /sbin/nologin $OPTS $USER

chown -R ${FLOOD_UID}:$FLOOD_GID /flood/server/db

exec su-exec $USER "$@"
