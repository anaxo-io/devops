#!/bin/bash
# ctl_qpid.sh - version 1.2
#
# Bash script to stop, start and check QPid Broker.
#
# Notes:
# - This script requires env_qpid.sh to be on the same folder, 
# this file is used to set all the environment variables.
#
# Change logs:
#	1.0: by hicham, intial version.
#	1.1: by hicham, using the PID to stop the broker.
#	1.2: by hicham:
#		 - specify a runtime pid file with ${QPID_PID_FILENAME} created under ${QPID_WORK}/runtime.
#		 - retrieve the pid of qpid and right it down in ${QPID_WORK}/runtime/${QPID_PID_FILENAME} 
#		   for later use in check stop command.

source env_qpid.sh

setJmx() {
	export QPID_OPTS="${QPID_OPTS} -Dcom.sun.management.jmxremote"
	export QPID_OPTS="${QPID_OPTS} -Dcom.sun.management.jmxremote.port=${QPID_JMX_PORT}"
	export QPID_OPTS="${QPID_OPTS} -Dcom.sun.management.jmxremote.ssl=false"
	export QPID_OPTS="${QPID_OPTS} -Dcom.sun.management.jmxremote.authenticate=false"
}

start() {
	echo "Starting qpid ..."
	setJmx
	cwd=`pwd`
    cd ${QPID_HOME}/bin
    ./qpid-server -run:debug -c ${QPID_CFGFILE} -p ${QPID_PORT} -m ${QPID_JMX_PORT} -l ${QPID_LOG_CFGFILE} &
	sleep 1
    echo `pgrep -f ${QPID_STOP_SEARCH} | awk '{print $1}'` > ${QPID_WORK}/runtime/${QPID_PID_FILENAME}
    cd ${cwd}
}

stop() { 
	echo "Stoping qpid ..."
	cwd=`pwd`
    cd ${QPID_HOME}/bin
    PID=`cat ${QPID_WORK}/runtime/${QPID_PID_FILENAME} | awk '{print $1}'`
	./qpid.stop $PID
    sleep 1
    cd ${cwd}
}

restart() {
    stop
    start
}

check() {
    cwd=`pwd`
    if [ -z "${QPID_WORK}/runtime/${QPID_PID_FILENAME}" ]; then
    	echo QPID_PID not set - cannot continue
        exit 3
    fi

    ALREADY_RUNNING=0

    if [ ! -f "${QPID_WORK}/runtime/${QPID_PID_FILENAME}" ]; then
        echo "Warning: No PID file ${QPID_WORK}/runtime/${QPID_PID_FILENAME} found, cannot check if Qpid Server is already running"
    else
        PID=`cat ${QPID_WORK}/runtime/${QPID_PID_FILENAME} | awk '{print $1}'`
        if [ -z "$PID" ]; then
        	echo "No PID in PID file ${QPID_WORK}/runtime/${QPID_PID_FILENAME}, cannot check if Qpid Server is already running"
        else
            echo "PID in check = $PID"
            RUNNING=`ps p $PID |grep $PID`
            if [ ! -z "$RUNNING" ]; then
            	echo "QPid Server running with PID $PID"
                ALREADY_RUNNING=1
            else
                echo "QPid Server is not running"
            fi
        fi
    fi
    cd ${cwd}
}

case "$1" in
    start)
      	start
        ;;
    check)
        check
        ;;
    stop)
        stop
        ;;
    restart)
        restart
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|check}"
        exit 1
        ;;
esac

