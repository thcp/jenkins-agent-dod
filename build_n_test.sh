#!/bin/bash

DOCKER_VERSION=$(docker version --format '{{.Server.Version}}')
DOCKER_IMAGE="jenkins-agent"

docker build --build-arg version=$DOCKER_VERSION -t $DOCKER_IMAGE  .