#!/bin/bash

export DEBUG_MODE=false

sudo /scripts/start/docker.sh || {
  echo "Something went wrong"
  exit 1
}