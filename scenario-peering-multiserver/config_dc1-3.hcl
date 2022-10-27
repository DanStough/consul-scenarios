ports {
  dns = 8620
  http = 8520
  https = 8521
  grpc = 8522
  grpc_tls = 8523
  serf_lan = 8321
  serf_wan = 8421
  server = 8320
}
bind_addr = "127.0.0.1"
bootstrap_expect = 3
server = true
retry_join = ["localhost:8301"]

data_dir = "/tmp/consul-dc1-three"
datacenter = "dc1"
node_name = "three"
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
