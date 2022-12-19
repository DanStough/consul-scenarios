ports {
  dns = 9600
  http = 9500
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
node_name = "secondary"
ui_config {
  enabled = true
}
connect {
  enabled = true
}

peering {
  enabled = true
}
