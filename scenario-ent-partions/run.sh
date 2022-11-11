#!/usr/bin/env bash

set -euo pipefail

if ! consul version | grep -q +ent ; then
    echo "Must have enterprise binary installed"
    exit 1
fi

rm -rf /tmp/consul-dc1
rm -rf /tmp/consul-dc1-client

http-echo-server 3005 &

echo "Starting Consul"
consul agent -log-level=trace -config-file config_dc1.hcl 1>./logs/dc1.log &

echo "Sleeping for 5 seconds"
sleep 5

echo "Creating Partition"
consul partition create -name foo
consul agent -log-level=trace -config-file config_dc1_client.hcl 1>./logs/dc1_client.log &

echo "Sleeping for 10 seconds"
sleep 10


echo "Write static server config entries into Partition Foo agent"
CONSUL_HTTP_ADDR=localhost:9500 consul config write static-server-service-defaults.hcl
CONSUL_HTTP_ADDR=localhost:9500 consul services register static-server-sidecar-proxy.hcl
CONSUL_HTTP_ADDR=localhost:9500 consul services register static-server.hcl
CONSUL_HTTP_ADDR=localhost:9500 consul config write exported-services.hcl
CONSUL_HTTP_ADDR=localhost:9500 consul config write default-intention.hcl

CONSUL_HTTP_ADDR=localhost:9500 consul connect envoy -sidecar-for static-server -partition foo -address '{{ GetInterfaceIP "$NETWORK_INTERFACE" }}:8446' -grpc-addr="localhost:9502" -admin-bind localhost:19005 -- -l critical &

echo "Write static client config entries into Partition Default"
consul services register static-client.hcl
consul services register static-client-sidecar-proxy.hcl

consul connect envoy -sidecar-for static-client -address '{{ GetInterfaceIP "$NETWORK_INTERFACE" }}:8447' -admin-bind localhost:19004 -- -l critical &

# Cleanup
# pkill node consul envoy
