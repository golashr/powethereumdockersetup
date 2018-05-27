FROM ubuntu:latest
#FROM ethereum/client-go:stable

MAINTAINER rahulgolash <rahul.golash@gmail.com>

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN apt install net-tools

RUN apt-get update && apt-get -y install sudo
RUN apt-get -y install software-properties-common
RUN add-apt-repository -y ppa:ethereum/ethereum
RUN apt-get update
RUN apt-get install -y ethereum
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5
#RUN echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/10ge\
RUN echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.6.list
RUN apt-get update

RUN apt-get -y install mongodb-org
RUN apt-get -y install bash \
		       curl \
                       iputils-ping \
                       git \
                       net-tools
RUN apt-get update
#RUN apk add -t .gyp --no-cache git python g++ make \
#    && npm install -g truffle \
#    && apk del .gyp

RUN apt-get update
RUN apt-get -y install gnome-terminal
RUN apt-get update

RUN echo "alias ll='ls-latr' >> ~/.profile"
RUN echo "alias nl='netstat -a | grep -i LISTEN' >> ~/.profile"

RUN mkdir -p /data/db
#RUN apt-get install wget
#RUN wget -qO- https://deb.nodesource.com/setup_7.x | bash -
RUN curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
RUN apt-get install -y nodejs
RUN npm install -g express
RUN npm install -g truffle
RUN apt-get update

#RUN apt-get update

#RUN sudo su
#RUN mkdir /temp
#COPY ethereum.tar /temp
#RUN tar -xvf /temp/ethereum.tar --exclude=etc --exclude=sys

#RUN apt-get install -y solc \
#  && apt-get install -y libssl-dev \
#  && apt-get install -y python3-pip python3-dev \
#  && ln -s /usr/bin/python3 /usr/local/bin/python \
#  && pip3 install --upgrade pip \
#  && apt-get install -y pandoc \
#  && git clone https://github.com/ConsenSys/mythril/ \
#  && cd mythril \
#  &&  pip install mythril

ENV GEN_NONCE="0x045" \
    DATA_DIR="/root/.ethereum" \
    CHAIN_TYPE="private" \
    RUN_BOOTNODE=false \
    GEN_CHAIN_ID=2017 \
    BOOTNODE_URL=""

WORKDIR /opt

# bootnode port
EXPOSE 30301
EXPOSE 30301/udp

ADD src/* /opt/
RUN chmod +x /opt/*.sh

ENTRYPOINT ["/opt/startgeth.sh"]
#CMD ["geth"]
