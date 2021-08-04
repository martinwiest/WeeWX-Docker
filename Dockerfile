FROM arm32v7/nginx
LABEL maintainer="martinwiest"
ENV WVERSION="weewx-4.5.1" vpython="python3"
ENV WSOURCE="http://weewx.com/downloads/$WVERSION.tar.gz"
WORKDIR /tmp
RUN apt-get update -y && apt-get install -y  --no-install-recommends \
	$vpython-pil $vpython-cheetah $vpython-mysqldb  $vpython-dev \
	$vpython-pip $vpython-configobj $vpython-usb $vpython-distutils \
	$vpython-ephem usbutils ftp curl wget rsyslog procps gnupg && \
	apt-get autoremove && \
	rm -rf /var/lib/apt/lists/* && \
# Install weewx
	wget $WSOURCE && tar xzvf $WVERSION.tar.gz && \
	cd $WVERSION && $vpython setup.py build && \
	$vpython setup.py install --no-prompt && rm -rf /tmp/*
COPY src /opt/src
WORKDIR /opt/src
RUN cp nginx/default.conf /etc/nginx/conf.d/ && cp 5_run.sh  /docker-entrypoint.d/ && \
    chmod +x /docker-entrypoint.d/5_run.sh && cd && rm -rf /opt/src
WORKDIR /home/weewx
VOLUME ["/home/weewx/config"]
EXPOSE 80/tcp
