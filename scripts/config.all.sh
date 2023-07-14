#!/bin/bash

export DEBUG_MODE=true
chmod +x /scripts/config/docker.sh
chmod +x /scripts/start/docker.sh
{
  /scripts/config/docker.sh
} || {
  echo "Something went wrong"
  exit 1
}
