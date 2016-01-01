#!/bin/bash
# ctl_apache.sh - version 1.1
#
# Bash script to stop, start and restart apache server.
#
# Notes:
# - This script relies on the fact that apache is installed under a common place, c.f. $APACHE_INST_DIR.
# - This script requires ctl_common.sh to be on the same folder.
#
# Change logs:
#   1.0: by hicham, intial version.
#   1.1: by hicham, changed the restart method to use apache restart command.

SRC=$(cd $(dirname "$0"); pwd)
source "${SRC}/ctl_common.sh"

APACHE_INST_DIR=/apps/services/common/apache/current

# script methods

check() {
    if [ -z "$BASE_DIR" ]; then
        echo "BASE_DIR variable not set"
        exit
    fi
    CONFIG_FILE=$BASE_DIR/apache/conf/httpd.conf
}

start() {
    check
    echo "Starting Apache"
    $APACHE_INST_DIR/bin/apachectl -f $CONFIG_FILE -k start
}

stop() {
    check
    echo "Stopping Apache"
    $APACHE_INST_DIR/bin/apachectl -f $CONFIG_FILE -k stop
}

restart() {
    check
    echo "Restarting Apache"
    $APACHE_INST_DIR/bin/apachectl -f $CONFIG_FILE -k restart
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
  *)
        echo $"Usage: ctl_apache {start|stop|restart}"
        exit
esac
