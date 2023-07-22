#!/bin/bash

# Start all needed service
/scripts/start.all.sh

# Kubectl
export PATH=$PATH:/usr/bin/kubectl

### Start the bamboo agent
# Deescalate permissions to ${RUN_USER}
python3 /entrypoint.py
