Service {
  Kind = "connect-proxy"
  Name = "service-one"
  ID   = "service-one"
  Port = 9001

  Proxy = {
    destination_service_name  = "service-one"
    destination_service_id    = "service-one"
    local_service_address     = "127.0.0.1"
    local_service_port        = 9002
  }
}