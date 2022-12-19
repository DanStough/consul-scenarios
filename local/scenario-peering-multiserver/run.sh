#!/usr/bin/env bash

set -euo pipefail

rm -rf /tmp/consul-dc1*
rm -rf /tmp/consul-dc2

echo "Starting Consul Servers - dc1"
consul agent -log-level=trace -config-file config_dc1-1.hcl 1>./logs/dc1-1.log &
consul agent -log-level=trace -config-file config_dc1-2.hcl 1>./logs/dc1-2.log &
consul agent -log-level=trace -config-file config_dc1-3.hcl 1>./logs/dc1-3.log &

sleep 10
echo "Starting Consul Client - dc1"
consul agent -log-level=trace -config-file config_dc1-0.hcl 1>./logs/dc1-0.log & # Agent

echo "Starting Consul Server - dc2"
consul agent -dev -log-level=trace -config-file config_dc2.hcl 1>./logs/dc2.log &
http-echo-server 3005 &

echo "Sleeping for 10 seconds"
sleep 10

echo "Starting mesh gateway"
# This gateway needs to be registered to a client so that it doesn't roll when the server goes away
CONSUL_HTTP_ADDR=localhost:8590 consul connect envoy -gateway mesh -register -- -l critical &

echo "Establishing Peering"
consul peering generate-token -name cluster-02 > before_peering_token.txt
CONSUL_HTTP_ADDR=localhost:9500 consul peering establish -name cluster-01 -peering-token "$(cat before_peering_token.txt)"

# Services are registered to the client, otherwise they will be de-registered during the server rollout
CONSUL_HTTP_ADDR=localhost:8590 consul services register static-server.hcl
CONSUL_HTTP_ADDR=localhost:8590 consul config write static-server-service-defaults.hcl
CONSUL_HTTP_ADDR=localhost:8590 consul services register static-server-sidecar-proxy.hcl
CONSUL_HTTP_ADDR=localhost:8590 consul config write static-server-service-defaults.hcl
CONSUL_HTTP_ADDR=localhost:8590 consul connect envoy -sidecar-for static-server -address '{{ GetInterfaceIP "$NETWORK_INTERFACE" }}:8446' -admin-bind localhost:19005 -- -l critical &
CONSUL_HTTP_ADDR=localhost:8590 consul config write peering-config.hcl

CONSUL_HTTP_ADDR=localhost:9500 consul services register static-client.hcl
CONSUL_HTTP_ADDR=localhost:9500 consul services register static-client-sidecar-proxy.hcl
CONSUL_HTTP_ADDR=localhost:9500 consul connect envoy -sidecar-for static-client -address '{{ GetInterfaceIP "$NETWORK_INTERFACE" }}:19001' -admin-bind localhost:19004 -- -l critical &

# Manually rotate 
# consul agent -retry-join=localhost<leaderport> -log-level=trace -config-file config_dc1-X.hcl 1>./logs/dc1-X.log & 
# CONSUL_HTTP_ADDR=localhost:<followerport> consul leave 

# cCONSUL_HTTP_ADDR=localhost:<followerport> consul peering list

# Cleanup
# pkill node consul envoy
