#!/bin/bash

set -e

export CLUSTER1_CONTEXT=k3d-c1
export CLUSTER2_CONTEXT=k3d-c2

kubectl --context $CLUSTER1_CONTEXT apply -f ./manifests/proxy-defaults.yaml 
kubectl --context $CLUSTER2_CONTEXT apply -f ./manifests/proxy-defaults.yaml 

kubectl --context $CLUSTER1_CONTEXT apply -f ./manifests/service-defaults.yaml 
kubectl --context $CLUSTER2_CONTEXT apply -f ./manifests/service-defaults.yaml 

kubectl --context $CLUSTER2_CONTEXT apply --filename ./manifests/backend.yaml
kubectl --context $CLUSTER2_CONTEXT apply --filename ./manifests/exported-service.yaml
kubectl --context $CLUSTER2_CONTEXT apply --filename ./manifests/intention-c2.yaml

kubectl --context $CLUSTER1_CONTEXT apply --filename ./manifests/frontend.yaml

# failover testing
# kubectl --context $CLUSTER1_CONTEXT apply --filename ./manifests/failover.yaml
