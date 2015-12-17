#!/bin/bash
# ctl_zk.sh - version 1.0
#
# Bash script to stop, start and check a ZooKeeper server.
#
# Notes:
# - This script requires env_zk.sh to be on the same folder, 
# this file is used to set all the environment variables.
#
# Change logs:
#	1.0: hicham medkouri, intial version.

source env_zk.sh

start() {
	echo "Starting ZooKeeper ..."
	cwd=`pwd`
    cd ${ZK_HOME}/bin
    ./zkServer.sh start
    cd ${cwd}
}

stop() { 
	echo "Stoping ZooKeeper ..."
	cwd=`pwd`
    cd ${ZK_HOME}/bin
    ./zkServer.sh stop
    cd ${cwd}
}

restart() {
    echo "Stoping ZooKeeper ..."
    cwd=`pwd`
    cd ${ZK_HOME}/bin
    ./zkServer.sh restart
    cd ${cwd}
}

check() {
   echo "Stoping ZooKeeper ..."
    cwd=`pwd`
    cd ${ZK_HOME}/bin
    ./zkServer.sh status
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
