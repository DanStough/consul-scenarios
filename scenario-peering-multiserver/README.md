# Multi-server Peering

This scenario sets up one peering acceptor cluster with 3 server nodes. 
The idea is to manually rotate all of the servers out of the cluster and show the peerstream is maintained.
This demonstrates the peerstream sends updates of server addresses to the dialing cluster.

To rotate, start with the followers.
