#!/bin/bash

export CLUSTER1_CONTEXT=k3d-c1

kubectl --context $CLUSTER1_CONTEXT -n consul port-forward consul-server-0 8501:8501
