#!/bin/bash

export DEBUG_MODE=true

{
 sudo -s /scripts/start/docker.sh
} || {
  echo "Something went wrong - docker start (start.all)"
  exit 1
}

# Start Supervisor with retry
retry_count=0
retry_limit=10
while true; do
  if sudo -s supervisord -c /etc/supervisor/conf.d/supervisord.conf; then
    echo "Supervisor started successfully"
    break
  else
    echo "Something went wrong - Supervisor start (start.all)"
    retry_count=$((retry_count+1))
    if [ $retry_count -eq $retry_limit ]; then
      echo "Exceeded retry limit, exiting..."
      exit 1
    fi
    echo "Retrying in 1 second..."
    sleep 1
  fi
done

# Check if Supervisor is running
if sudo -s supervisorctl status; then
  echo "Supervisor is running"
else
  echo "Supervisor is not running"
  exit 1
fi