# Wan Federation - Testing Maintenance Mode

This scenario is meant to demostrate a minimal WAN Federation setup with mesh gateways. 
It's meant to test service-to-service connectivity and the maintenance mode function of gateways.

**NOTE**: This is not currently setup to have control plane traffic through mesh gateways. 
This setup would need auth-encrypt/config setup to test this appropriately, otherwise you get an error from the secondary datacenters that TLS is disabled for outbound traffic.

## Prerequisites 
1. A version of `consul` on your path
1. Envoy installed (homebrew on mac works)
1. [`http-echo-server` installed](https://github.com/watson/http-echo-server), which requires node.

## Scenerio
1. `dc1` is the primary datacenter.
    1. It has two mesh gateways registered
    1. It has a service and sidecar regsistered as `static-client`
    1. An sidecar is running.
    1. There is no client application, you can fake this by calling `http://localhost:1234`
    1. Mesh gateway settings come from `proxy-defaults.hcl` in this directory.
1. `dc2` is a secondary datacenter federated.
    1. It has two mesh gateways registered
    1. It has a service and sidecar regsistered as `static-server`
    1. An sidecar is running.
    1. There is a `http-echo-server` node process running as the server application
    1. Mesh gateway settings come from `proxy-defaults.hcl` in this directory.

## Testing

1. Clean up any previous run: `pkill node envoy consul`
1. Edit `proxy-defaults.hcl` for the gateway mode you are testing
1. Run `./runs.sh`
1. Verify you can call the upstream service across datacenters
```bash
curl -v "http://localhost:1234"
OR
http localhost:1234
```
1. Put the mesh gateway in maintenance mode using the instructions in the shell script and kill the process to simulate an upgrade:
```bash
CONSUL_HTTP_ADDR=localhost:9501 consul maint -enable -service="dc2-mesh-gateway-two"
ps aux | grep dc2_meshgw2 | grep -v grep | tr -s " " | cut -d " " -f 2
kill <pid above>
```
1. Re-verify the upstream
```bash
curl -v "http://localhost:1234"
OR
http localhost:1234
```

**NOTE**: "Remote" mode is broken now. If you observe the cluster list from the client sidecar (https://localhost:19006/clusters), you'll note that the health state of the gateway "127.0.0.1:9444" never changes when the process is killed. 
This is not the case in `local` mode, where the clusters in the mesh gateways (https://localhost:19004/clusters) will show the correct health status.
