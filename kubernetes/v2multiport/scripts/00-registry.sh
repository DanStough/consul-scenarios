#! /bin/bash
# This is only a one-time setup for a local registry

k3d registry create -p 5000 registry.localhost
