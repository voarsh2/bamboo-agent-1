#!/bin/bash

# Download and unzip Gradle distribution
wget https://services.gradle.org/distributions/gradle-5.0-bin.zip -P /tmp && \nzip /tmp/gradle-5.0-bin.zip -d /opt/gradle && \
    rm /tmp/gradle-5.0-bin.zip

# Set environment variables
echo "export GRADLE_HOME=/opt/gradle/gradle-5.0" >> /etc/environment
echo "export PATH=\$PATH:\$GRADLE_HOME/bin" >> /etc/environment