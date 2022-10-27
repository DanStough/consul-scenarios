ports {
  dns = 9600
  http = 9500
  serf_lan = 9301
  serf_wan = 9401
  server = 9300
  grpc = 9502
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

# verify_incoming = true
# verify_outgoing = true
# verify_server_hostname = true
# ca_file = "consul-agent-ca.pem"
# cert_file = "dc2-server-consul-0.pem"
# key_file = "dc2-server-consul-0-key.pem"
# auto_encrypt {
#   allow_tls = true
# }
peering {
  enabled = true
}
