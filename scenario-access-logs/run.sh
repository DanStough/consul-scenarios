#!/usr/bin/env bash

set -euo pipefail

rm -rf /tmp/consul-dc1

echo "Starting Consul"
consul agent -dev -log-level=info -config-file config_dc1.hcl 1>./logs/dc1.log &
http-echo-server 3005 &

echo "Sleeping for 10 seconds"
sleep 10

echo "Setup Services and Sidecars in the mesh"
consul config write proxy-defaults.hcl

consul services register static-client.hcl
consul services register static-client-sidecar-proxy.hcl
consul config write static-server-service-defaults.hcl
consul services register static-server.hcl
consul services register static-server-sidecar-proxy.hcl

# Admin access logs are configured at startup
consul connect envoy -sidecar-for static-client -address '{{ GetInterfaceIP "$NETWORK_INTERFACE" }}:19001' -admin-bind localhost:19004 -- -l critical 1> ./logs/client-sidecar.logs &
consul connect envoy -sidecar-for static-server -address '{{ GetInterfaceIP "$NETWORK_INTERFACE" }}:8446' -admin-bind localhost:19005 -- -l critical 1> ./logs/server-sidecar.logs &

# Cleanup
# pkill node consul envoy
