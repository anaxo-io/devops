#!/bin/bash
# env_derby.sh - version 1.1
#
# Bash script used to specify all the environment variables for the DB Apache Derby tools.
#
# Notes:
# - Usually you just need to modify the variables of first section of this file.
#
# Change logs:
#	1.0: by hicham, intial version
#   1.1: by hicham:
#        - use derby start, stop and monitor scripts
#        - removed the check and add sysinfo and runtime info

export DERBY_HOME=/apps/servers/stores/derby/10.8.2.2
export DERBY_WORK=/apps/services/stores/derby/derby-dev-01
export DERBY_DBNAME=DB
export DERBY_HOST=0.0.0.0
export DERBY_PORT=1082
export DERBY_JMX_PORT=1083
export DERBY_LOG_LEVEL=info

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

LOGS_DIR=${DERBY_WORK}/logs
# For Cygwin, switch paths to Windows format before running java
if $cygwin; then
    DERBY_HOME=`cygpath --absolute --windows "${DERBY_HOME}"`
    DERBY_WORK=`cygpath --absolute --windows "${DERBY_WORK}"`
    LOGS_DIR=`cygpath --absolute --windows "${LOGS_DIR}"`
fi
export DERBY_WORK LOGS_DIR

export DERBY_PARAMS="-h ${DERBY_HOST}"
export DERBY_PARAMS="${DERBY_PARAMS} -p ${DERBY_PORT}"

export DERBY_OPTS="-server"
export DERBY_OPTS="${DERBY_OPTS} -Dderby.system.home=${DERBY_WORK}"
export DERBY_OPTS="${DERBY_OPTS} -Dderby.stream.error.file='${LOGS_DIR}/derby.log'"
export DERBY_OPTS="${DERBY_OPTS} -verbose:gc"
export DERBY_OPTS="${DERBY_OPTS} -XX:+UseConcMarkSweepGC"
export DERBY_OPTS="${DERBY_OPTS} -XX:+HeapDumpOnOutOfMemoryError"
export DERBY_OPTS="${DERBY_OPTS} -Xloggc:'${LOGS_DIR}/gc.log'"

# JPDA variables used to remotely debug DERBY, DERBY must be launched using run:jpda option
export JPDA_ADDRESS=8787
export JPDA_TRANSPORT=dt_socket
export JPDA_SUSPEND=y