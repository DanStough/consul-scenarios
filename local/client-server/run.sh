#!/usr/bin/env bash

mkdir -p logs
mkdir -p tmp/data

# start the server 
consul agent -dev 1>./logs/server.log &

# start the client 
consul agent -dev -config-file client.hcl 1>./logs/client.log & 