FROM arm32v7/nginx
LABEL maintainer="martinwiest"
ENV WVERSION="weewx-4.5.1" 
ENV WSOURCE="http://weewx.com/downloads/$WVERSION.tar.gz"
WORKDIR /home/weewx
RUN apt-get update -y && apt-get install -y  --no-install-recommends \
	python3-pil python3-cheetah python3-mysqldb python3-pip \
	python3-configobj python3-usb python3-distutils \
	python3-ephem usbutils ftp curl wget busybox-syslogd procps gnupg && \
	apt-get autoremove && \
	wget $WSOURCE && tar xzvf $WVERSION.tar.gz --strip-components=1 && \
	rm -rf /var/lib/apt/lists/* $WVERSION.tar.gz && \
	mkdir public_html
COPY src/5_run.sh  /docker-entrypoint.d
VOLUME ["/home/weewx/config"]
EXPOSE 80/tcp
