#!/bin/bash

if [ "$DEBUG_MODE" == "true" ]; then
	set -x
fi

usermod -aG docker bamboo

while true; do
    service docker start
    sleep 3
    if service docker status | grep -q "running"; then
        break
    fi
done

chmod a+wrx /var/run/docker.sock
ls -l /var/run/docker.sock

chmod a+wrx /var/run/docker
ls -l /var/run/docker
