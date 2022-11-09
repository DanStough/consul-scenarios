#!/usr/bin/env bash

set -euo pipefail

rm -rf /tmp/consul-dc1
rm -rf /tmp/consul-dc2

echo "Starting Consul"
consul agent -dev -config-file config_dc1.hcl 1>./logs/dc1.log &
consul agent -dev -config-file config_dc2.hcl 1>./logs/dc2.log &

echo "Sleeping for 10 seconds"
sleep 10

echo "Starting Gateways"
consul connect envoy -gateway mesh -service dc1-mesh-gateway -address "{{ GetInterfaceIP \"eth0\" }}:8443" -grpc-addr localhost:8502 -admin-bind 0.0.0.0:19004 -expose-servers -register -- --log-level trace --log-path ~/demo/peering-meshgw/logs/dc1_meshgw_logs.txt &
CONSUL_HTTP_ADDR=localhost:9500 consul connect envoy -gateway mesh -service dc2-mesh-gateway -address "{{ GetInterfaceIP \"eth0\" }}:9443" -grpc-addr localhost:9502 -admin-bind 0.0.0.0:19005 -expose-servers -register -- --log-level trace --log-path ~/demo/peering-meshgw/logs/dc2_meshgw_logs.txt &

exit 0





# SCRIPT

# Enable Control Plane Traffic
consul config write mesh.hcl
CONSUL_HTTP_ADDR=localhost:9500 consul config write mesh.hcl

# For the mesh gateway to have outputbound connectivity, the peering must be an outbound connection
# for the cluster.
echo "Establishing Peering"
consul peering generate-token -name accepting-dc2 > before_peering_token.txt

cat before_peering_token.txt | base64 --decode | jq

CONSUL_HTTP_ADDR=localhost:9500  consul peering establish -name dialing-dc1 -peering-token "$(cat before_peering_token.txt)"

