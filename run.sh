#!/bin/bash

set -e

source config.env


DOCKER_IMAGE="jenkins-agent-$AGENT_NAME"

echo "Build Image"
docker build -t $DOCKER_IMAGE .

echo "Launch agent"
docker run -d  \
	-e JNLP_AGENT_URL=$JNLP_AGENT_URL\
	-e JENKINS_SECRET=$JENKINS_SECRET \
	-e TARGET=$TARGET \
	-e JNLP_AGENT_DOWNLOAD_URL=$JNLP_AGENT_DOWNLOAD_URL \
	-e JENKINS_WORKDIR=$JENKINS_WORKDIR \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v $JENKINS_WORKDIR:$JENKINS_WORKDIR \
	--name="$DOCKER_IMAGE" \
	"$DOCKER_IMAGE"
