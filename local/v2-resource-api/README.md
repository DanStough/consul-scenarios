# V2 Resource API Testing

This demo sets the experimental V2 flag and walks through the process of manipulating V2 resources.
There is no `run.sh`, as this is intended to be used for free-form discovery.

## Prerequisites
* A recent build of Consul
* Buf CLI installed (if you run `make proto-tools` or some other proto-related target, it will be installed for you)

## CLI Demo

Useful commands:
```bash
consul resource list catalog.v2beta1.Workload
consul resource list catalog.v2beta1.ServiceEndpoints // Check that the service matches workloads
consul resource apply -f resources/pod-workload.hcl
```

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

Read with ACLs enabled. (untested)
```bash
buf curl --insecure --schema ~/source/consul/proto-public --protocol grpc --http2-prior-knowledge \
--header "x-consul-token:<your token here>" \
--data @resources/pod-workload.json \
https://localhost:8503/hashicorp.consul.resource.ResourceService/Write
```

## DNS Demo

### A/AAAA Query
```bash
❯ dig @127.0.0.1 -p 8600 royco-waystar.service.consul

; <<>> DiG 9.18.21 <<>> @127.0.0.1 -p 8600 royco-waystar.service.consul
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 15083
;; flags: qr aa rd; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0
;; WARNING: recursion requested but not available

;; QUESTION SECTION:
;royco-waystar.service.consul.  IN      A

;; ANSWER SECTION:
royco-waystar.service.consul. 0 IN      A       10.0.0.1
```

### SRV Query
```bash
❯ dig @127.0.0.1 -p 8600 royco-waystar.service.consul SRV

; <<>> DiG 9.18.21 <<>> @127.0.0.1 -p 8600 royco-waystar.service.consul SRV
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 285
;; flags: qr aa rd; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 2
;; WARNING: recursion requested but not available

;; QUESTION SECTION:
;royco-waystar.service.consul.  IN      SRV

;; ANSWER SECTION:
royco-waystar.service.consul. 0 IN      SRV     1 1 20000 mesh.port.royco-waystar-75675f5897-11111.workload.consul.
royco-waystar.service.consul. 0 IN      SRV     1 1 80 public.port.royco-waystar-75675f5897-11111.workload.consul.

;; ADDITIONAL SECTION:
mesh.port.royco-waystar-75675f5897-11111.workload.consul. 0 IN A 10.0.0.1
public.port.royco-waystar-75675f5897-11111.workload.consul. 0 IN A 10.0.0.1
```

### SRV Query + Port Name
```bash
❯ dig @127.0.0.1 -p 8600 mesh.port.royco-waystar.service.consul SRV

; <<>> DiG 9.18.21 <<>> @127.0.0.1 -p 8600 mesh.port.royco-waystar.service.consul SRV
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 50324
;; flags: qr aa rd; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1
;; WARNING: recursion requested but not available

;; QUESTION SECTION:
;mesh.port.royco-waystar.service.consul.        IN SRV

;; ANSWER SECTION:
mesh.port.royco-waystar.service.consul. 0 IN SRV 1 1 20000 mesh.port.royco-waystar-75675f5897-11111.workload.consul.

;; ADDITIONAL SECTION:
mesh.port.royco-waystar-75675f5897-11111.workload.consul. 0 IN A 10.0.0.1
```
