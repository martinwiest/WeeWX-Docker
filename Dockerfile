FROM arm32v7/nginx
LABEL maintainer="martinwiest"
ENV WVERSION="weewx-4.5.1"
ENV WSOURCE="http://weewx.com/downloads/$WVERSION.tar.gz"
WORKDIR /tmp
RUN apt-get update -y && apt-get install -y  --no-install-recommends \
	python3 python3-pil python3-cheetah python-mysqldb usbutils ftp python-dev \
	python-pip curl wget rsyslog procps gnupg python-configobj python3-configobj \
	python3-usb python-usb python3-distutils less python3-ephem && \
	rm -rf /var/lib/apt/lists/* && \
# Install weewx
	wget $WSOURCE && tar xzvf $WVERSION.tar.gz && \
	cd $WVERSION && python3 setup.py build && \
	python3 setup.py install --no-prompt && rm -rf /tmp/*
COPY src /opt/src
WORKDIR /opt/src
RUN cp nginx/default.conf /etc/nginx/conf.d/ && cp 5_run.sh  /docker-entrypoint.d/ && \
    chmod +x /docker-entrypoint.d/5_run.sh && cd && rm -rf /opt/src
WORKDIR /home/weewx
VOLUME ["/home/weewx/config"]
EXPOSE 80/tcp
