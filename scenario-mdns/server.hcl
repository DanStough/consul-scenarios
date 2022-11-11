// This config file demonstrates a server both advertising and listening on mDNS
bind_addr = "127.0.0.1"
bootstrap_expect = 3
server = true
data_dir = "/tmp/consul-dc1"
datacenter = "dc1"
node_name = "primary"
ui_config {
  enabled = true
}
connect {
  enabled = true
}

// We need to figure out if this is the right syntax or we're missing anything
mdns {
    enabled = true
    port = 8853
    domain = "local"
    service = "consul"
}

// NEW!: we will need to specify this per the docs so that the servers can find eachother
retry_join = ["provider=my-cloud config=val config2=\"some other val\" ..."]
