# Cluster Peering Control Plane Traffic Through Mesh Gateways

This scenario was design to be executed manually for demonstration. 
It comes in three parts:
1. Run `run.sh`, which setup clusters and mesh gateways
1. Manually execute the steps after `exit 0` in the `run.sh` to configure and peer the clusters 
1. Run `validate.sh` to setup exported services and sidecars.

If you `curl localhost:1234`, you can verify the exported service still works as expected in this arrangement.
