service {
  id = "static-client-sidecar-proxy"
  name = "static-client-sidecar-proxy"
  kind = "connect-proxy"
  port = 19001
  proxy = {
    destination_service_name  = "static-client"
    destination_service_id    = "static-client"
    upstreams {
      local_bind_port = 1234
      destination_name = "static-server"
      destination_peer = "dialing-dc1"
    }
  }
}
