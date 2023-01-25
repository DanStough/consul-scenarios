#!/bin/bash

export CLUSTER1_CONTEXT=k3d-c1

kubectl --context $CLUSTER1_CONTEXT -n consul port-forward "$(kubectl --context $CLUSTER1_CONTEXT -n consul get pod -l component=mesh-gateway -o name)" 19001:19000
