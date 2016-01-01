#!/bin/bash
# ctl_derby.sh - version 1.2
#
# This script makes it easier to launch various Derby tools.
#
# Notes:
# - This script requires env_derby.sh to be on the same folder, 
# this file is used to set all the environment variables.
#
# Change logs:
#	1.0: by hicham, intial version.
#   1.1: by hicham:
#        - use derby start, stop and monitor scripts
#        - removed the check and add sysinfo and runtime info
#	1.2: by hicham, added a kill function
#		 which is mainly called by the newly added monitoring script
#		 ctl_server.sh

SRC=$(cd $(dirname "$0"); pwd)
source "${SRC}/ctl_common.sh"

source env_derby.sh

setJmx() {
    export DERBY_OPTS="${DERBY_OPTS} -Dcom.sun.management.jmxremote"
    export DERBY_OPTS="${DERBY_OPTS} -Dcom.sun.management.jmxremote.port=${DERBY_JMX_PORT}"
    export DERBY_OPTS="${DERBY_OPTS} -Dcom.sun.management.jmxremote.ssl=false"
    export DERBY_OPTS="${DERBY_OPTS} -Dcom.sun.management.jmxremote.authenticate=false"
}

start() {
    setJmx
    ${DERBY_HOME}/bin/startNetworkServer ${DERBY_PARAMS} &
}

stop() {
    ${DERBY_HOME}/bin/stopNetworkServer ${DERBY_PARAMS} &
}

restart() {
    stop
    start
}

ij()  {
    ${JAVA_HOME}/bin/java -Dij.protocol=jdbc:derby: -Dij.database=//localhost:${DERBY_PORT}/${DERBY_DBNAME} -classpath ${DERBY_HOME}/lib/derbyrun.jar org.apache.derby.tools.ij
}

sysinfo() {
    ${DERBY_HOME}/bin/NetworkServerControl sysinfo ${DERBY_PARAMS}
}

runtimeinfo() {
    ${DERBY_HOME}/bin/NetworkServerControl runtimeinfo ${DERBY_PARAMS}
}

kill() {
	for pid in `ps -Af | grep -v grep | grep ${DERBY_WORK} | grep ${DERBY_PORT} | awk '{ print $2 }'`
	do
		kill -9 ${pid}
	done
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        restart
        ;;
    ij)
        ij
        ;;
    sysinfo)
        sysinfo
        ;;
    runtimeinfo)
        runtimeinfo
        ;;
	kill)
		kill
		;;
    *)
        echo "Usage: $0 <command>"
        echo "  where <command> is one of start, stop, restart, ij, sysinfo, runtimeinfo, kill"
        exit 1
        ;;
esac