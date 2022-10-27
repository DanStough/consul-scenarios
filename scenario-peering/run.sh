#!/usr/bin/env bash

set -euo pipefail

rm -rf /tmp/consul-dc1
rm -rf /tmp/consul-dc2

echo "Starting Consul"
consul agent -dev -log-level=trace -config-file config_dc1.hcl 1>./logs/dc1.log &
consul agent -dev -log-level=trace -config-file config_dc2.hcl 1>./logs/dc2.log &
http-echo-server 3005 &

echo "Sleeping for 10 seconds"
sleep 10

# echo "Starting gateways"
consul connect envoy -gateway mesh -expose-servers -register -- -l critical &
curl --request POST --data '{"PeerName":"cluster-02", "Meta": {"env": "production"}}' --url http://localhost:8500/v1/peering/token > before_peering_token.json
jq --arg PeerName cluster-01 '.PeerName = $PeerName' before_peering_token.json > peering_token.json
curl --request POST --data @peering_token.json http://127.0.0.1:9500/v1/peering/establish
consul config write peering-config.hcl

CONSUL_HTTP_ADDR=localhost:9500 consul services register static-client.hcl
CONSUL_HTTP_ADDR=localhost:9500 consul services register static-client-sidecar-proxy.hcl
CONSUL_HTTP_ADDR=localhost:9500 consul config write static-server-service-defaults.hcl

consul services register static-server.hcl
consul services register static-server-sidecar-proxy.hcl
CONSUL_HTTP_ADDR=localhost:9500 consul connect envoy -sidecar-for static-client -address '{{ GetInterfaceIP "$NETWORK_INTERFACE" }}:19001' -admin-bind localhost:19004 -- -l critical &
consul connect envoy -sidecar-for static-server -address '{{ GetInterfaceIP "$NETWORK_INTERFACE" }}:8446' -admin-bind localhost:19005 -- -l critical &

# Cleanup
# pkill node consul envoy
