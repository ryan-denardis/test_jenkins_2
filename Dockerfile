# Note that this is a linuxkit image, so there are some quirks
FROM jenkinsci/blueocean

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG http_port=8080
ARG agent_port=50000
ARG JENKINS_HOME=/var/jenkins_home

# from a derived Dockerfile, can use `RUN plugins.sh active.txt` to setup /usr/share/jenkins/ref/plugins from a support bundle
COPY ./support/plugins.txt /usr/share/jenkins/ref/plugins.txt
COPY ./scripts/install-plugins.sh /usr/local/bin/install-plugins.sh
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

# Add job configs
ARG job_name_1="asgardweb"

# Create the job workspaces
RUN mkdir -p "$JENKINS_HOME"/workspace/${job_name_1} && mkdir -p "$JENKINS_HOME"/jobs/${job_name_1}
COPY jobs/${job_name_1}.xml "$JENKINS_HOME"/jobs/${job_name_1}/config.xml

# Create build file structure
USER root
RUN mkdir -p "$JENKINS_HOME"/jobs/${job_name_1}/latest/ && mkdir -p "$JENKINS_HOME"/jobs/${job_name_1}/builds/1/

# Reset JENKINS_HOME to all be controlled by jenkins
RUN chown -R jenkins:jenkins $JENKINS_HOME

# Install Python 3 with apk
# https://github.com/frol/docker-alpine-python3/blob/master/Dockerfile
RUN apk add --no-cache python3 && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    rm -r /root/.cache