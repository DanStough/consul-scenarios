ports {
  dns = 8610
  http = 8510
  https = 8511
  grpc = 8512
  grpc_tls = 8513
  serf_lan = 8311
  serf_wan = 8411
  server = 8310
}
bind_addr = "127.0.0.1"
retry_join = ["127.0.0.1:8301"]
data_dir = "/tmp/consul-dc1-client"
datacenter = "dc1"
node_name = "client"
ui_config {
  enabled = true
}

# The Consul License is meant to be passed via the CONSUL_LICENSE_PATH env

