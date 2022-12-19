service {
  id = "static-server-sidecar-proxy"
  name = "static-server-sidecar-proxy"
  kind = "connect-proxy"
  port = 8446
  partition = "foo"
  proxy = {
    destination_service_name  = "static-server"
    destination_service_id    = "static-server"
    local_service_port = 3005
  }
}
