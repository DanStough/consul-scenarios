# Access Logs

This scenario sets up an example of Consul service mesh with access logs enabled.
You should change `proxy-defaults.hcl` to change the logging configuration in the mesh. 
This change will not affect Envoy admin access logs, which can only be configured at startup.

To start:
1. `./run.sh`
1. `curl -d "Hello http://localhost:1234"
1. Modify `proxy-defaults.hcl` to customize the log format.
1. `consul config write proxy-defaults.hcl`
1. Repeat!
