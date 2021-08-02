
# WeeWx-Docker 

### A Docker-Container to run WeeWX on Raspberry Pi
---
## About

 *  Running WeeWX with a Weatherstation connected per USB
 *  Works on RPI-2/3 and RPI-4 with 64 bit os (branch arm64v8)
 *  Nginx Webserver for showing the reports as website
 *  Uses the SQLite database for saving the weather records
 *  The Database will be written to config/archive/weewx.sdb  
    to have it persistent on the host
---

## Usage:

There are two ways to run the container on a pi after cloning this repository.

 1. Use Docker-Compose to build, start and stop the container (recommended)
 2. Use Docker to build and run the container manually

In both cases you have to edit the config/weewx.conf to your needs.  
 Visit the WeeWX documentation to read about the necassary settings  
[WeeWx Documentation](http://weewx.com/docs.html)

If you don`t edit the config file, WeeWX starts in simulation mode.

When the container is running, it takes a while until WeeWX generates the first report and html files.  
Open http://ip-address-of-your-pi in your browser and press refresh after some time

### With Docker-compose


#### First start in foreground to see if things are running:
```bash
$ docker-compose up
```
Press ctrl+c to stop


#### If evereything is working, start in daemon-mode:

```bash
$ docker-compose up -d
```

### Manual build and start

Build the container:

```bash
   docker build -t weewx .
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
or simply execute the startweewx.sh

---
## Tips and Tricks

### Using docker-compose

#### Inspect the container logs

```bash
$ docker-compose logs
```

#### Restart the container after changing settings in the config file config/weewx.conf

```bash
$ docker-compose restart
```
#### Enter the running container

```bash
$ docker-compose exec weewx /bin/bash
```

### Using docker

#### Inspect the container logs

```bash
$ docker logs weewx
```
#### Stopp, remove and start the container again

```bash
$ docker stop weewx && docker rm weewx
```

Start the container again with the cmd above or the startweewx.sh script

#### Enter the running container

```bash
$ docker exec -it weewx /bin/bash
```

---
### To do:

 * Automate install of plugins and skins when they exist in the config directory
 * Use a mysql container as weewx-db 
 * Generate a realtime.txt to use the weather data with the android app pws watcher


















