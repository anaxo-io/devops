#!/bin/bash
# ctl_cache.sh - version 1.0
#
# Bash script to start, stop and check Coherence Cache Server.
#
# Notes:
# - This script requires env_qpid.sh to be on the same folder, 
# this file is used to set all the environment variables.
#
# Change logs:
#	1.0: by hicham, intial version.

source env_cache.sh

clean() {
	rm -rf ${COHERENCE_WORK}/logs/*
}

setJmx() {
	export COHERENCE_OPTS="${COHERENCE_OPTS} -Dcom.sun.management.jmxremote"
	export COHERENCE_OPTS="${COHERENCE_OPTS} -Dcom.sun.management.jmxremote.port=${COHERENCE_JMX_PORT}"
	export COHERENCE_OPTS="${COHERENCE_OPTS} -Dcom.sun.management.jmxremote.ssl=false"
	export COHERENCE_OPTS="${COHERENCE_OPTS} -Dcom.sun.management.jmxremote.authenticate=false"
	export COHERENCE_OPTS="${COHERENCE_OPTS} -Dtangosol.coherence.management=all"
	export COHERENCE_OPTS="${COHERENCE_OPTS} -Dtangosol.coherence.management.remote=true"
}

start() {
	echo "Starting COHERENCE ..."
	setJmx
	cwd=`pwd`
    cd ${COHERENCE_HOME}/bin
    #./cache-server -run:debug -c ${COHERENCE_CFGFILE} -p ${COHERENCE_PORT} -m ${COHERENCE_JMX_PORT} -l ${COHERENCE_LOG_CFGFILE} &
	exec $JAVA_HOME/bin/java ${JAVA_VM} ${COHERENCE_JAVA_MEM} ${COHERENCE_JAVA_GC} ${COHERENCE_OPTS} -cp "${COHERENCE_CP}" com.tangosol.net.DefaultCacheServer &
	sleep 1
    echo `pgrep -f process.name=${COHERENCE_NAME} | awk '{print $1}'` > ${COHERENCE_WORK}/runtime/${COHERENCE_PID_FILENAME}
    cd ${cwd}
}

stop() { 
	echo "Stoping COHERENCE ..."	
    PID=`cat ${COHERENCE_WORK}/runtime/${COHERENCE_PID_FILENAME} | awk '{print $1}'`
	echo kill -SIGKILL ${PID}    
}

restart() {
    stop
    start
}

check() {
    cwd=`pwd`
    if [ -z "${COHERENCE_WORK}/runtime/${COHERENCE_PID_FILENAME}" ]; then
    	echo COHERENCE_PID not set - cannot continue
        exit 3
    fi

    ALREADY_RUNNING=0

    if [ ! -f "${COHERENCE_WORK}/runtime/${COHERENCE_PID_FILENAME}" ]; then
        echo "Warning: No PID file ${COHERENCE_WORK}/runtime/${COHERENCE_PID_FILENAME} found, cannot check if COHERENCE Server is already running"
    else
        PID=`cat ${COHERENCE_WORK}/runtime/${COHERENCE_PID_FILENAME} | awk '{print $1}'`
        if [ -z "$PID" ]; then
        	echo "No PID in PID file ${COHERENCE_WORK}/runtime/${COHERENCE_PID_FILENAME}, cannot check if COHERENCE Server is already running"
        else
            echo "PID in check = $PID"
            RUNNING=`ps p $PID |grep $PID`
            if [ ! -z "$RUNNING" ]; then
            	echo "COHERENCE Server running with PID $PID"
                ALREADY_RUNNING=1
            else
                echo "COHERENCE Server is not running"
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

