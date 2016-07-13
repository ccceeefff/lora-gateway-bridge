FROM golang:1.6.2

ENV PROJECT_PATH=/go/src/github.com/brocaar/lora-gateway-bridge
ENV PATH=$PATH:$PROJECT_PATH/build

# install tools
RUN go get github.com/golang/lint/golint
RUN go get github.com/kisielk/errcheck

# setup work directory
RUN mkdir -p $PROJECT_PATH
WORKDIR $PROJECT_PATH

# copy source code
COPY . $PROJECT_PATH

# build
RUN make build

# dont automatically run, lets manage this using confd
#CMD ["lora-gateway-bridge"]

# download confd
ADD https://github.com/kelseyhightower/confd/releases/download/v0.11.0/confd-0.11.0-linux-amd64 /usr/local/bin/confd
RUN chmod +x /usr/local/bin/confd

# create paths
RUN mkdir -p /etc/confd/{conf.d,templates}
RUN mkdir -p /etc/lora
RUN mkdir -p /var/log/lora-gw

# copy scripts into directories
COPY scripts/lora-gw.tmpl /etc/confd/templates/lora-gw.tmpl
COPY scripts/lora-gw.toml /etc/confd/conf.d/lora-gw.toml
COPY scripts/confd-watch-lora-gw /usr/local/bin/confd-watch-lora-gw
COPY scripts/start_lora_bridge.sh /usr/local/bin/start_lora_bridge.sh
RUN chmod +x /usr/local/bin/confd-watch-lora-gw
RUN chmod +x /usr/local/bin/start_lora_bridge.sh

CMD ["confd-watch-lora-gw"]
