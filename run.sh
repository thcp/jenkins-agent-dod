#!/bin/bash

case $1 in
	build)
		docker build -t jenkins-slave .
		;;
	run)
	source config.env
	docker run -d  \
		-e JNLP_AGENT_URL=$JNLP_AGENT_URL\
		-e JENKINS_SECRET=$JENKINS_SECRET \
		-e TARGET=$TARGET \
		-e JNLP_AGENT_DOWNLOAD_URL=$JNLP_AGENT_DOWNLOAD_URL \
		-e JENKINS_WORKDIR=$JENKINS_WORKDIR \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v $JENKINS_WORKDIR:$JENKINS_WORKDIR \
		--name=jenkins-slave \
		jenkins-slave
		;;
esac
