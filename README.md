# jenkins-slave-dod
Jenkins Slave with docker out of docker and auto restart

#### How to use:

##### Update `config.env`:

```
AGENT_NAME=<agent name>
JENKINS_URL=<jenkins master url>
TARGET=<server ip/port> 
JENKINS_SECRET=<token>
JNLP_AGENT_URL="$JENKINS_URL/computer/$AGENT_NAME/slave-agent.jnlp"
JNLP_AGENT_DOWNLOAD_URL="$JENKINS_URL/jnlpJars/agent.jar"
JENKINS_WORKDIR="/var/lib/jenkins/"
```
It's important to notice that `TARGET` it's a bad variable name , i'm opened for sugestions and it  will be used for  checking if Jenkins Master is up or not. 

##### Just run it:
Execute `run.sh` and that's it.

#### Why not using supervisor ?

Lack of python 3 support is the main reason.


#### What about the restarting process?

Agents goes offline after restarting Jenkins Master, and currently it's not doable to relaunch 20+ containers manually.

#### How it works

Really simple, checking if Jenkins master is available is the fist action done so we can launch the agent process right after ( if the process isn't running ) 

Content of `worker.sh`

```
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

```
