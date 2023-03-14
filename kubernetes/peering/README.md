# Peering

_From @hashi-derek_

This demo contains a number of different variations on peering two kubernetes clusters.

## Prerequisites

1. You have a kubernetes cluster available with `kubectl` configured to the correct kube-context.
    1. Consider `kind` of `k3d` for setting up a local cluster. An example setup:
        1. [Rancher Desktop](https://rancherdesktop.io/) with the Moby container runtime selected. This will also install `kubectl` and `helm`. 
        1. [k3d](https://k3d.io/) for creating a cluster with multiple nodes, which is useful for deployments in Consul that have anti-affinity. 
        1. I use this one for testing. I use this for testing: `k3d cluster create access-logs-testing --agents=3 -p "8080:30080@agent:0"`
1. You have a recent (v3) version of `helm` installed.
1. If you plan to test Consul Enterprise, create a license file named `license.txt` in this directory with your key.

## Setup and Peer the Clusters

* `./scripts/00-registry.sh` <-- This step only needs to be performed once.
* `./scripts/01-reset-clusters.sh`
* `./scripts/02-install-consul.sh` OR `./scripts/02-install-consul.sh ent`. See note above about license file for Consul Enterprise.
* wait for Consul to come up in both clusters...
* `./scripts/03-peer.sh`
* `./scripts/04-conf.sh`

For debuggig, consider using the following aliases:
* `source ./scripts/alias.sh`. **Note**: this will only work when you `source` the script.

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

The default `./scripts/04-conf.sh` script will deploy a service-default name

### Upstream Overrides

Under construction.


### Failover

Under construction.
Apply the `./manifests/failover.yaml`.
