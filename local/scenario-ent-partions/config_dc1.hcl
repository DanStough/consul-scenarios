ports {
  https = 8501
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
connect {
  enabled = true
}
peering {
  enabled = true
}
