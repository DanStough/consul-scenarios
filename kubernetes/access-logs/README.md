# Access Logs

This scenario demonstrates Envoy access logging on Kubernetes using a log aggregator, mocking an operator implementation.
This scenario will configure the following helm charts and manifests:
* consul-k8s w/ API gateway
* loki-stack
* hashicups

## Prerequisites 

1. You have a kubernetes cluster available with `kubectl` configured to the correct kube-context.
    1. Consider `kind` of `k3d` for setting up a local cluster. An example setup:
        1. [Rancher Desktop](https://rancherdesktop.io/) with the Moby container runtime selected. This will also install `kubectl` and `helm`. 
        1. [k3d](https://k3d.io/) for creating a cluster with multiple nodes, which is useful for deployments in Consul that have anti-affinity. 
        1. I use this one for testing. I use this for testing: `k3d cluster create access-logs-testing --agents=3 -p "8080:30080@server:0"`
1. You have a recent (v3) version of `helm` installed.

## Scenario
1. Install Consul
    1. Install the gateway CRDS `kubectl apply --kustomize "github.com/hashicorp/consul-api-gateway/config/crd?ref=v0.4.0"`
    1. **TEMPORARY** `helm install consul ~/source/consul-k8s/charts/consul -f ./helm/consul-values.yaml --create-namespace --namespace consul`
    <!-- 1. `helm repo add hashicorp https://helm.releases.hashicorp.com `
    1. `helm repo update hashicorp`
    1. `helm install consul hashicorp/consul --namespace consul --create-namespace -f ./helm/consul-values.yaml` -->
1. Install Loki
    1. Precreate the ns for the next step `kubectl create ns loki`
    1. We need to make Consul's catalog happy with this help chart, so we're going to need to add some patches. Plus we want to setup the API Gateway.  `kubectl apply -f manifests/`
    1. `helm repo add grafana https://grafana.github.io/helm-charts`
    1. `helm repo update grafana`
    1. `helm install loki grafana/loki-stack --namespace loki --create-namespace -f ./helm/loki-values.yaml`
    1. Part 2: Some more patches for Consul:
        1. kubectl delete svc -n loki loki-headless
        1. kubectl delete svc -n loki loki-memberlist

1. Install Wordpress
    1. `helm repo add bitnami https://charts.bitnami.com/bitnami`
    1. `helm repo update bitnami`
    1. `helm install wordpress bitnami/wordpress --namespace wordpress --create-namespace -f ./helm/wordpress-values.yaml`
1. Kicking the tires 🦵🛞!
    1. Grab the grafana password
    1. Visit the Loki Dashboard, http://localhost:8080/grafana
        1. This query will give you all of the HTTP traffic for wordpress: `{app="wordpress",container="consul-dataplane"} | json | __error__!="JSONParserErr"  | protocol="HTTP/1.1"`
    1. With the dashboard visible, try visiting some of the following pages and watching the access logs.
        1. Blog home page
        1. wpadmin

## Resources
1. [Deploy Loki on Kubernetes, and monitor the logs of your pods](https://cylab.be/blog/197/deploy-loki-on-kubernetes-and-monitor-the-logs-of-your-pods)
1. [Wordpress packaged by Bitnami](https://github.com/bitnami/charts/tree/main/bitnami/wordpress/#installing-the-chart)
1. [Control Access into the Service Mesh with Consul API Gateway](https://developer.hashicorp.com/consul/tutorials/kubernetes/kubernetes-api-gateway)
