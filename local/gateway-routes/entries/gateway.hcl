Kind = "api-gateway"
Name = "api-gateway"
Listeners = [
  {
    Name = "listener-one"
    Port     = 9090
    Protocol = "http"
    Hostname = "*.consul.local"
  },
  {
    Name = "listener-two"
    Port     = 9091
    Protocol = "http"
    Hostname = "*.consul.local"
    TLS = {
      Certificates = [
        {
          Kind = "inline-certificate"
          Name = "example"
        },
        {
          Kind = "inline-certificate"
          Name = "wildcard"
        }
      ]
    }
  }
]