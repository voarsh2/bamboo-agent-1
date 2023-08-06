#!/bin/bash

# Start all needed service
/scripts/start.all.sh &

# Kubectl
export PATH=$PATH:/usr/bin/kubectl

#Krew
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

kubectl krew install neat



### Start the bamboo agent
# Deescalate permissions to ${RUN_USER}
python3 /entrypoint.py
