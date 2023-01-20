# Access Logs

This scenario demonstrates Envoy access logging on Kubernetes using a log aggregator, mocking an operator implementation.
This scenario will configure the following helm charts and manifests:
* consul-k8s
* loki-stack
* hashicups

## Prerequisites 

1. You have a kubernetes cluster available with `kubectl` configured to the correct kube-context.
    1. Consider `kind` of `k3d` for setting up a local cluster. An example setup:
        1. [Rancher Desktop](https://rancherdesktop.io/) with the Moby container runtime selected. This will also install `kubectl` and `helm`. 
        1. [k3d](https://k3d.io/) for creating a cluster with multiple nodes, which is useful for deployments in Consul that have anti-affinity. 
        1. I use this one for testing. I use this for testing: `k3d cluster create access-logs-testing --agents=3 -p "8080:30080@agent:0"`
1. You have a recent (v3) version of `helm` installed.

## Scenario
1. Install Consul
    <!-- 1. Install the gateway CRDS `kubectl apply --kustomize "github.com/hashicorp/consul-api-gateway/config/crd?ref=v0.5.0"` -->
    1. **TEMPORARY** Install from source since the CRDs have changed: `helm install consul ~/source/consul-k8s/charts/consul -f ./helm/consul-values.yaml --create-namespace --namespace consul`
    <!-- 1. `helm repo add hashicorp https://helm.releases.hashicorp.com `
    1. `helm repo update hashicorp`
    1. `helm install consul hashicorp/consul --namespace consul --create-namespace -f ./helm/consul-values.yaml` -->
1. Install Loki
    1. Precreate the ns for the next step `kubectl create ns loki`
    1. We need to make Consul's catalog happy with this help chart, so we're going to need to add some patches. `kubectl apply -f manifests/`
    1. `helm repo add grafana https://grafana.github.io/helm-charts`
    1. `helm repo update grafana`
    1. `helm install loki grafana/loki-stack --namespace loki --create-namespace -f ./helm/loki-values.yaml`
    1. Part 2: Some more patches for Consul:
        1. kubectl delete svc -n loki loki-headless
        1. kubectl delete svc -n loki loki-memberlist
1. Install HashiCups
    1. `kubectl apply -f ./hashicups` . These were copied from [this GitHub repo](https://github.com/hashicorp-demoapp/hashicups-setups/tree/main/local-k8s-consul-deployment/k8s).
<!-- 1. Install Wordpress
    1. `helm repo add bitnami https://charts.bitnami.com/bitnami`
    1. `helm repo update bitnami`
    1. `helm install wordpress bitnami/wordpress --namespace wordpress --create-namespace -f ./helm/wordpress-values.yaml` -->
1. Kicking the tires 🦵🛞!
    1. Grab the grafana password: `kubectl get secret --namespace loki loki-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo`
    1. Visit the Loki Dashboard:
        1. `kubectl port-forward -n loki service/loki-grafana 8443:80`
        1. Visit http://localhost:8443/grafana. User is `admin`. Password is from the previous step.
        1. Visit the "Explore" tab on the right menu bar.
        1. You can use the query builder to slice access logs, but this query will give you interesting HTTP traffic for the product API: `{app="products-api",container="consul-dataplane",stream="stdout"} | json | protocol="HTTP/1.1" | path!="/health"`
    1. With the dashboard visible, try visiting some of the HashiCups pages and watching the access logs.
        1. In a new terminal: `kubectl port-forward service/nginx 8445:80`
        1. Visit http://localhost:8445. 


## Resources
1. [Deploy Loki on Kubernetes, and monitor the logs of your pods](https://cylab.be/blog/197/deploy-loki-on-kubernetes-and-monitor-the-logs-of-your-pods)
<!-- 1. [Wordpress packaged by Bitnami](https://github.com/bitnami/charts/tree/main/bitnami/wordpress/#installing-the-chart)
1. [Control Access into the Service Mesh with Consul API Gateway](https://developer.hashicorp.com/consul/tutorials/kubernetes/kubernetes-api-gateway) -->
