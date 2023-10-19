#!/bin/bash

# Start all needed service
/scripts/start.all.sh &

# Kubectl
export PATH=$PATH:/usr/bin/kubectl

#Krew
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
sudo -s kubectl krew install neat


# Gradle
export GRADLE_HOME=/opt/gradle/gradle-7.4
export PATH=$PATH:$GRADLE_HOME/bin
# Android SDK:
export ANDROID_HOME=/opt/android-sdk
# export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
# yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses
# $ANDROID_HOME/tools/bin/sdkmanager "platforms;android-31" "build-tools;30.0.2"


### Start the bamboo agent
# Deescalate permissions to ${RUN_USER}
python3 /entrypoint.py
