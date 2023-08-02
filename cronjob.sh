#!/bin/bash
echo "Running cronjob"
docker builder prune --filter until=300h -f