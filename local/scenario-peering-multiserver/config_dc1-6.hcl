ports {
  dns = 8650
  http = 8550
  https = 8551
  grpc = 8552
  grpc_tls = 8553
  serf_lan = 8351
  serf_wan = 8451
  server = 8350
}
bind_addr = "127.0.0.1"
bootstrap_expect = 3
server = true
data_dir = "/tmp/consul-dc1-six"
datacenter = "dc1"
node_name = "six"
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
