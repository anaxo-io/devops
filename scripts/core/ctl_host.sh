#!/bin/bash
# ctl_host.sh - version 1.0
#
# Bash script to stop and start all the services running on a particular host.
# It can also be used to release a service (war file) to a particular or all instances.
#
# Notes:
# - This script relies on ctl_common.sh to be on the same folder.
#
# Change logs:
#       1.0:    by hicham, intial version.

#set -x

if [[ $USER != "root" ]]; then
        echo "You must be root to use this script."
        exit
fi

SRC=$(cd $(dirname "$0"); pwd)
source "${SRC}/ctl_common.sh"

# Get standard environment variables
PRGDIR=`dirname "$PRG"`

# Only set BASE_DIR if not already set
[ -z "$BASE_DIR" ] && export BASE_DIR=`cd "$PRGDIR" ; pwd`

# script methods

#=== FUNCTION ================================================================
# NAME:                 _call
# DESCRIPTION:  Call the control script of the given process under the given
#                               instance.
# PARAMETER 1:  the location which represents the server instance
# PARAMETER 2:  the process that we want to control
# PARAMETER 3:  the action that we want to perform on the process
#=============================================================================
_call() {
        if [[ -z "$1" || -z "$2" || -z "$3" ]]; then
        usage
    fi
        ENV_TO_CTL="$BASE_DIR/*/$2/ctl_$2.sh"
        if [[ "$1" != "all" ]]; then
                ENV_TO_CTL="$BASE_DIR/$1/$2/ctl_$2.sh"
        fi
        for INST in $ENV_TO_CTL
        do
                if [[ -f $INST && -x $INST ]];
                then
                        DIR=$(dirname "$INST")
                        cd $DIR
                        echo Calling ./ctl_$2.sh $3 under $DIR
                        ./ctl_$2.sh $3
                        cd $BASE_DIR
                fi
        done
}

#=== FUNCTION ================================================================
# NAME: _execute
# DESCRIPTION:  Dispatch the excution to specific calls.
# PARAMETER 1:  the location which represents the server instance
# PARAMETER 2:  the process that we want to control
# PARAMETER 3:  the action that we want to perform on the process
#=============================================================================
_execute() {
    if [[ -z "$1" || -z "$2" || -z "$3" ]]; then
        usage
    fi
        if [[ "$2" == "tomcat" || "$2" == "derby" ]]; then
                _call $1 $2 $3
        fi
        if [[ "$2" == "both" ]]; then
                _call $1 derby $3
                _call $1 tomcat $3
        fi
}

#=== FUNCTION ================================================================
# NAME: start
# DESCRIPTION: Start a given process located under a given location.
# PARAMETER 1:  the location which represents the server instance
# PARAMETER 2:  the process that we want to start
#=============================================================================
start() {
        _execute $1 $2 start
}

#=== FUNCTION ================================================================
# NAME: stop
# DESCRIPTION: Stop a given process located under a given location.
# PARAMETER 1:  the location which represents the server instance
# PARAMETER 2:  the process that we want to stop
#=============================================================================
stop() {
        _execute $1 $2 stop
}

#=== FUNCTION ================================================================
# NAME: list
# DESCRIPTION: Display all the instance and processes installed in this host.
# PARAMETER 1: ---
#=============================================================================
list() {
        echo todo
}

#=== FUNCTION ================================================================
# NAME: release
# DESCRIPTION:  Release an update of a given service to the tomcat server
#                               for a given instance.
# PARAMETER 1:  the location which represents the server instance
# PARAMETER 2:  the service that will get updated (if it already exists)
# PARAMETER 3:  the version that we want to update to
#=============================================================================
release() {
        if [[ -z "$1" || -z "$2" || -z "$3" ]]; then
                usage
        fi

        SERVICE=$2
        VERSION=$3
    ENV_TO_UPDATE="$BASE_DIR/*/tomcat/ctl_tomcat.sh"

    if [[ "$1" != "all" ]]; then
        ENV_TO_UPDATE="$BASE_DIR/$1/tomcat/ctl_tomcat.sh"
    fi

    for INST in $ENV_TO_UPDATE
    do
        if [[ -f $INST && -x $INST ]];
        then
            DIR=$(dirname "$INST")
            if [[ -f $DIR/webapps/${SERVICE}.war ]];
            then
                echo Updating ${SERVICE}.war to version ${VERSION} for the instance ${DIR} ...
                cd $DIR
                ./ctl_tomcat.sh stop
                echo Copying ${SERVICE}-${VERSION}.war under $DIR/webapps
                cp /apps/app-sources/tomcat-apps/${SERVICE}/${SERVICE}-${VERSION}.war  webapps/${SERVICE}.war
                ./ctl_tomcat.sh start
                cd $BASE_DIR
            fi
        fi
    done
}

#=== FUNCTION ================================================================
# NAME: usage
# DESCRIPTION: Display usage information for this script.
# PARAMETER 1: ---
#===============================================================================
usage() {
        echo $"Usage:   ctl_host.sh {start <location> <process> | stop <location> <process> | restart <location> <process> | release <location> <service> <version>}"
        echo $" where:"
        echo $" - <location> can be one of the instance e.g. 'emea-dev1' or 'all'"
        echo $" - <process> must specify 'tomcat' or 'derby' or 'both'"
        echo $" - <service> must specify the service name that you want to update, e.g. STPService"
        echo $" - <version> must specify the version number that you want to update to, e.g. 3.0.28"
        exit
}

case "$1" in
        start)
                start $2 $3
                ;;
        stop)
                stop $2 $3
                ;;
        restart)
                stop $2 $3
                start $2 $3
                ;;
        list)
                list
                ;;
        release)
                release $2 $3 $4
                ;;
        *)
                usage
                ;;
esac