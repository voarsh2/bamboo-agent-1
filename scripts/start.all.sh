#!/bin/bash

export DEBUG_MODE=true

{
 sudo -s /scripts/start/docker.sh
} || {
  echo "Something went wrong - docker start (start.all)"
  exit 1
}

# Start Supervisor
{
 sudo -s supervisord -c /etc/supervisor/conf.d/supervisord.conf
} || {
  echo "Something went wrong - supervisor start (start.all)"
  exit 1
}