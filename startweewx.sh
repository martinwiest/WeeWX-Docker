#!/usr/bin/env bash
# author: martin wiest mail: linux@wiest.io
# Script to start the weewx container
# --------------------------------------------------
# Usage - Choose one of the following modes:
# 1. Start the script with no parameters will start the container
# in privileged mode (not recommended for security reasons)
#
# 2. Start the script with the parameter "usb" will start the container
# without privileged mode. You have to set the variable usbid below
# in the settings-section
# Example: ./startweex.sh usb
# --------------------------------------------------
# Finding out the usbid of your Weatherstation:
# $ lsusb
# Bus 001 Device 004: ID 1941:8021 Dream Link WH1080 Weather Station / USB Missile Launcher
# In this example the usbid is /dev/bus/usb/001/004

# Settings:

# Port for the webserver to display reports
webport="80"

# Set the timezone 
timezone="Europe/Berlin"

# Set your weather-station usb-id, if you can´t run the container
# in privleged mode. 
usbid="/dev/bus/usb/001/004"

# --------------------------------------------------
function default() {
	docker run -d \
	--name="weewx" \
	--privileged \
	--restart always \
	-p "$webport":80 \
	-e TZ="Europe/Berlin" \
	-v "$PWD/config":"/home/weewx/config" \
	weewx
}

function usbid() {
	docker run -d \
	--name="weewx" \
	--restart always \
	-p "$webport":80 \
	-e TZ="Europe/Berlin" \
	--device="$usbid" \
	-v "$PWD/config":"/home/weewx/config" \
	weewx
}

if [ "$1" = "usb" ] 
then	
	usbid
else
	default
fi	

