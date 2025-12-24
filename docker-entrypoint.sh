#!/bin/bash

if [ "$1" = 'run' ]; then
    find /files/input/ -name *".ico" -exec rm {} \;
    [ -f /files/input ] && PGPT_PROFILES=ingest make ingest /files/input
    PGPT_PROFILES=ollama make run
else
    exec "$@"
fi
