# Consul Testing Scenarios

## Contributors
* @erichaberkorn
* @DanStough
* @jessingrass

## Prequisites

* On Mac, have Consul and Envoy installed via Homebrew
* On Linux, install Consul and Envoy via the package manager. Envoy won't work for `ARM64`

See `install-server.sh`.

## Basic

Run dev agent (both server and client)
```bash
consul agent -dev
```

Run in the background
```bash
consul agent -config-dir=./consul-scenarios/consul.d -dev > ./consul-scenarios/logs/test-one.log &

# Show the jobs
jobs 
# [1]+  Running                 consul agent -config-dir=./consul-scenarios/consul.d -dev > ./consul-scenarios/logs/test-one.log &

# Cancel the jobs 
fg %1
# <ctrl+c>
```

Run dev agent with configuration file 
```bash
consul agent -config-dir=./consul-scenarios/dev-peering.hcl -dev
```
 
To add a service, just use both one of the `dev`, `server` or `client` files in conjunction with the HCL service definition.
