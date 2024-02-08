ID {
  Type = gvk("catalog.v2beta1.Service")
  Name = "royco-waystar"

//   Tenancy = {
// 	Namespace = "default"
// 	Partition = "default"
//     PeerName = "local"
//   }
}

Data {
  Workloads = {
    Prefixes = ["royco-waystar"]
  }

  Ports = [
    { VirtualPort = 8080, TargetPort = "public" },
    { TargetPort = "mesh", Protocol = "PROTOCOL_MESH" }
  ]

  VirtualIps = ["172.168.0.1"]
}
