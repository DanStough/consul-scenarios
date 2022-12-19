ports {
  dns = 8620
  http = 8530
  https = 8521
  grpc = 8522
  grpc_tls = 8523
  serf_lan = 8321
  serf_wan = 8421
  server = 8320
}
bind_addr = "127.0.0.1"
retry_join = ["127.0.0.1:8301"]
server = true
data_dir = "/tmp/consul-dc1-third"
datacenter = "dc1"
node_name = "third"
ui_config {
  enabled = true
}
connect {
  enabled = true
}

peering {
  enabled = true
}
