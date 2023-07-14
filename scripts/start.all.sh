#!/bin/bash

export DEBUG_MODE=true

{
  /scripts/start/docker.sh
} || {
  echo "Something went wrong"
  exit 1
}