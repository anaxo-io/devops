#!/bin/bash
# env_qpid.sh - version 1.2
#
# Bash script used to specify all the environment variables.
#
# Notes:
# - Usually you just need to modify the variables of first section of this file.
#
# Change logs:
#	1.0: by hicham, intial version
#	1.1: by hicham, added OS specific support in order to 
#		 be able to use it under cygwin.
#	1.2: by hicham, specify a runtime pid file with 
#		 ${QPID_PID_FILENAME} created under ${QPID_WORK}/runtime.

export QPID_HOME=/apps/servers/qpid/broker/qpid-2.7.1.1
export QPID_WORK=/apps/services/qpid/qpid-dev-01
export QPID_NAME=qpid-dev-01
export QPID_PORT=8888
export QPID_JMX_PORT=8889
export QPID_LOG_LEVEL=info

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

export JAVA_VM="-server"

export QPID_PNAME="-DPNAME=${QPID_NAME}"
export QPID_PID_FILENAME=qpid-server.pid

QPID_STOP_SEARCH="PNAME=${QPID_NAME}"
QPID_CFGFILE=${QPID_WORK}/conf/config.xml
QPID_LOG_CFGFILE=${QPID_WORK}/conf/log4j.xml
LOGS_DIR=${QPID_WORK}/logs
# For Cygwin, switch paths to Windows format before running java
if $cygwin; then
  QPID_STOP_SEARCH=qpid-server
  QPID_CFGFILE=`cygpath --absolute --windows "${QPID_CFGFILE}"`
  QPID_LOG_CFGFILE=`cygpath --absolute --windows "${QPID_LOG_CFGFILE}"`
  LOGS_DIR=`cygpath --absolute --windows "${LOGS_DIR}"`
fi
export QPID_STOP_SEARCH QPID_CFGFILE QPID_LOG_CFGFILE LOGS_DIR

export QPID_OPTS="-Damqj.logging.level=${QPID_LOG_LEVEL}"
export QPID_OPTS="${QPID_OPTS} -Dlogs.dir=${LOGS_DIR}"
export QPID_OPTS="${QPID_OPTS} -Damqj.read_write_pool_size=32"
export QPID_OPTS="${QPID_OPTS} -DQPID_LOG_APPEND="

export QPID_JAVA_MEM="-Xms512m"
export QPID_JAVA_MEM="${QPID_JAVA_MEM} -Xmx512m"

export QPID_JAVA_GC="-verbose:gc"
export QPID_JAVA_GC="${QPID_JAVA_GC} -XX:+UseConcMarkSweepGC"
export QPID_JAVA_GC="${QPID_JAVA_GC} -XX:+HeapDumpOnOutOfMemoryError"
export QPID_JAVA_GC="${QPID_JAVA_GC} -Xloggc:${LOGS_DIR}/gc.log"

# JPDA variables used to remotely debug QPID, QPID must be launched using run:jpda option
export JPDA_ADDRESS=8787
export JPDA_TRANSPORT=dt_socket
export JPDA_SUSPEND=y
