#!/bin/bash
set -e

agent_runner() {
    while :
    do
        if [ ! -f "/proc/$(cat /tmp/agent.pid)/status" ]
        then
            curl $JNLP_AGENT_DOWNLOAD_URL -o agent.jar
            java \
            -Dorg.jenkinsci.plugins.durabletask.BourneShellScript.HEARTBEAT_CHECK_INTERVAL=300 \
            -Dhttps.protocols=TLSv1.2 \
            -jar agent.jar \
            -jnlpUrl $JNLP_AGENT_URL \
            -secret $JENKINS_SECRET \
            -workDir "$JENKINS_WORKDIR" &
            echo $! > /tmp/agent.pid
        else
            :
        fi
        sleep 10
    done
}

while :
do
    if [ cat < /dev/tcp/"$TARGET" ]; then
      echo "Starting Agent"
      agent_runner
    else
      echo "Jenkins master is offline, waiting...."
    fi
    sleep 10
done
