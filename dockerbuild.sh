#!/bin/bash

docker build -t lora-gateway-bridge-v1 .
docker tag lora-gateway-bridge-v1 10.214.1.197:5000/lora-gateway-bridge-v1
docker push 10.214.1.197:5000/lora-gateway-bridge-v1
