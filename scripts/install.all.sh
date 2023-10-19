#!/bin/bash

export DEBUG_MODE=false

{
  chmod +x /scripts/install/prerequsites.sh
  chmod +x /scripts/install/docker.sh
  chmod +x /scripts/install/gradle.sh
  /scripts/install/prerequsites.sh
  /scripts/install/docker.sh
  /scripts/install/gradle.sh
  apt-get clean autoclean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*
} || {
  echo "Something went wrong - install.all (install.all)"
  exit 1
}