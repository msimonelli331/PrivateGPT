#!/bin/bash

if [ "$1" = 'run' ]; then
    if [ -d /files/input ]; then
        find /files/input/ -name *".ico" -exec rm {} \;
        make ingest /files/input
    fi
    make run
else
    exec "$@"
fi
