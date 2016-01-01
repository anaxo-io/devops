#!/bin/bash
# ctl_common.sh - version 1.0
#
# Bash script which contains common functions shared with other scripts.
# If you have a common function that can be added in here, please do so.
#
# He is how this script gets included in another script:
#   SRC=$(cd $(dirname "$0"); pwd)
#   source "${SRC}/ctl_common.sh"
#
# Notes:
# - This script calls the user bash_profile to set the environment variables,
# useful when used to execute a script in a cron job.
#
# change logs:
#   1.0: intial version by hicham

# Debugging: Disabled by default.
#set -x

# set environment variable defined in bash_profile
# this is needed when invoking the scripts from crontab
. $HOME/.bash_profile

# resolve links - $0 may be a softlink
PRG="$0"

while [ -h "$PRG" ]; do
  ls=`ls -ld "$PRG"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '/.*' > /dev/null; then
    PRG="$link"
  else
    PRG=`dirname "$PRG"`/"$link"
  fi
done

# Get standard environment variables
PRGDIR=`dirname "$PRG"`

# Only set BASE_DIR if not already set
[ -z "$BASE_DIR" ] && export BASE_DIR=`cd "$PRGDIR" ; pwd`
