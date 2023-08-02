#!/bin/bash
echo "Running cronjob"
docker builder prune --filter until=300h -f
# Exit with status 0 to indicate successful completion
exit 0