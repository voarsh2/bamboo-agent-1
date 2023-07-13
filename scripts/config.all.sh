#!/bin/bash

export DEBUG_MODE=false
RUN chmod +x /scripts/config/docker.sh

{
  /scripts/config/docker.sh
} || {
  echo "Something went wrong"
  exit 1
}
