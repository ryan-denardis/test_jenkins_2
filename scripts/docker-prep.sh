#!/bin/bash

# Environment variables
DOCKER_SOCKET=/var/run/docker.sock
DOCKER_GROUP=dockerhost
JENKINS_USER=jenkins
JENKINS_HOME=/var/jenkins_home

# Prepare Docker users and groups
if [ -S ${DOCKER_SOCKET} ]; then
DOCKER_GID=$(stat -c '%g' ${DOCKER_SOCKET})
groupadd -for -g ${DOCKER_GID} ${DOCKER_GROUP}
usermod -aG ${DOCKER_GROUP} ${JENKINS_USER}
fi

# Install python packages
chmod -R 777 /rhiza/
pip3 install -r /rhiza/ops/requirements.txt || echo "First pip3 install failed"
pip3 install -r /rhiza/asgard/build/images/asgard-build/setup/requirements.txt || echo "Second pip3 install failed"

# Prepare Jenkins to run
chown -R ${JENKINS_USER}:${JENKINS_USER} ${JENKINS_HOME}

exec sudo -E -H -u ${JENKINS_USER} bash -c /usr/local/bin/jenkins.sh --verbose