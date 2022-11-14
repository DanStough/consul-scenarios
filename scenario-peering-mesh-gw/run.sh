#!/usr/bin/env bash

set -euo pipefail

rm -rf /tmp/consul-dc1
rm -rf /tmp/consul-dc1-seconday
rm -rf /tmp/consul-dc1-third
rm -rf /tmp/consul-dc2

echo "Starting Consul"
consul agent -log-level trace -config-file config_dc1.hcl 1>./logs/dc1.log &
consul agent -dev -log-level trace -config-file config_dc2.hcl 1>./logs/dc2.log &

echo "Sleeping for 10 seconds"
sleep 30

echo "Starting Gateways"
consul connect envoy -gateway mesh -service dc1-mesh-gateway -address "{{ GetInterfaceIP \"lo0\" }}:8443" -grpc-addr localhost:8502 -admin-bind 0.0.0.0:19004 -register -- --log-level info --log-path ./logs/dc1_meshgw_logs.txt 1>./logs/dc1-consul-sidecar.log &
CONSUL_HTTP_ADDR=localhost:9500 consul connect envoy -gateway mesh -service dc2-mesh-gateway -address "{{ GetInterfaceIP \"lo0\" }}:9443" -grpc-addr localhost:9502 -admin-bind 0.0.0.0:19005 -register -- --log-level info --log-path ./logs/dc2_meshgw_logs.txt 1>./logs/dc2-consul-sidecar.log  &
echo "waiting for gateways to start..."
sleep 5

exit 0

# SCRIPT

# Enable Control Plane Traffic
consul config write mesh.hcl
CONSUL_HTTP_ADDR=localhost:9500 consul config write mesh.hcl


# For the mesh gateway to have outputbound connectivity, the peering must be an outbound connection
# for the cluster.
echo "Establishing Peering"
consul peering generate-token -name accepting-dc2 > peering_token.txt
CONSUL_HTTP_ADDR=localhost:9500  consul peering establish -name dialing-dc1 -peering-token "$(cat peering_token.txt)"

# Get unique serverName used as SNI
ACCEPTING_SNI=$(cat peering_token.txt | base64 --decode | jq -r .ServerName)

# verify traffic 
curl http://localhost:19005/clusters | grep "$ACCEPTING_SNI"

# Cleanup
# pkill node consul envoy
