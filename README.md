# jenkins-slave-dod
Jenkins Slave with docker out of docker and auto restart

#### How to use:

##### Update `config.env`:

```
AGENT_NAME="slave-01"
JENKINS_URL="http://172.17.0.2:8080"
JENKINS_SECRET="ac486a372b35abd87b2c1f3115905f9277efa57dd23a26505fdd15d2477b77df"
JNLP_AGENT_URL="$JENKINS_URL/computer/$AGENT_NAME/slave-agent.jnlp"
JNLP_AGENT_DOWNLOAD_URL="$JENKINS_URL/jnlpJars/agent.jar"
JENKINS_WORKDIR="/var/lib/jenkins/"
```

##### Just run it:
Execute `run.sh` and that's it.
