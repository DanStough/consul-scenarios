# mDNS Discovery

## Links
1. [Related GitHub Issue](https://github.com/hashicorp/consul/issues/6666)
1. [cloud-auto-join docs](https://developer.hashicorp.com/consul/docs/install/cloud-auto-join)
1. [go-discover docs](https://github.com/hashicorp/go-discover)

## Requirements
1. If we start several consul agents, they should automatically be able to discover and join eachother with mDNS.
1. For `retry_join`, we use the mDNS example syntax: `provider=mdns service=consul domain=local`
1. For the mDNS server, we can specify:
        1. Port (?)
        1. Domain (?)
        1. Service (?)
1. We should be to configure mDNS from both the command line and the HCL config file.

## TODO - Next Week
1. What are all the variables that we would need to configure a mDNS server using Matt Keeler's [mDNS library](https://pkg.go.dev/github.com/hashicorp/mdns#section-readme).
See included HCL for straw man config.
1. What does the new HCL syntax look like for running the mDNS server.

## Tasks
1. [ ] Write Code
1. [ ] Manual Test
1. [ ] Make Unit tests (maybe?)
1. [ ] Write Docs
1. [ ] Make Integration tests
1. [ ] OSS <--> ENT Sync
1. [ ] Close GH issue
