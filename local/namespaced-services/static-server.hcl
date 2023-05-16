service {
  id = "static-server"
  name = "static-server"
  port = 3005
  namespace = "demo"
  connect {
    sidecar_service {}
  }
}
