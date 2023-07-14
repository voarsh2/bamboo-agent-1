#!/bin/bash

if [ "$DEBUG_MODE" == "true" ]; then
    set -x
fi

# DOC_USERNAME=<docker_hub_username>

# Add user to groups
usermod -aG docker $RUN_USER
usermod -aG root $RUN_USER
usermod -aG sudo $RUN_USER
# Add user to groups
usermod -aG docker,root,sudo bamboo

# Create paths for caching locations
mkdir -p /usr/local/bamboo/docker-images  /usr/local/bamboo/.m2 \
    && chown -R ${RUN_USER}:${RUN_GROUP} /usr/local/bamboo

# Create directories
mkdir -p /var/atlassian/application-data/bamboo-agent/.docker

# Copy .docker directory
cp -R /root/.docker /var/atlassian/application-data/bamboo-agent/.docker

# Set permissions
chmod a+wr /var/atlassian/application-data/bamboo-agent/.docker
chown -R $RUN_USER:$RUN_GROUP /var/atlassian/application-data/bamboo-agent/.docker

# daemon.json configuration
mkdir -p /etc/docker
touch /etc/docker/daemon.json
chown -R root:docker /etc/docker

### Bypass Docker pull rate limit by authenticating
# cat /etc/secrets/docker.pwd | docker login --username $DOC_USERNAME --password-stdin

cp -R /root/.docker $BAMBOO_AGENT_HOME/.docker
chmod a+wr $BAMBOO_AGENT_HOME/.docker
chown -R $RUN_USER:$RUN_GROUP $BAMBOO_AGENT_HOME/.docker