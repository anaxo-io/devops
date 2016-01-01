#!/bin/bash
# env_cache.sh - version 1.0
#
# Bash script used to specify all the environment variables for a coherence cache.
#
# Notes:
# - Usually you just need to modify the variables of first section of this file.
#
# Change logs:
#	1.0: by hicham, intial version

export COHERENCE_HOME=/apps/servers/coherence/3.7.1
export COHERENCE_WORK=/apps/services/coherence/cache-dev-01
export COHERENCE_NAME=cache-dev-01
export COHERENCE_PORT=6000
export COHERENCE_JMX_PORT=6001
export COHERENCE_STORAGE_ENABLED=false
export COHERENCE_LOG_LEVEL=info

###########################
# non editable parameters #
###########################

# OS specific support.  $var _must_ be set to either true or false.
cygwin=false
darwin=false
os400=false
case "`uname`" in
CYGWIN*) cygwin=true;;
Darwin*) darwin=true;;
OS400*) os400=true;;
esac

export JAVA_VM="-server -showversion"

export COHERENCE_PID_FILENAME=${COHERENCE_NAME}.pid

COHERENCE_CFGFILE=${COHERENCE_WORK}/conf/config.xml
COHERENCE_LOG_CFGFILE=${COHERENCE_WORK}/conf/log4j.xml
COHERENCE_LOGS_DIR=${COHERENCE_WORK}/logs
COHERENCE_CP=${COHERENCE_HOME}/lib/coherence.jar

# For Cygwin, switch paths to Windows format before running java
if $cygwin; then
  COHERENCE_CFGFILE=`cygpath --absolute --windows "${COHERENCE_CFGFILE}"`
  COHERENCE_LOG_CFGFILE=`cygpath --absolute --windows "${COHERENCE_LOG_CFGFILE}"`
  COHERENCE_LOGS_DIR=`cygpath --absolute --windows "${COHERENCE_LOGS_DIR}"`
  COHERENCE_CP=`cygpath --absolute --windows "${COHERENCE_CP}"`
fi
export COHERENCE_CFGFILE COHERENCE_LOG_CFGFILE COHERENCE_LOGS_DIR

export COHERENCE_OPTS="${COHERENCE_OPTS} -Dprocess.name=${COHERENCE_NAME}"
export COHERENCE_OPTS="${COHERENCE_OPTS} -Dtangosol.coherence.cluster=${COHERENCE_NAME}" 
export COHERENCE_OPTS="${COHERENCE_OPTS} -Dtangosol.coherence.cluster=${COHERENCE_NAME}" 
export COHERENCE_OPTS="${COHERENCE_OPTS} -Dtangosol.coherence.clusterport=${COHERENCE_PORT}"
export COHERENCE_OPTS="${COHERENCE_OPTS} -Dtangosol.coherence.distributed.localstorage=${COHERENCE_STORAGE_ENABLED}"
export COHERENCE_OPTS="${COHERENCE_OPTS} -Dlogs.dir=${COHERENCE_LOGS_DIR}"

export COHERENCE_JAVA_MEM="-Xms512m"
export COHERENCE_JAVA_MEM="${COHERENCE_JAVA_MEM} -Xmx512m"

export COHERENCE_JAVA_GC="-verbose:gc"
export COHERENCE_JAVA_GC="${COHERENCE_JAVA_GC} -XX:+UseConcMarkSweepGC"
export COHERENCE_JAVA_GC="${COHERENCE_JAVA_GC} -XX:+HeapDumpOnOutOfMemoryError"
export COHERENCE_JAVA_GC="${COHERENCE_JAVA_GC} -Xloggc:${COHERENCE_LOGS_DIR}/gc.log"

# JPDA variables used to remotely debug COHERENCE, COHERENCE must be launched using run:jpda option
export JPDA_ADDRESS=8787
export JPDA_TRANSPORT=dt_socket
export JPDA_SUSPEND=y
