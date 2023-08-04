#!/bin/bash

if [ "$DEBUG_MODE" == "true" ]; then
	set -x
fi

usermod -aG docker bamboo

retry_count=0
retry_limit=10

while true; do
  if service docker start; then
    echo "Docker started successfully"
    break
  else
    echo "Failed to start Docker, retrying..."
    retry_count=$((retry_count+1))
    if [ $retry_count -eq $retry_limit ]; then
      echo "Exceeded retry limit, exiting..."
      exit 1
    fi
    sleep 3
  fi
done

chmod a+wrx /var/run/docker.sock
ls -l /var/run/docker.sock

chmod a+wrx /var/run/docker
ls -l /var/run/docker
