# API Gateway Routing Demo

This folder can be leveraged to set up an API gateway that routes
to multiple HTTP-based backend services with a demonstration of our
routing rule capabilities and serving traffic via multiple bound SSL
certificates.

## Requirements

- consul 1.15+ on your path
- ncat (can be installed via `brew install nmap`)
- openssl (to regenerate certificates if needed)

## Setup

1. In one terminal run the script `./scripts/run-consul` from this directory.
2. In another terminal run all the backend services via `./scripts/run-mesh` from this directory.
3. Finally, run `./scripts/run-gateway` to run the API gateway and register all gateway-related configuration entries.
4. If for some reason you want to regenerate the certificates, modify `scripts/example.cnf` and `scripts/wildcard.cnf` and then run `./scripts/generate-certificates` from this directory.

## Testing

Once configuration is pushed down to the running gateway, you can test the bound
http routing rules with the following curls:

```bash
# Hit service-one at the /v1 path, host header is needed since we specified a host
# of *.consul.local for this gateway to service requests for
curl localhost:9090/v1 -H "host: example.consul.local"
# Hit service-two at the /v2 path
curl localhost:9090/v2 -H "host: example.consul.local"
# Hit service-two at the /v1 path by specifying an x-version header
curl localhost:9090/v1 -H "host: example.consul.local" -H "x-version: 2"
# Hit service-one at the /v2 path by specifying an x-version header
curl localhost:9090/v2 -H "host: example.consul.local" -H "x-version: 1"
# Run the following multiple times to show the 3/4 and 1/4 weighted routing
# to services one and two respectively
curl localhost:9090 -H "host: example.consul.local"

# To demo the HTTPS listeners with SNI issue the following curl -- which should
# get the wildcard certificate
curl -vk --resolve test.consul.local:9091:127.0.0.1 https://test.consul.local:9091
# Issue the following curl to demonstrate leveraging the more specific example.consul.local
# certificate.
curl -vk --resolve example.consul.local:9091:127.0.0.1 https://example.consul.local:9091
```
