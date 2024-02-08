ID {
  Type = gvk("catalog.v2beta1.Workload")
  Name = "royco-waystar-75675f5897-22222"

//   Tenancy = {
// 	Namespace = "default"
// 	Partition = "default"
//   }
}

Data {
  Addresses = [
	{ Host = "10.0.0.2", Ports = ["public", "admin", "mesh"] }
  ]
  Ports = {
	"public" = { port = 80, protocol = "PROTOCOL_TCP" }
	"admin" = { port = 8080, protocol = "PROTOCOL_TCP" }
    "mesh" = { port = 20000, protocol = "PROTOCOL_MESH" }
  }
  Identity = "royco-waystar"
  NodeName = "k8s-node-0-virtual"
}
