#!/usr/bin/env bash

set -euo pipefail

rm -rf /tmp/consul-dc1

echo "Starting Consul"
/opt/homebrew/Cellar/consul/1.19.1/bin/consul agent -dev -log-level=info -config-file config_dc1.hcl 1>./logs/dc1_server.log &
# http-echo-server 3005 &

/opt/homebrew/Cellar/consul/1.19.1/bin/consul agent -dev -log-level=info -config-file config_dc1_client.hcl 1>./logs/dc1_client.log &


echo "Configure Client Aliases"
sudo ifconfig lo0 alias 127.0.0.2 up

echo "Sleeping for 10 seconds"
sleep 10

# echo "Setup Services and Sidecars in the mesh"
# consul config write proxy-defaults.hcl

/opt/homebrew/Cellar/consul/1.19.1/bin/consul services register postgres-master.hcl #Server
CONSUL_HTTP_ADDR="http://127.0.0.2:8500" /opt/homebrew/Cellar/consul/1.19.1/bin/consul services register postgres-replica1.hcl #Client
# /opt/homebrew/Cellar/consul/1.19.1/bin/consul services register postgres-replica2.hcl

# consul services register static-client-sidecar-proxy.hcl
# consul config write static-server-service-defaults.hcl
# consul services register static-server.hcl
# consul services register static-server-sidecar-proxy.hcl

# # Admin access logs are configured at startup
# consul connect envoy -sidecar-for static-client -address '{{ GetInterfaceIP "$NETWORK_INTERFACE" }}:19001' -admin-bind localhost:19004 -- -l critical 1> ./logs/client-sidecar-stdout.logs 2> ./logs/client-sidecar-stderr.logs &
# consul connect envoy -sidecar-for static-server -address '{{ GetInterfaceIP "$NETWORK_INTERFACE" }}:8446' -admin-bind localhost:19005 -- -l critical 1> ./logs/server-sidecar-stdout.logs 2> ./logs/server-sidecar-stderr.logs &

# Cleanup
# pkill node consul envoy
