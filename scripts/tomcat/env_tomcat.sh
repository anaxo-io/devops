#!/bin/bash
# env_tomcat.sh - version 1.2
#
# Bash script used to specify all the environment variables.
#
# Notes:
# - Usually you just need to modify the variables of first section of this file.
#
# Change logs:
#	1.0: by hicham, intial version
#	1.1: by hicham, added OS specific support in order to be able 
#		  to use it under cygwin 
#	1.2: by hicham, added the derby port to pass as java options.

export CATALINA_HOME=/apps/servers/containers/tomcat/current
export CATALINA_BASE=/apps/services/containers/tomcat/tomcat-dev-01

export TOMCAT_SERVER_PORT=8880
export TOMCAT_SHUTDOWN_PORT=8005
export TOMCAT_JMX_PORT=1200
export DERBY_PORT=1082

#not in use
#export TOMCAT_REDIRECT_PORT=8443
#export TOMCAT_APJ_PORT=8009

###########################
# non editable parameters #
###########################

# OS specific support.  $var _must_ be set to either true or false.
cygwin=false
darwin=false
os400=false
case "$(uname)" in
CYGWIN*) cygwin=true;;
Darwin*) darwin=true;;
OS400*) os400=true;;
esac

export LOG4J_LOC=${CATALINA_BASE}
#export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}
export TOMCAT_RUNTIME=${CATALINA_BASE}/runtime
export CATALINA_PID=${TOMCAT_RUNTIME}/tomcat.pid

LOGS_DIR=${CATALINA_BASE}/logs
# For Cygwin, switch paths to Windows format before running java
if $cygwin; then
  LOGS_DIR=$(cygpath --absolute --windows "${LOGS_DIR}")
fi
export LOGS_DIR

export CATALINA_OUT=${LOGS_DIR}/catalina.$(date +\%Y-\%m-\%d).out

export GC_OPTS="-server"
export GC_OPTS="${GC_OPTS} -XX:+UsePerfData"
export GC_OPTS="${GC_OPTS} -Xms256m"
export GC_OPTS="${GC_OPTS} -Xmx512m"
export GC_OPTS="${GC_OPTS} -XX:+UseParNewGC"
export GC_OPTS="${GC_OPTS} -XX:ParallelGCThreads=2"
export GC_OPTS="${GC_OPTS} -XX:+DisableExplicitGC"
export GC_OPTS="${GC_OPTS} -XX:TargetSurvivorRatio=95"
export GC_OPTS="${GC_OPTS} -XX:NewSize=192m"
export GC_OPTS="${GC_OPTS} -XX:MaxNewSize=192m"
export GC_OPTS="${GC_OPTS} -XX:SurvivorRatio=6"
export GC_OPTS="${GC_OPTS} -XX:PermSize=64m"
export GC_OPTS="${GC_OPTS} -XX:MaxPermSize=128m"
export GC_OPTS="${GC_OPTS} -Dsun.rmi.dgc.client.gcInterval=86480000"
export GC_OPTS="${GC_OPTS} -Dsun.rmi.dgc.server.gcInterval=86480000"

export CATALINA_OPTS="${GC_OPTS}"
export CATALINA_OPTS="${CATALINA_OPTS} -Dlogs.dir='${LOGS_DIR}'"

export JAVA_OPTS="${JAVA_OPTS} -Dtomcat.server.port=${TOMCAT_SERVER_PORT}"
export JAVA_OPTS="${JAVA_OPTS} -Dtomcat.shutdown.port=${TOMCAT_SHUTDOWN_PORT}"
export JAVA_OPTS="${JAVA_OPTS} -Dderby.port=${DERBY_PORT}"
#export JAVA_OPTS="${JAVA_OPTS} -Dtomcat.redirect.port=${TOMCAT_REDIRECT_PORT}"
#export JAVA_OPTS="${JAVA_OPTS} -Dtomcat.apj.port=${TOMCAT_APJ_PORT}"
#export JAVA_OPTS="${JAVA_OPTS} -Djava.library.path=${LD_LIBRARY_PATH}"

# JPDA variables used to remotely debug tomcat, tomcat must be launched using start_jpda option
export JPDA_ADDRESS=8787
export JPDA_TRANSPORT=dt_socket
export JPDA_SUSPEND=y