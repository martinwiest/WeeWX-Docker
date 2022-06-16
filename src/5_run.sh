#!/usr/bin/env bash
# author: martin wiest mail: linux@wiest.io
# -------------------------------------
# Functions:
# configure WeeWX and nginx
# install skins, plugins and 
# modified user files 

# ENV:
workdir="/home/weewx"
configdir="$workdir/config"
config="$workdir/weewx.conf"
webconf="/etc/nginx/conf.d/default.conf"

# start busybox syslog
#busybox syslogd -O $configdir/Logs/weewx.log

# Test if preconfigured configfile exists and copy it

configinst() {
	ownconf="$configdir/weewx.conf"
	DIFF=$(cmp "$config" "$ownconf" 2> /dev/null)
	if [ -e $ownconf ] ;
	then
		if [ "$DIFF" = "" ] ;
		then
			echo -e "--- \nNo edited configfile found. WeeWx will use default \n--"
	   	      	cp "$ownconf" "$workdir";
		else
			echo -e "--- \nOwn configfile exists and will be used \n---";
			cp "$ownconf" "$workdir";
		fi
	else
			echo "No config file found in the config directory";
			python3 $workdir/bin/wee_config --reconfigure --driver=weewx.drivers.simulator  --no-prompt;
	fi
}
# Following part sets the global config if not down already
#
# - Set the path for the sqlite weewx db to the weewx.conf
# - Set the web root of nginx to the weewx dir
# - Copy the init.d script for weewx 
# - Link python (maybe not needed anymore, have to be testet)

firststart() {
	if [ -f /firstrun.txt ] ;
	then	
		echo -e "--- \nNot the first start of this container \ncontinue to start without firststart config \n--"; 

	else
			sed -i 's+SQLITE_ROOT[ ]=.*+SQLITE_ROOT = %(WEEWX_ROOT)s/config/archive+' "$config";
			sed -i 's+root   /usr/share/nginx/html;+root   /home/weewx/public_html;+' "$webconf";
			cp $workdir/util/init.d/weewx.debian /etc/init.d/weewx;
			ln -s /usr/bin/python3.7 /usr/bin/python ;
			echo "This container was restarted" >> /firstrun.txt
	fi
}
# Test if plugins or skins are in place in config dir and install them

addoninst() {
addons="$(find $configdir -type f \( -name "*.zip" -o -name "*.tar.gz" \) 2> /dev/null)" 
for i in $addons ;
  do python3 $workdir/bin/wee_extension --install="$i";
  echo "Install $1";
done
}

# Copy dirs with skinfiles in the weewx skin dir

skininst() {
	skins="$(find $configdir/skins -maxdepth 1 -mindepth 1 -type d 2> /dev/null)"
	if [ -d "$configdir/skins" ] ;
	then
		for dir in $skins ;
		do cp -r "$dir" "$workdir/skins";
		echo "Copy $dir to the weewx skin directory"
		done
	else 
		echo -e "--- \nNo skin directorys found, continue to start \n--"
    fi
}

userfiles() {
		userdir="$configdir/user"
		if [ -d $userdir ] ; then
			echo -e "--- \nThere is a user directory, looking for files \n---"
				for i in $(find $userdir -name "*.py");
				do echo "copy $i to the weewx bin/user dir";
				cp $i "$workdir/bin/user";
				done
		else
				echo -e "--- \nNo user directory found, continue to start... \n---"

		fi
}

# call functions
configinst
firststart
addoninst
skininst
userfiles 

# Set python path
ln -sf /usr/bin/python3 /usr/bin/python

# start weewx
/etc/init.d/weewx start
