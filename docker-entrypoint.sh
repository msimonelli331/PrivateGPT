#!/bin/bash

if [ "$1" = 'run' ]; then
    ln -s $(pwd)/configs/* $(pwd)/
    if [ ! -z $2 ]; then
        folder=$2
        if [ -d "/files/input/${folder}" ]; then
            # Remove .git folder
            find "/files/input/${folder}/" -name ".git" -exec rm -rf {} \;
            # Remove images
            find "/files/input/${folder}/" -name *".ico" -exec rm {} \;
            find "/files/input/${folder}/" -name *".svg" -exec rm {} \;
            make ingest "/files/input/${folder}"
        fi
    fi
    make run
else
    exec "$@"
fi
