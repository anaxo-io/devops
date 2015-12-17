#!/bin/bash
# env_zk.sh - version 1.0
#
# Bash script used to specify all the environment variables.
#
# Notes:
# - Usually you just need to modify the variables of first section of this file.
#
# Change logs:
#	1.0: (hicham.x.medkouri@jpmorgan.com), intial version

export ZK_HOME=/c/Apps/Servers/clusters/zookeeper/3.4.7
export ZK_WORK=/c/Apps/Services/zookeeper
export ZK_CONF=${ZK_WORK}/conf
export ZK_CONF_FILE=zk.conf
export ZK_DATA=${ZK_WORK}/data
export ZK_LOG=${ZK_WORK}/logs/zk.log
export ZK_NAME=zk-server
export ZK_PORT=2181
export ZK_LOG_LEVEL=INFO

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

export QPID_PNAME="-DPNAME=${QPID_NAME}"
export ZK_PID_FILENAME=${ZK_WORK}/runtime/${ZK_NAME}.pid
export ZK_STOP_SEARCH=${ZK_NAME}

ZK_LOG_CFGFILE=${ZK_WORK}/conf/log4j.properties
ZK_LOGS_DIR=${ZK_WORK}/logs

# For Cygwin, switch paths to Windows format before running java
if $cygwin; then
  #ZK_CONF=`cygpath --absolute --windows "${ZK_CONF}"`
  #ZK_DATA=`cygpath --absolute --windows "${ZK_DATA}"`
  #ZK_LOG=`cygpath --absolute --windows "${ZK_LOG}"`  
  ZK_LOGS_DIR=`cygpath --absolute --windows "${ZK_LOGS_DIR}"`
  ZK_LOG_CFGFILE=`cygpath --absolute --windows "${ZK_LOG_CFGFILE}"`
  ZK_PID_FILENAME=`cygpath --absolute --windows "${ZK_PID_FILENAME}"`  
fi
#export ZK_DATA ZK_LOG ZK_CFGFILE ZK_LOG_CFGFILE ZK_LOGS_DIR
export ZK_LOGS_DIR ZK_LOG_CFGFILE ZK_PID_FILENAME

JAVA_OPTS=
JAVA_OPTS="${JAVA_OPTS} -Dlog4j.configuration=file:\\${ZK_LOG_CFGFILE}"
export JAVA_OPTS

export ZOOCFGDIR=${ZK_CONF}
export ZOOCFG=zk.conf
export ZOOPIDFILE=${ZK_PID_FILENAME}
export ZOO_LOG_DIR=${ZK_LOGS_DIR}
export ZOO_LOG4J_PROP=${ZK_LOG_LEVEL},CONSOLE,ROLLINGFILE
export JVMFLAGS=${JAVA_OPTS}

#echo ZOOCFGDIR=${ZOOCFGDIR}
#echo ZOOCFG=${ZK_CONF_FILE}
#echo ZOOPIDFILE=${ZOOPIDFILE}
#echo ZOO_LOG_DIR=${ZOO_LOG_DIR}
