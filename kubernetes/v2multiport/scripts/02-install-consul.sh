#!/bin/bash
set -e

DISTRO=
if [ -z "$1" ]; then :
    DISTRO="oss"
elif [ "$1" = "ent" ] || [ "$1" = "oss" ] ; then :
    DISTRO="$1"
else
    echo "usage: must provide either 'oss', 'ent' or none"
    exit 1
fi

export CLUSTER1_CONTEXT=k3d-c1

kubectl --context $CLUSTER1_CONTEXT create namespace consul

if [ "$DISTRO" = "ent" ]; then :
    kubectl --context $CLUSTER1_CONTEXT -n consul create secret generic license --from-file=license.txt
fi

export HELM_RELEASE_NAME=cluster-01
helm install ${HELM_RELEASE_NAME}  ~/source/consul-k8s/charts/consul -f "./helm/values-${DISTRO}.yaml"  --create-namespace --namespace consul --set global.datacenter=dc1 --kube-context $CLUSTER1_CONTEXT
# helm install ${HELM_RELEASE_NAME} hashicorp/consul --create-namespace --namespace consul --version "1.0.1" --values "./helm/values-${DISTRO}.yaml" --set global.datacenter=dc1 --kube-context $CLUSTER1_CONTEXT
