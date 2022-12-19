#!/bin/bash

http-echo-server 3005 &

consul config write exported-services.hcl

CONSUL_HTTP_ADDR=localhost:9500 consul services register static-client.hcl
CONSUL_HTTP_ADDR=localhost:9500 consul services register static-client-sidecar-proxy.hcl
CONSUL_HTTP_ADDR=localhost:9500 consul connect envoy -sidecar-for static-client -address '{{ GetInterfaceIP "$NETWORK_INTERFACE" }}:9446' -grpc-addr localhost:9502  -admin-bind localhost:19008 -- -l critical --log-path ~/demo/peering-meshgw/logs/dc1_static-client_logs.txt &


consul services register static-server.hcl
consul services register static-server-sidecar-proxy.hcl
consul config write static-server-service-defaults.hcl
consul connect envoy -sidecar-for static-server -address '{{ GetInterfaceIP "$NETWORK_INTERFACE" }}:8446' -grpc-addr localhost:8502 -admin-bind localhost:19009 -- -l critical --log-path ~/demo/peering-meshgw/logs/dc2_static-server_logs.txt &

# curl localhost:1234
