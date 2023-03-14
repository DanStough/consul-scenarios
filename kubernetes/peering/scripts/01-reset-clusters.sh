#!/bin/bash

# make dev-docker && docker tag consul-dev k3d-registry.localhost:5000/consul-dev && docker push k3d-registry.localhost:5000/consul-dev
# https://docs.docker.com/registry/insecure/

k3d cluster delete c1
k3d cluster delete c2
sleep 1
k3d cluster create c1 --registry-use k3d-registry.localhost:5000
sleep 1
k3d cluster create c2 --registry-use k3d-registry.localhost:5000
