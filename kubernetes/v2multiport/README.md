# v2 Multiport Tests

**NOTE: THIS IS BASED OFF OF THE BETA RELEASE OF V2 IN 1.17.0**

_Based in scripts from @hashi-derek_

This demo contains a dump of v2 multiport configurations on Kubernetes.

[Docs link for v2 Multiport](https://consul-git-docs-multiport-rc-hashicorp.vercel.app/consul/docs/k8s/multiport/configure)

## Prerequisites

1. You have a kubernetes cluster available with `kubectl` configured to the correct kube-context.
    1. Consider `kind` of `k3d` for setting up a local cluster. An example setup:
        1. [Rancher Desktop](https://rancherdesktop.io/) with the Moby container runtime selected. This will also install `kubectl` and `helm`. 
        1. [k3d](https://k3d.io/) for creating a cluster with multiple nodes, which is useful for deployments in Consul that have anti-affinity. 
        1. I use this one for testing. I use this for testing: `k3d cluster create access-logs-testing --agents=3 -p "8080:30080@agent:0"`
1. You have a recent (v3) version of `helm` installed.
1. If you plan to test Consul Enterprise, create a license file named `license.txt` in this directory with your key.

## Setup and Peer the Clusters

* `./scripts/01-reset-clusters.sh`
* `./scripts/02-install-consul.sh` OR `./scripts/02-install-consul.sh ent`. See note above about license file for Consul Enterprise.
* wait for Consul to come up in both clusters...

## Testing w/ Dev Images

* [Make sure docker is configured with the k3d registry allowed as insecure](https://docs.docker.com/registry/insecure/)
* In the desired consul repo, build and push your dev image:
    * `make dev-docker && docker tag consul-dev localhost:5000/consul-dev && docker push localhost:5000/consul-dev`
* Uncomment the this line in the helm values file: `image: "k3d-registry.localhost:5000/consul-dev"`
* If you're building the kube controller as well:
    * In the kube repo ``
    * Uncomment this line in the helm values file: `imageK8s: "k3d-registry.localhost:5000/consul-k8s-controller-dev"`
    * Switch the script `./scripts/01-reset-clusters.sh` to point to your local helm repo installation.

## Scenarios

### Traffic Permissions

#### L4 Setup 
```bash

# Setup
k apply -f manifests/static-client.yaml
k apply -f manifests/static-server/static-server-tcp.yaml

# Test
k exec deploy/static-client -c static-client -- curl static-server:8080 # should return immediately with 52
k exec deploy/static-client -c static-client -- curl static-server:9090 # should return immediately with 52

k apply -f manifests/l4-traffic-permissions.yaml

k exec deploy/static-client -c static-client -- curl static-server:8080 # should succeed
k exec deploy/static-client -c static-client -- curl static-server:9090 # should return immediately with 52
```

#### L7 Setup

##### w/ L4 Permissions
```bash

# Setup
k apply -f manifests/static-client.yaml
k apply -f manifests/static-server/static-server-http.yaml

# Test
k exec deploy/static-client -c static-client -- curl static-server:8080 # should return immediately with 52
k exec deploy/static-client -c static-client -- curl static-server:9090 # should return immediately with 52

k apply -f manifests/l4-traffic-permissions.yaml

k exec deploy/static-client -c static-client -- curl static-server:8080 # should succeed
k exec deploy/static-client -c static-client -- curl static-server:9090 # should return immediately with 52
```

##### w/ L4 Permissions + Partition Scope 
```bash

# Setup
k create ns banana
k -n banana apply -f manifests/static-client.yaml
k create ns orange
k -n orange apply -f manifests/static-server/static-server-http.yaml

# Test
k -n banana exec deploy/static-client -c static-client -- curl static-server.orange:8080 # should return immediately with 52
k -n banana exec deploy/static-client -c static-client -- curl static-server.orange:9090 # should return immediately with 52

k -n orange apply -f manifests/l4-any-ns-traffic-permissions.yaml

k -n banana exec deploy/static-client -c static-client -- curl static-server.orange:8080 # should succeed
k -n banana exec deploy/static-client -c static-client -- curl static-server.orange:9090 # should return immediately with 52
```

##### w/ L7 Permissions
Not supported.

### ProxyConfiguration 

```bash
k apply -f manifests/static-client.yaml
k apply -f manifests/static-server/static-server-tcp.yaml
k apply -f manifests/l4-traffic-permissions.yaml

k apply -f manifests/proxyconfiguration-one.yaml # Observer changes to the Envoy config directly through the Envoy admin API
k apply -f manifests/proxyconfiguration-two.yaml # No change as the oldest timestamp wins

k delete -f manifests/proxyconfiguration-one.yaml # Observe the values from proxyconfiguration-two.yaml are present in the Envoy config

k delete po <static-server po> # we delete the pod to re-generate the envoy bootstrap config
# Observe the values from proxyconfiguration-two.yaml are present in the Envoy config
```

### ProxyConfiguration w/ Namespaces

```bash
k apply -f manifests/static-client.yaml
k apply -f manifests/static-server/static-server-tcp.yaml
k apply -f manifests/l4-traffic-permissions.yaml

k apply -f manifests/proxyconfiguration-one.yaml # Observer changes to the Envoy config directly through the Envoy admin API
k apply -f manifests/proxyconfiguration-two.yaml # No change as the oldest timestamp wins

k delete -f manifests/proxyconfiguration-one.yaml # Observe the values from proxyconfiguration-two.yaml are present in the Envoy config

k delete po <static-server po> # we delete the pod to re-generate the envoy bootstrap config
# Observe the values from proxyconfiguration-two.yaml are present in the Envoy config
```


## Debug Commands

```bash
# Read a resource from Consul
 k -n consul exec consul-server-0 -c consul -it -- consul resource list catalog.v2beta1.Workload

# Port forward envoy


```

