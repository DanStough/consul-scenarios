ID {
  Type = gvk("catalog.v2beta1.HealthStatus")
  Name = "royco-waystar-75675f5897-22222"
  
//   Tenancy = {
// 	Namespace = "default"
// 	Partition = "default"
//   }
}

Owner {
  Type = gvk("catalog.v2beta1.Workload")
  Name = "royco-waystar-75675f5897-22222"
  
 Tenancy = {
	Namespace = "default"
	Partition = "default"
  }
}

Data {
  Type = "Kubernetes Health Check"
  Output = "Pod is Ready"
  Description = "lorem ispsum"
  Status = "HEALTH_PASSING"
}
