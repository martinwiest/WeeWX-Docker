
# WeeWx-Docker 

### A Docker-Container to run WeeWX on Raspberry Pi
---
## About

 *  Running WeeWX with a Weatherstation connected per USB or SDR
 *  Works on RPI-2/3/4 32bit and RPI-4 with 64 bit,  
    amd64 and x86 architecture  
 *  Nginx Webserver for showing the reports as website
 *  Uses the SQLite database for saving the weather records
 *  The Database will be written to config/archive/weewx.sdb  
    to have it persistent on the host
 *  Prepared to use the BME280 Sensor 

---

## Usage:

There are two ways to run the container on a pi after cloning this repository.

 1. Use Docker-Compose to download, start and stop the container (recommended, downloads multiarch container)
 2. Use Docker to build and run the container manually

In both cases you have to edit the config/weewx.conf to your needs,
otherwise WeeWX runs in simulation mode.

Visit the WeeWX documentation to read about the necessary settings  
[WeeWx Documentation](http://weewx.com/docs.html)

### General

After starting the container, it takes a while until WeeWX generates the first report and writes the files in the webserver root. 

 * Open http://ip-address-of-your-pi in your browser and press refresh after some time
 * Watch the logs to see if WeeWX can connect to your weatherstation. 


### With Docker-compose

#### Start the container

```bash
$ docker-compose up -d
```

This will pull the container from [docker hub](https://hub.docker.com/) and run it in the backgound.

#### Watch the WeeWX logs

At the first time running the container, it is helpfull to watch the logs to see if WeeWX can  
communicate with your weather station or if errors occur.

Show the first 30 lines of the log:

```bash
$ docker-compose exec weewx head -n 30 /var/log/messages
```
Press crtl+c to abort

To follow the log in realtime

```bash
$ docker-compose exec weewx tail -f /var/log/messages
```
Press crtl+c to abort

#### Restart the container 

Restart the container to:
 * use new settings in config/weewx.conf
 * use new added skins and plugins (see customation below)

```bash
$ docker-compose restart
```

#### Enter the running container

Enter the runnig container for debugging

```bash
$ docker-compose exec weewx /bin/bash
```

### With Docker - manual build and start

Build the container:

```bash
$ docker build -t weewx .
```

#### Run the container

You can run the container with:

```bash
docker run -d \
	--name="weewx" \
	--privileged \
	--restart always \
	-p 80:80 \
	-e TZ="Europe/Berlin" \
	-v "$PWD/config":"/home/weewx/config" \
	weewx
```
or simply execute the startweewx.sh script


#### Watch the WeeWX logs

At the first time running the container, it is helpfull to watch the logs to see if WeeWX can  
communicate with your weather station or if errors occur.

Show the first 30 lines of the log:

```bash
$ docker exec -it weewx head -n 30 /var/log/messages

Press crtl+c to abort
```
To follow the log in realtime

```bash
$ docker exec -it weewx tail -f /var/log/messages

Press crtl+c to abort
```

#### Restart the container

Restart the container to:
 * use new settings in config/weewx.conf
 * use new added skins and plugins (see customation below)

```bash
$ docker restart weewx
```

#### Stop and remove the container

```bash
$ docker stop weewx && docker rm weewx
```
---
### Customation - Use of skins and plugins

Plugins and skins can be installed at the container start. Simply create a plugins and  
a skins dir inside the config directory and put your files there.

```bash
$ mkdir config/{skins,plugins}
```
Skins and plugins can be in zip or tar.gz files (eg. weewx-crt.zip or steelseries-2.7.6.tar.gz)

Also you can put your extracted and configured skin there. The startscript in the container will
look for directorys inside config/skins and copy them to the weewx skin directory 

I use the [neowx-material skin](https://neoground.com/projects/neowx) with my settings this way.

Example:

 1. Download the skin from the project site
 2. Extract the zip file and copy the contained neowx-material directory to the config/skins folder 
 3. Edit the skin.conf 
 4. Restart the container
 
### Add files for extra sensors to the weewx user directory
At the moment the adding of extra sensors can only be done by editing or placing a 
definition in a python file in the weewx bin/user directory. If you need to, follow
this steps:

Create a user directory:

```bash
$ mkdir config/user
```
Put your files to this dir:

```bash
$ cp yoursensorfile.py config/user
```

With docker-compose simple restart your service.

When building the container localy: stop, remove and rebuild your container:

```bash 
$ docker stop weewx && docker rm weewx 

$ docker build -t weewx .

$ ./startweewx.sh
```

### To do:

 * Use a mysql container as weewx-db using a mariadb-container with docker-compose

