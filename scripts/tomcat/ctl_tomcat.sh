#!/bin/bash
# ctl_tomcat.sh - version 1.0
#
# Bash script to stop, start and check Tomcat server.
#
# Notes:
# - This script requires env_tomcat.sh to be on the same folder, 
# this file is used to set all the environment variables.
#
# Change logs:
#   1.0: intial version by hicham

source env_tomcat.sh

setJmx() {
    export JAVA_OPTS="${JAVA_OPTS} -Dcom.sun.management.jmxremote"
    export JAVA_OPTS="${JAVA_OPTS} -Dcom.sun.management.jmxremote.port=${TOMCAT_JMX_PORT}"
    export JAVA_OPTS="${JAVA_OPTS} -Dcom.sun.management.jmxremote.ssl=false"
    export JAVA_OPTS="${JAVA_OPTS} -Dcom.sun.management.jmxremote.authenticate=false"
}

start() {
    echo "Starting tomcat ..."
    setJmx
    cwd=$(pwd)
    cd "${CATALINA_HOME}/bin"
    ./startup.sh
    cd "${cwd}"
}

start_jpda() {
    echo "Starting tomcat in jpda mode ..."
    setJmx
    cwd=$(pwd)
    cd "${CATALINA_HOME}/bin"
    ./catalina.sh jpda start
    cd "${cwd}"
}

stop() { 
    echo "Stoping tomcat ..."
    cwd=$(pwd)
    cd "${CATALINA_HOME}/bin"
    ./shutdown.sh -force
    sleep 1
    cd "${cwd}"
}

restart() {
    stop
    start
}

check() {
    cwd=$(pwd)
    if [ -z "${CATALINA_PID}" ]; then
        echo CATALINA_PID not set - cannot continue
        exit 3
    fi

    if [ ! -f "$CATALINA_PID" ]; then
        echo "Warning: No PID file $CATALINA_PID found, cannot check if Tomcat Server is already running"
    else
        PID=$(cat ${CATALINA_PID} | awk '{print $1}')
        if [ -z "$PID" ]; then
            echo "No PID in PID file $CATALINA_PID, cannot check if Tomcat Server is already running"
        else
            echo "PID in check = $PID"
            RUNNING=$(psgrep "$PID")
            if [ ! -z "$RUNNING" ]; then
                echo "Tomcat Server running with PID $PID"
            else
                echo "Tomcat Server is not running"
            fi
        fi
    fi
    cd "${cwd}"
}

case "$1" in
    start)
        start
        ;;
    start_jpda)
        start_jpda
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
        echo "Usage: $0 {start|start_jpda|stop|restart|check}"
        exit 1
        ;;
esac