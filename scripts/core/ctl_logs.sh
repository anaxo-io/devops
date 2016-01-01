#!/bin/bash
# ctl_logs.sh - version 1.2
#
# Configurable bash script to clean log files older than 7 days and not in use.
#
# Notes:
# - This script requires ctl_common.sh to be on the same folder.
# - This script requires also a configuration file named ctl_logs.conf on the same folder
# and which should contain the full path to the log directories.
#
# Change logs:
#   1.0: by hicham, intial version.
#   1.1: by hicham, fixed the delete function when filenames contain spaces.
#   1.2: by hicham, add maxdepth 1 to the find in order to delete only log files
#        in the current directory and not recursively.

#set -x

SRC=$(cd $(dirname "$0"); pwd)
source "${SRC}/ctl_common.sh"

check_config() {
    if [ -f $BASE_DIR/ctl_logs.conf ]; then
        CONFIG_FILE=$BASE_DIR/ctl_logs.conf
    else
        echo "No configuration file found! Please add a ctl_logs.conf file under $BASE_DIR, ctl_logs.conf should contain the full path to the log directories, e.g.:"
        echo "  /apps/services/<server_name>/<server_instance>/logs"
        echo "  /apps/services/<server_name>/<server_instance>/deployment/instance1/logs"
        echo "  etc ..."
        exit 1
    fi
}

delete() {
    find $1 -maxdepth 1 -type f -name "*.out" -mtime +3 -or -type f -name "*log*" -mtime +3 | while read _file
    do
        /usr/sbin/lsof "$_file" >/dev/null 2>&1
        _ACTIVE=$?
        if [ $_ACTIVE != 0 ]; then
            echo Deleting "$_file"
            rm "$_file"
        else
            echo Warning "$_file" is still in use
        fi
    done
}

tar() {
    # todo
    echo todo ...
}

remove() {
    for path in `cat $CONFIG_FILE |grep -v "^#"`
    do
        if [ -d $path ]; then
            delete $path
        fi
    done
}

check_config

case "$1" in
  remove)
        remove
        ;;
  tar)
        tar
        ;;
    *)
        echo "Usage: ctl_logs remove | tar"
        exit
esac