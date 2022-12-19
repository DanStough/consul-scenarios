# Multi-server Peering

**[This is now part of integration test](https://github.com/hashicorp/consul/blob/main/test/integration/consul-container/test/peering/rotate_server_and_ca_then_fail_test.go)**

This scenario sets up one peering acceptor cluster with 3 server nodes. 
The idea is to manually rotate all of the servers out of the cluster and show the peerstream is maintained.
This demonstrates the peerstream sends updates of server addresses to the dialing cluster.

To rotate, start with the followers.
