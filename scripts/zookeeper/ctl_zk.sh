#!/bin/bash
# ctl_mongo.sh - version 1.0
#
# Bash script to stop, start and check ZooKeeper.
#
# Notes:
# - This script requires env_mongo.sh to be on the same folder, 
# this file is used to set all the environment variables.
#
# Change logs:
#	1.0: (hicham.x.medkouri@jpmorgan.com), intial version.

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
