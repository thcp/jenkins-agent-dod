#!/bin/bash

set -e

source config.env

DOCKER_IMAGE="jenkins-agent-$AGENT_NAME"
DOCKER_VERSION=$(docker version --format '{{.Server.Version}}')
## remove running container and ignore error message if none.
docker rm -f $DOCKER_IMAGE || true

echo "Build Image"
docker build --build-arg version=$DOCKER_VERSION -t $DOCKER_IMAGE  .

echo "Launch agent"
docker run -d --restart on-failure  \
	-e JNLP_AGENT_URL=$JNLP_AGENT_URL\
	-e JENKINS_SECRET=$JENKINS_SECRET \
	-e TARGET=$TARGET \
	-e JNLP_AGENT_DOWNLOAD_URL=$JNLP_AGENT_DOWNLOAD_URL \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v $JENKINS_WORKDIR:$JENKINS_WORKDIR \
	--name="$DOCKER_IMAGE" \
	"$DOCKER_IMAGE"
