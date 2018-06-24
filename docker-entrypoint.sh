#!/bin/bash -e

if [ -z "$FLOOD_USER" ]; then
    FLOOD_USER="flood"
fi

if [ -n "$FLOOD_UID" ]; then
    OPTS="$OPTS -u $FLOOD_UID"
fi

if [ -n "$FLOOD_GID" ]; then
    OPTS="$OPTS -G $FLOOD_USER"
    addgroup -g $FLOOD_GID $FLOOD_USER
fi

adduser -D -H -h /nonexistent -g $FLOOD_USER -s /sbin/nologin $OPTS $FLOOD_USER

chown -R ${FLOOD_UID}:$FLOOD_GID /flood/server/db

confd -onetime -backend env

exec su-exec $FLOOD_USER "$@"
