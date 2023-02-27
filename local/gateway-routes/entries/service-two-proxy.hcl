Service {
  Kind = "connect-proxy"
  Name = "service-two"
  ID   = "service-two"
  Port = 9009

  Proxy = {
    destination_service_name  = "service-two"
    destination_service_id    = "service-two"
    local_service_address     = "127.0.0.1"
    local_service_port        = 9008
  }
}