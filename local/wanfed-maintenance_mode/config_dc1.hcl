ports {
  http = 8500
  https = -1
  grpc = 8502
  grpc_tls = 8503
}
bind_addr = "127.0.0.1"
bootstrap = true
server = true
data_dir = "/tmp/consul-dc1"
datacenter = "dc1"


node_name = "primary"
ui_config {
  enabled = true
}

# Wanfed Magic
primary_datacenter = "dc1"
advertise_addr_wan = "127.0.0.1"
connect {
  enabled = true
//   enable_mesh_gateway_wan_federation = true
}
