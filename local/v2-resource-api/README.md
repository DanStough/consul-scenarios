# V2 Resource API Testing

This demo sets the experimental V2 flag and walks through the process of manipulating V2 resources.
There is no `run.sh`, as this is intended to be used for free-form discovery.

## Prerequisites
* A recent build of Consul
* Buf CLI installed (if you run `make proto-tools` or some other proto-related target, it will be installed for you)

## gRPC Demo

Run the agent
```bash
consul agent -dev -log-level=trace -config-file config_dc1.hcl 1>./logs/dc1.log &
```

Use `buf curl` to check list the (nonexistent) workloads:
```bash
buf curl --insecure --schema ~/source/consul/proto-public --protocol grpc --http2-prior-knowledge \
--data '{"type": {"group": "catalog", "group_version": "v2beta1", "kind": "Workload"}, "tenancy": {"partition": "default", "namespace":"default"}}' \
https://localhost:8503/hashicorp.consul.resource.ResourceService/List
```

Write a workload.
```bash
buf curl --insecure --schema ~/source/consul/proto-public --protocol grpc --http2-prior-knowledge \
--data @resources/pod-workload.json \
https://localhost:8503/hashicorp.consul.resource.ResourceService/Write
```

Read a workload.
```bash
buf curl --insecure --schema ~/source/consul/proto-public --protocol grpc --http2-prior-knowledge \
--data '{"id": {"name": "royco-waystar-75675f5897-7ci7o", "type": {"group": "catalog", "group_version": "v2beta1", "kind": "Workload"}, "tenancy": {"partition": "default", "namespace":"default", "peerName": "local"}}}' \
https://localhost:8503/hashicorp.consul.resource.ResourceService/Read
```

Delete a workload.
```bash
buf curl --insecure --schema ~/source/consul/proto-public --protocol grpc --http2-prior-knowledge \
--data '{"id": {"name": "royco-waystar-75675f5897-7ci7o", "type": {"group": "catalog", "group_version": "v2beta1", "kind": "Workload"}, "tenancy": {"partition": "default", "namespace":"default", "peerName": "local"}}}' \
https://localhost:8503/hashicorp.consul.resource.ResourceService/Delete
```
