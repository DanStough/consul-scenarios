#!/bin/bash

set -e

export CLUSTER1_CONTEXT=k3d-c1
export CLUSTER2_CONTEXT=k3d-c2

kubectl --context $CLUSTER1_CONTEXT apply -f ./manifests/mesh.yaml 
kubectl --context $CLUSTER2_CONTEXT apply -f ./manifests/mesh.yaml 

sleep 10

kubectl --context $CLUSTER1_CONTEXT apply --filename ./manifests/acceptor.yaml
sleep 5
kubectl --context $CLUSTER1_CONTEXT get secret peering-token --output yaml > ./manifests/peering-token.yaml

kubectl --context $CLUSTER2_CONTEXT apply --filename ./manifests/peering-token.yaml
kubectl --context $CLUSTER2_CONTEXT apply --filename ./manifests/dialer.yaml

sleep 5
docker network connect k3d-c1 k3d-c2-server-0
docker network connect k3d-c2 k3d-c1-server-0
