#!/bin/bash
# ctl_mongo.sh - version 1.0
#
# Bash script to stop, start and check Mongo DB server.
#
# Notes:
# - This script requires env_mongo.sh to be on the same folder, 
# this file is used to set all the environment variables.
#
# Change logs:
#	1.0: hicham medkouri, intial version.

source env_mongo.sh

start() {
	echo "Starting Mongo DB ..."
	cwd=`pwd`
    cd ${MONGODB_HOME}/bin
    ./${MONGODB_EXE} --dbpath ${MONGODB_DATA} --logRotate rename --logpath ${MONGODB_LOG} --logappend &
    sleep 2
    echo `pgrep -l ${MONGODB_STOP_SEARCH} | awk '{print $1}'` > ${MONGODB_WORK}/runtime/${MONGODB_PID_FILENAME}
    cd ${cwd}
}

stop() { 
	echo "Stoping Mongo DB ..."
	cwd=`pwd`
    cd ${MONGODB_HOME}/bin
    PID=`cat ${MONGODB_WORK}/runtime/${MONGODB_PID_FILENAME} | awk '{print $1}'`
	kill -2 $PID
    sleep 2
    cd ${cwd}
}

restart() {
    stop
    start
}

check() {
    cwd=`pwd`
    if [ -z "${MONGODB_WORK}/runtime/${MONGODB_PID_FILENAME}" ]; then
    	echo MONGODB_PID not set - cannot continue
        exit 3
    fi

    ALREADY_RUNNING=0

    if [ ! -f "${MONGODB_WORK}/runtime/${MONGODB_PID_FILENAME}" ]; then
        echo "Warning: No PID file ${MONGODB_WORK}/runtime/${MONGODB_PID_FILENAME} found, cannot check if Mongo DB Server is already running"
    else
        PID=`cat ${MONGODB_WORK}/runtime/${MONGODB_PID_FILENAME} | awk '{print $1}'`
        if [ -z "$PID" ]; then
        	echo "No PID in PID file ${MONGODB_WORK}/runtime/${MONGODB_PID_FILENAME}, cannot check if Mongo DB Server is already running"
        else
            echo "PID in check = $PID"
            RUNNING=`ps p $PID |grep $PID`
            if [ ! -z "$RUNNING" ]; then
            	echo "Mongo DB Server running with PID $PID"
                ALREADY_RUNNING=1
            else
                echo "Mongo DB Server is not running"
            fi
        fi
    fi
    cd ${cwd}
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
    check)
        check
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|check}"
        exit 1
        ;;
esac
