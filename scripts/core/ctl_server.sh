#!/bin/bash
# ctl_server.sh - version 1.0
#
# Bash script to monitor Tomcat and Derby servers.
#
# Notes:
# - This script requires to be under the root directory of
# the server is monitoring (i.e. at the same level as the
# tomcat and derby directories). It also requires derby/ctl_derby.sh
# version 1.2 and a working installation of jython 2.5.x.
#
# Change logs:
#   1.0: intial version by hicham

source tomcat/env_tomcat.sh

HOST=`hostname -f`
PWD=`pwd`
PORT=${TOMCAT_SERVER_PORT}
PAGE='STPService/qpid.jsp'

EMAIL_TO=info@anaxo.io
EMAIL_FROM=info@anaxo.io

monitor() {
        #try to access tomcat's page
        RES=`wget -q -O - --tries=1 --proxy=off http://${HOST}:${PORT}/${PAGE} | grep -c "SUCCESFULL"`
        if [ "$RES" -eq 1 ];
        then
                echo Tomcat is responding on $HOST:$PORT
        else
                echo Tomcat or Derby seems to be dead.
                echo Killing them both ...
                _kill_tomcat
                _kill_derby
                echo Starting Derby then Tomcat ...
                _start_derby
                sleep 10
                _start_tomcat
                _send_mail
        fi
}

_kill_derby() {
        echo Killing Derby process ...
        cd derby
        ./ctl_derby.sh kill
        cd ..
}

_kill_tomcat() {
        echo Killing Tomcat process ...
        cd tomcat
        ./ctl_tomcat.sh stop
        cd ..
}

_start_derby() {
        echo Starting Derby ...
        cd derby
        ./ctl_derby.sh start
        cd ..
}

_start_tomcat() {
        echo Starting Tomcat ...
        cd tomcat
        ./ctl_tomcat.sh start
        cd ..
}

_send_mail() {
        jython <<END
#!/usr/bin/env python

import smtplib

from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

# me == my email address
# you == recipient's email address
me = "$EMAIL_FROM"
you = "$EMAIL_TO"

# Create message container - the correct MIME type is multipart/alternative.
msg = MIMEMultipart('alternative')
msg['Subject'] = "Tomcat Monitor - Server $HOST:$PORT down"
msg['From'] = me
msg['To'] = you
recipients=you.split(",")

# Create the body of the message (a plain-text and an HTML version).
text = "The server $HOST:$PORT is down.\\nRestarting derby and tomcat processes now.\\nPlease check them under $HOST@$PWD"

# Record the MIME types of both parts - text/plain and text/html.
part1 = MIMEText(text, 'plain')

# Attach parts into message container.
msg.attach(part1)

# Send the message via local SMTP server.
s = smtplib.SMTP('mailhost.anaxo.io')
# sendmail function takes 3 arguments: sender's address, recipient's address
# and message to send - here it is sent as one string.
s.sendmail(me, recipients, msg.as_string())
s.quit()
END
}

case "$1" in
    monitor)
        monitor
        ;;
    *)
        echo "Usage: $0 {monitor}"
        exit 1
        ;;
esac