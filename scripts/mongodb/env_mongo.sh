#!/bin/bash
# env_mongo.sh - version 1.0
#
# Bash script used to specify all the environment variables.
#
# Notes:
# - Usually you just need to modify the variables of first section of this file.
#
# Change logs:
#	1.0: hicham medkouri, intial version

export MONGODB_HOME=/apps/servers/stores/mongodb/3.0.5-x64
export MONGODB_WORK=/apps/services/stores/mongodb/mdb-dev-01
export MONGODB_DATA=${MONGODB_WORK}/data
export MONGODB_LOG=${MONGODB_WORK}/logs/mongodb.log
export MONGODB_EXE=mongod.sh
export MONGODB_NAME=mongod
export MONGODB_PORT=2700
export MONGODB_LOG_LEVEL=info

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
export MONGODB_PID_FILENAME=mongodb.pid
export MONGODB_STOP_SEARCH=mongod

MONGODB_CFGFILE=${QPID_WORK}/conf/config.xml
MONGODB_LOG_CFGFILE=${QPID_WORK}/conf/log4j.xml
LOGS_DIR=${MONGODB_WORK}/logs

# For Cygwin, switch paths to Windows format before running java
if $cygwin; then
  MONGODB_DATA=`cygpath --absolute --windows "${MONGODB_DATA}"`
  MONGODB_LOG=`cygpath --absolute --windows "${MONGODB_LOG}"`
  MONGODB_CFGFILE=`cygpath --absolute --windows "${MONGODB_CFGFILE}"`
  MONGODB_LOG_CFGFILE=`cygpath --absolute --windows "${MONGODB_LOG_CFGFILE}"`
  LOGS_DIR=`cygpath --absolute --windows "${LOGS_DIR}"`
fi
export MONGODB_DATA MONGODB_LOG MONGODB_CFGFILE MONGODB_LOG_CFGFILE LOGS_DIR
