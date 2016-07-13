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
RUN wget -L https://github.com/kelseyhightower/confd/releases/download/v0.11.0/confd-0.11.0-linux-amd64 -o /usr/local/bin/confd
RUN chmod +x /usr/local/bin/confd

# create paths
RUN mkdir -p /etc/confd/{conf.d,templates}

# copy scripts into directories
RUN cp $PROJECT_PATH/scripts/lora-gw.tmpl /etc/confd/templates/lora-gw.tmpl
RUN cp $PROJECT_PATH/scripts/lora-gw.toml /etc/confd/conf.d/lora-gw.toml
RUN cp $PROJECT_PATH/scripts/confd-watch-lora-gw /usr/local/bin/confd-watch-lora-gw
RUN chmod +x /usr/local/bin/confd-watch-lora-gw

CMD ["confd-watch-lora-gw"]
