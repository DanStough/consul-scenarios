#!/bin/bash

export CLUSTER1_CONTEXT=k3d-c1

kubectl --context $CLUSTER1_CONTEXT port-forward "$(kubectl --context $CLUSTER1_CONTEXT get pod -l app=frontend -o name)" 19000:19000 9090:9090
