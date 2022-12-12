# Access Logs

This scenario sets up an example of Consul service mesh with access logs enabled.
You should change `proxy-defaults.hcl` to change the logging configuration in the mesh. 
This change will not affect Envoy admin access logs, which can only be configured at startup.

To start:
1. `./run.sh`
