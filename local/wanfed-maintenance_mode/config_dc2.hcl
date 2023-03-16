ports {
  dns = 9600
  http = 9501
  https = -1
  serf_lan = 9301
  serf_wan = 9401
  server = 9300
  grpc = 9502
  grpc_tls = 9503
}
server = true
bootstrap = true
data_dir = "/tmp/consul-dc2"
bind_addr = "127.0.0.1"
datacenter = "dc2"
node_name = "primary"
ui_config {
  enabled = true
}

# Wanfed Magic
primary_datacenter = "dc1"
advertise_addr_wan = "127.0.0.1"
// primary_gateways = [ "127.0.0.1:8443", "127.0.0.1:8444" ]    // Won't work without TLS
retry_join_wan=["127.0.0.1:8302"]                               // Not compatible with "primary_gateways"
connect {
  enabled = true
//   enable_mesh_gateway_wan_federation = true
}
