#!/usr/bin/env bash

set -euo pipefail

rm -rf /tmp/consul-dc1
rm -rf /tmp/consul-dc2

# ********************************************
echo "Starting Consul - Primary Datacenter"
consul agent -dev -log-level=trace -config-file config_dc1.hcl 1>./logs/dc1.log &

echo "...Sleeping for 10 seconds"
sleep 10

echo "...Starting gateways for control plane and data traffic"
consul connect envoy -ignore-envoy-compatibility -gateway mesh -expose-servers -service dc1-mesh-gateway-one -address "{{ GetInterfaceIP \"lo0\" }}:8443" -wan-address "{{ GetInterfaceIP \"lo0\" }}:8443" -grpc-addr localhost:8502 -admin-bind 0.0.0.0:19004 -register -- --log-level debug --log-path ./logs/dc1_meshgw1_logs.txt 1>./logs/dc1-meshgw1-connect.log &
consul connect envoy -ignore-envoy-compatibility -gateway mesh -expose-servers -service dc1-mesh-gateway-two -address "{{ GetInterfaceIP \"lo0\" }}:8444" -wan-address "{{ GetInterfaceIP \"lo0\" }}:8444" -grpc-addr localhost:8502 -admin-bind 0.0.0.0:19005 -register -- --log-level debug --log-path ./logs/dc1_meshgw2_logs.txt 1>./logs/dc1-meshgw2-connect.log &

echo "...Starting client service and registering in primary datacenter"

consul services register static-client.hcl
consul services register static-client-sidecar-proxy.hcl
consul config write proxy-defaults.hcl

consul connect envoy -ignore-envoy-compatibility -sidecar-for static-client -address '{{ GetInterfaceIP "lo0" }}:8445' -admin-bind localhost:19006 -- -l critical &


# ********************************************
echo "Starting Consul - Secondary Datacenter"
consul agent -dev -log-level=trace -config-file config_dc2.hcl 1>./logs/dc2.log &

echo "...Sleeping for 10 seconds"
sleep 10

echo "...Starting gateways for control plane and data traffic"
CONSUL_HTTP_ADDR=localhost:9501 consul connect envoy -ignore-envoy-compatibility -gateway mesh -expose-servers -service dc2-mesh-gateway-one -address "{{ GetInterfaceIP \"lo0\" }}:9443" -wan-address "{{ GetInterfaceIP \"lo0\" }}:9443" -grpc-addr localhost:9502 -admin-bind 0.0.0.0:19007 -register -- --log-level debug --log-path ./logs/dc2_meshgw1_logs.txt 1>./logs/dc2-meshgw1-connect.log &
CONSUL_HTTP_ADDR=localhost:9501 consul connect envoy -ignore-envoy-compatibility -gateway mesh -expose-servers -service dc2-mesh-gateway-two -address "{{ GetInterfaceIP \"lo0\" }}:9444" -wan-address "{{ GetInterfaceIP \"lo0\" }}:9444" -grpc-addr localhost:9502 -admin-bind 0.0.0.0:19008 -register -- --log-level debug --log-path ./logs/dc2_meshgw2_logs.txt 1>./logs/dc2-meshgw2-connect.log &

echo "...Starting server service and registering in secondary datacenter"

http-echo-server 3005 &
CONSUL_HTTP_ADDR=localhost:9501 consul config write static-server-service-defaults.hcl
CONSUL_HTTP_ADDR=localhost:9501 consul services register static-server.hcl
CONSUL_HTTP_ADDR=localhost:9501 consul services register static-server-sidecar-proxy.hcl
CONSUL_HTTP_ADDR=localhost:9501 consul config write proxy-defaults.hcl

CONSUL_HTTP_ADDR=localhost:9501 consul connect envoy -ignore-envoy-compatibility -sidecar-for static-server -address '{{ GetInterfaceIP "lo0" }}:9445' -admin-bind localhost:19009 -- -l critical &


# ********************************************
echo "Ready to test"

# CONSUL_HTTP_ADDR=localhost:9501 consul maint -enable -service="dc2-mesh-gateway-two"
# # Find and kill the gateway process that is in maintenance mode
# ps aux | grep dc2_meshgw2 | grep -v grep | tr -s " " | cut -d " " -f 2
# kill <pid above>


# Cleanup
# pkill node consul envoy
