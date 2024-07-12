# DNS Repro

This scenario set up two service instances with different tags. 
One instance is registered with the Server agent bound to `127.0.0.1`.
One instance is registered with the Client agent bound to `127.0.0.2`.

To query the DNS server for a SRV record w/ a label:
```bash
╰─ dig @127.0.0.1 -p 8600 master.postgres.service.consul. SRV
```

To query the DNS server for a A record w/o a label:
```bash
╰─ dig @127.0.0.1 -p 8600 postgres.service.consul.
```
