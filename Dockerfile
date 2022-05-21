FROM nginx
LABEL maintainer="martinwiest"
ENV WVERSION="weewx-4.8.0" 
ENV WSOURCE="http://weewx.com/downloads/$WVERSION.tar.gz"
ENV PATH "$PATH:/home/weewx/bin"
WORKDIR /home/weewx
RUN apt-get update -y && apt-get install -y  --no-install-recommends \
	python3-pil python3-cheetah python3-mysqldb python3-pip \
	python3-configobj python3-usb python3-distutils python3-paho-mqtt \
	python3-ephem usbutils ftp curl wget busybox-syslogd procps gnupg \
	python3-smbus i2c-tools rtl-sdr rtl-433 && \
	apt-get autoremove && \
	wget $WSOURCE && tar xzvf $WVERSION.tar.gz --strip-components=1 && \
	rm -rf /var/lib/apt/lists/* $WVERSION.tar.gz && \
	mkdir public_html
RUN pip install RPi.bme280
COPY src/5_run.sh  /docker-entrypoint.d
VOLUME ["/home/weewx/config"]
EXPOSE 80/tcp
