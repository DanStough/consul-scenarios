ID {
  Type = gvk("catalog.v2beta1.Workload")
  Name = " royco-waystar-75675f5897-7ci7o"
  
//   Tenancy = {
// 	Namespace = "default"
// 	Partition = "default"
//     PeerName = "local"
//   }
}

Data {
  Addresses = [
	{ Host = "10.0.0.1", Ports = ["public", "admin", "mesh"] }
  ]
  Ports = {
	"public" = { port = 80, protocol = "tcp" }
	"admin" = { port = 8080, protocol = "tcp" }
    "mesh" = { port = 20000, protocol = "mesh" }
  }
  NodeName = "k8s-node-0-virtual"
}
