# Blocking Queries

[Consul documentation on blocking queries][1].

Below is a reference to testing blocking query APIs 

## Curl
TBD

## HTTPie

[HTTPie docs][2]

Make the initial query to the API:

```bash
http localhost:8500/v1/peerings

HTTP/1.1 200 OK
Content-Length: 3
Content-Type: application/json
Date: Thu, 09 Feb 2023 17:37:42 GMT
Vary: Accept-Encoding
X-Consul-Default-Acl-Policy: allow
X-Consul-Index: 1
X-Consul-Knownleader: true
X-Consul-Lastcontact: 0
X-Consul-Query-Backend: blocking-query

[]
```

Then make the blocking query with the index received. 
Observe that the API does not return until the timeout is reached (5m) or the query results change.

```bash
http localhost:8500/v1/peerings?index=1
```


## grpCurl

For select gRPC APIs only:
* Peering Read + List
* TrustBundle List

TBD

[1]: https://developer.hashicorp.com/consul/api-docs/features/blocking
[2]: https://httpie.io/docs/cli/universal
