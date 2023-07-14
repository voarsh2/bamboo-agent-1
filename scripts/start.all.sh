#!/bin/bash

export DEBUG_MODE=true

{
 sudo -s /scripts/start/docker.sh
} || {
  echo "Something went wrong"
  exit 1
}