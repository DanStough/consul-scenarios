ports {
  dns = 8630
  http = 8530
  https = 8531
  grpc = 8532
  grpc_tls = 8533
  serf_lan = 8331
  serf_wan = 8431
  server = 8330
}
bind_addr = "127.0.0.1"
bootstrap_expect = 3
server = true
data_dir = "/tmp/consul-dc1-four"
datacenter = "dc1"
node_name = "four"
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
