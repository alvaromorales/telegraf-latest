FROM golang
MAINTAINER Alvaro Morales <alvarom@mit.edu>

# install dependencies
RUN apt-get update && \
  apt-get install -y git-core

# setup project structure
RUN mkdir -p $GOPATH/src/github.com/influxdb && \
  cd $GOPATH/src/github.com/influxdb && \
  git clone -b client-fix https://github.com/alvaromorales/influxdb.git && \
  git clone https://github.com/influxdb/telegraf.git

ADD build.sh /build.sh
RUN chmod +x /build.sh
RUN /build.sh

RUN mkdir -p /opt/influxdb/ && \
  ln -s $GOPATH/bin/telegraf /opt/influxdb/telegraf

ADD telegraf.toml /telegraf.toml

CMD ["/opt/influxdb/telegraf", "-config", "/telegraf.toml"]
