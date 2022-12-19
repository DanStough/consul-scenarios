ports {
  dns = 9600
  http = 9500
  serf_lan = 9301
  serf_wan = 9401
  grpc = 9502
  grpc_tls = 9503
}
retry_join = ["localhost:8301"]
partition = "foo"
data_dir = "/tmp/consul-dc1-client"
bind_addr = "127.0.0.1"
datacenter = "dc1"
node_name = "client"
ui_config {
  enabled = true
}
connect {
  enabled = true
}
