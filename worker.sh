#!/bin/bash
set -e

curl $JNLP_AGENT_DOWNLOAD_URL -o agent.jar
java \
    -Dorg.jenkinsci.plugins.durabletask.BourneShellScript.HEARTBEAT_CHECK_INTERVAL=300 \
    -Dhttps.protocols=TLSv1.2 \
    -jar agent.jar \
    -jnlpUrl $JNLP_AGENT_URL \
    -secret $JENKINS_SECRET
