# Atlassian bamboo agent base image is based on eclipse-temurin:11 image
FROM sonarsource/sonar-scanner-cli:4.7 as sonars
# FROM maven:3.8.6-eclipse-temurin-11 as maven
FROM atlassian/bamboo-agent-base:9.2 as ship

##### Install and configure as ROOT
USER root

# Copy secrets
COPY secrets /etc/secrets
RUN chmod a+wr /etc/secrets

# Overwrite entrypoint command to start services before bamboo agent
COPY entrypoint.sh /entrypoint.sh
RUN chmod a+wrx /entrypoint.sh # Required due to permission loss on Windows

#Supervisor cron for pruning docker builder
RUN apt-get update && apt-get install -y supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

#Gradle 
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
# entrypoint
CMD ["/entrypoint.sh"]

#### Install maven
# ENV MAVEN_HOME=/usr/share/maven
# COPY --from=maven /usr/share/maven ${MAVEN_HOME}
# RUN ln -s ${MAVEN_HOME} /opt/maven

#### Install Sonar Scanner
ENV SONAR_SCANNER_HOME /opt/sonar-scanner
COPY --from=sonars /opt/sonar-scanner ${SONAR_SCANNER_HOME}

#### Update capabilities as RUN_USER
# Atlassian bamboo base image comes with capabilities:
#  - "system.jdk.JDK 1.11" ${JAVA_HOME}/bin/java
#  - "Python" /usr/bin/python3
#  - "Python 3" /usr/bin/python3
#  - "Git"  /usr/bin/git # NOTE: not set on correct capability in the base image and cause connection issues, thus setting it here

### Copy scripts
COPY scripts /scripts
RUN chmod a+wrx -R /scripts/*.sh \
    && /scripts/install.all.sh \
    && /scripts/config.all.sh \
    && echo "bamboo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Install kubectl
RUN apt-get update && \
    apt-get install -y apt-transport-https gnupg2 curl && \
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
    apt-get update && \
    apt-get install -y kubectl
# Install krew
RUN set -x \
    && cd "$(mktemp -d)" \
    && curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/download/v0.4.4/krew-linux_amd64.tar.gz" \
    && tar zxvf krew-linux_amd64.tar.gz \
    && KREW=./krew-"$(uname | tr '[:upper:]' '[:lower:]')_amd64" \
    && "$KREW" install krew \
    && export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH" \
    && "$KREW" update

    
# Copy cluster credentials YAML file
COPY cluster-credentials.yaml /home/bamboo/.kube/config
RUN chown bamboo:bamboo /home/bamboo/.kube/config && \
    chmod 600 /home/bamboo/.kube/config

# Install ZIP/UNZIP/TAR
RUN apt-get update && \
    apt-get install -y  zip unzip tar

# Shutdown pre-hook
COPY shutdown-wait.sh /
RUN chmod +x /shutdown-wait.sh

#Copy cronjob.sh
COPY cronjob.sh /
RUN chmod +x /cronjob.sh

# Install Gradle
RUN wget https://services.gradle.org/distributions/gradle-4.0.2-bin.zip \
    && unzip gradle-4.0.2-bin.zip -d /opt/gradle \
    && rm gradle-4.0.2-bin.zip
# Android SDK
# Install Android SDK
RUN wget https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip && \
    unzip sdk-tools-linux-4333796.zip -d /opt/android-sdk && \
    rm sdk-tools-linux-4333796.zip

USER ${RUN_USER}
RUN /bamboo-update-capability.sh "Docker" /usr/bin/docker \
    && /bamboo-update-capability.sh "system.builder.sos" ${SONAR_SCANNER_HOME}
# RUN /bamboo-update-capability.sh "system.builder.mvn3.Maven 3" ${MAVEN_HOME} \
    # && /bamboo-update-capability.sh "system.git.executable" /usr/bin/git \
    # && /bamboo-update-capability.sh "Docker" /usr/bin/docker \
