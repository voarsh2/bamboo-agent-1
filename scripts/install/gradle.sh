#!/bin/bash

# Download and unzip Gradle distribution
wget https://services.gradle.org/distributions/gradle-7.4-all.zip -P /tmp && \nzip /tmp/gradle-7.4-all.zip -d /opt/gradle && \
    rm /tmp/gradle-7.4-all.zip

# Set environment variables
echo "export GRADLE_HOME=/opt/gradle/gradle-7.4" >> /etc/environment
echo "export PATH=\$PATH:\$GRADLE_HOME/bin" >> /etc/environment