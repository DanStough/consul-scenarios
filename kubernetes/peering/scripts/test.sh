#! /bin/bash

set -e 

export CLUSTER1_CONTEXT=k3d-c1

kubectl --context $CLUSTER1_CONTEXT exec -it "$(kubectl --context $CLUSTER1_CONTEXT get pod -l app=frontend -o name)" -- curl localhost:9090
