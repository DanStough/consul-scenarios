ports {
  dns = 8640
  http = 8540
  https = 8541
  grpc = 8542
  grpc_tls = 8543
  serf_lan = 8341
  serf_wan = 8441
  server = 8340
}
bind_addr = "127.0.0.1"
bootstrap_expect = 3
server = true
data_dir = "/tmp/consul-dc1-five"
datacenter = "dc1"
node_name = "five"
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
