#!/usr/bin/env bash
# author: martin wiest mail: linux@wiest.io
# -------------------------------------
# Functions:
# start rsyslogd, test for a weewx.conf, start weewx

# start busybox syslog
busybox syslogd

workdir="/home/weewx"
configdir="$workdir/config"
ownconfig="$configdir/weewx.conf"
config="$workdir/weewx.conf"
webconf="/etc/nginx/conf.d/default.conf"

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

# Set the web root of nginx to the weewx dir
sed -i 's+root   /usr/share/nginx/html;+root   /home/weewx/public_html;+' "$webconf"

# copy init.d script for weewx
cp $workdir/util/init.d/weewx.debian /etc/init.d/weewx

# Install plugins when they exist in plugin dir
for i in $configdir/plugins/*.zip;
        do python3 $workdir/bin/wee_extension --install="$i"
done

# Link python
ln -s /usr/bin/python3.7 /usr/bin/python

# start weewx
python3 /home/weewx/bin/weewxd -d -r --config=/home/weewx/weewx.conf
