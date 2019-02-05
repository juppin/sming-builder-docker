FROM debian:stretch-slim

RUN	apt-get update && \
	apt-get -y dist-upgrade && \
	apt-get -y install \
		sudo \
		make \
		autoconf \
		automake \
		libtool \
		libtool-bin \
		gcc \
		g++ \
		gperf \
		flex \
		bison \
		texinfo \
		gawk \
		ncurses-dev \
		libexpat1-dev \
		python \
		sed \
		python-serial \
		python-dev \
		srecord \
		bc \
		git \
		help2man \
		unzip \
		bzip2 \
		wget

RUN	mkdir -p /opt && \
	adduser --disabled-password --gecos '' sming && \
	adduser sming sudo && \
	echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
	chown sming /opt
USER	sming

ENV ESP_DL_URL="https://www.dropbox.com/s/dx9tcqnx0yj61i3/esp-open-sdk-1.5.4-linux-x86_64.tar.gz?dl=1"
ENV ESP_HOME=/opt/esp-open-sdk
RUN	cd /opt && \
#	git clone --recursive https://github.com/pfalcon/esp-open-sdk.git && \
#	cd /opt/esp-open-sdk && \
#	chown -R $(whoami):$(whoami) . && \
#	make VENDOR_SDK=1.5.4 STANDALONE=y && \
	# install esp-open-sdk
	wget -O esp-open-sdk.tar.gz ${ESP_DL_URL} && \
	tar xf esp-open-sdk.tar.gz && \
	rm esp-open-sdk.tar.gz && \
	# install esptool
	wget https://github.com/themadinventor/esptool/archive/master.zip && \
	unzip master.zip && \
	mv esptool-master $ESP_HOME/esptool && \
	rm master.zip && \
	# install esptool2
	cd  $ESP_HOME && \
	git clone https://github.com/raburton/esptool2 && \
	cd esptool2 && \
	make
ENV PATH=$PATH:/esp8266/esp-open-sdk/xtensa-lx106-elf/bin:$ESP_HOME/esptool2

ENV SMING_HOME=/opt/Sming/Sming
RUN	cd /opt && \
	git clone https://github.com/SmingHub/Sming.git && \
	cd Sming && \
	git checkout origin/master && \
	cd Sming && \
	make ENABLE_SSL=1

WORKDIR	/workspace
ENTRYPOINT ["/bin/bash"]
