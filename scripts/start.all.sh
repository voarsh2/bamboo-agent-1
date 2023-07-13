#!/bin/bash

export DEBUG_MODE=false

sudo -S /scripts/start/docker.sh <<< "" || {
  echo "Something went wrong"
  exit 1
}