#!/usr/bin/env bash
# author: martin wiest mail: linux@wiest.io
# -------------------------------------
# Functions:
# Set syslogd to log to file 
# remote host
#
# ENV:
workdir="/home/weewx"
configdir="$workdir/config"

# start busybox syslog
busybox syslogd -O $configdir/weewx.log
