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

DIFF=$(cmp "$config" "$ownconfig" 2> /dev/null)
if [ -e $ownconfig ] ;
        then
        if [ "$DIFF" = "" ] ;
        then
                echo "No edited configfile found. WeeWx will use default file
        for the demo mode. Edit the weewx.conf in the config folder
        for your needs before starting the container";
                logger -p info "No weewx.conf found, using default";

        else
                echo "Own configfile exits an will be used";
                cp "$ownconfig" "$workdir";
                logger -p info "Your weewx.conf has been copied to use"
        fi
else
        echo "No config file found in the config directory";
        python3 $workdir/bin/wee_config --reconfigure --driver=weewx.drivers.simulator  --no-prompt;
fi


# Test if plugins or skins are in place in config dir and install them
addons="$(find $configdir -type f \( -name "*.zip" -o -name "*.tar.gz" \) 2> /dev/null)" 
for i in $addons ;
  do python3 $workdir/bin/wee_extension --install="$i";
  echo "Install $1";
done

# Copy dirs with skinfiles in the weewx skin dir
skindirs="$(find $configdir/skins -maxdepth 1 -mindepth 1 -type d 2> /dev/null)"
cpskins() {
        for dirs in $skindirs ;
                do cp -r "$dirs" "$workdir/skins"
        done
}

if [ -d "$configdir/skins" ] ;
then
        cpskins ;
        echo "copy your skin dirs";
else
        echo "No unpacked skins found."
fi

# Set the path for the sqlite weewx db to the config path
# This is needed to have a persistant db on the host
sed -i 's+SQLITE_ROOT[ ]=.*+SQLITE_ROOT = %(WEEWX_ROOT)s/config/archive+' "$config"

# Set the web root of nginx to the weewx dir
sed -i 's+root   /usr/share/nginx/html;+root   /home/weewx/public_html;+' "$webconf"

# copy init.d script for weewx
cp $workdir/util/init.d/weewx.debian /etc/init.d/weewx

# Link python
ln -s /usr/bin/python3.7 /usr/bin/python

# start weewx
python3 /home/weewx/bin/weewxd -d -r --config=/home/weewx/weewx.conf
