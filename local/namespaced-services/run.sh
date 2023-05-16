#!/usr/bin/env bash

set -euo pipefail

rm -rf /tmp/consul-dc1-server
rm -rf /tmp/consul-dc1-client

#Verify ENT
consul version | grep -q +ent

echo "Starting Consul"
consul agent -dev -log-level=trace -config-file config_dc1-server.hcl 1>./logs/dc1-server.log &
consul agent -dev -log-level=trace -config-file config_dc1-client.hcl 1>./logs/dc1-client.log &
http-echo-server 3005 &

echo "Sleeping for 10 seconds"
sleep 10

echo "Create the namespace with the server"
consul namespace write namespace.hcl
sleep 5

echo "Register the service with the client agent"
CONSUL_HTTP_ADDR=localhost:8510 consul services register static-server.hcl

# Investigate
# consul namespace list
# consul catalog services
# consul catalog services -namespace demo
# http http://127.0.0.1:8500/v1/agent/checks\?ns\=demo

# consul namespace delete demo

# Observe errros syncing to a non-existent namepsace in the client logs.
# Server logs look OK
# Checks are still registered to the node.

# consul namespace list
# consul catalog services
# consul catalog services -namespace demo
# http http://127.0.0.1:8500/v1/agent/checks\?ns\=demo

# Cleanup
# pkill node consul envoy
