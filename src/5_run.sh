#!/usr/bin/env bash
# author: martin wiest mail: linux@wiest.io
# -------------------------------------
# Functions:
# start rsyslogd, test for a weewx.conf, start weewx

# start rsyslogd
/usr/sbin/rsyslogd &

workdir="/home/weewx"
configdir="$workdir/config"
ownconfig="$configdir/weewx.conf"
config="$workdir/weewx.conf"

# Test if preconfigured configfile exists and copy it

DIFF=$(cmp "$config" "$ownconfig")
if [ "$DIFF" = "" ] && [ -e $ownconfig ];
then
        echo "No (edited) configfile found. WeeWx will use the default
for the demo mode. Edit the weewx.conf in the config folder
for your needs before starting the container";
        logger -p info "No weewx.conf found, using default"
else
        echo "Own configfile exits an will be used";
        cp "$ownconfig" "$workdir";
        logger -p info "Your weewx.conf has been copied to use"
fi

# Set the path for the sqlite weewx db to the config path
# This is needed to have a persistant db on the host
sed -i 's+SQLITE_ROOT[ ]=.*+SQLITE_ROOT = %(WEEWX_ROOT)s/config/archive+' "$config"
 
# copy init.d script for weewx

cp $workdir/util/init.d/weewx.debian /etc/init.d/weewx

# start weewx
/home/weewx/bin/weewxd /home/weewx/weewx.conf &