ports {
  dns = 8690
  http = 8590
  https = 8591
  grpc = 8592
  grpc_tls = 8593
  serf_lan = 8381
  serf_wan = 8491
}
bind_addr = "127.0.0.1"
retry_join = ["localhost:8301"]

data_dir = "/tmp/consul-dc1-zero"
datacenter = "dc1"
node_name = "zero"
ui_config {
  enabled = true
}
connect {
  enabled = true
}

# verify_incoming = true
# verify_outgoing = true
# verify_server_hostname = true
# verify_incoming_https = false
# verify_incoming_rpc = true
# ca_file = "consul-agent-ca.pem"
# cert_file = "dc1-server-consul-0.pem"
# key_file = "dc1-server-consul-0-key.pem"
# auto_encrypt {
#   allow_tls = true
# }
peering {
  enabled = true
}
