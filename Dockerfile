FROM arm64v8/nginx
LABEL maintainer="martinwiest"
ENV WVERSION="weewx-4.8.0" 
ENV WSOURCE="http://weewx.com/downloads/$WVERSION.tar.gz"
ENV PYTHONPATH "${PYTHONPATH}:/usr/bin/python3.9"
WORKDIR /home/weewx
RUN apt-get update -y && apt-get install -y  --no-install-recommends \
	python3-pil python3-cheetah python3-mysqldb python3-pip \
	python3-configobj python3-usb python3-distutils python3-paho-mqtt \
	python3-ephem usbutils ftp curl wget busybox-syslogd procps gnupg && \
	apt install -y rtl-sdr rtl-433 && \
	apt install -y vim less && \
	apt-get autoremove && \
	wget $WSOURCE && tar xzvf $WVERSION.tar.gz --strip-components=1 && \
	rm -rf /var/lib/apt/lists/* $WVERSION.tar.gz && \
	mkdir public_html
COPY src/5_run.sh  /docker-entrypoint.d
VOLUME ["/home/weewx/config"]
EXPOSE 80/tcp
