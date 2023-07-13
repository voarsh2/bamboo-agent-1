#!/bin/bash

export DEBUG_MODE=false
chmod +x /scripts/start/docker.sh  # Add this line to grant execute permissions
{
  /scripts/start/docker.sh
} || {
  echo "Something went wrong"
  exit 1
}
