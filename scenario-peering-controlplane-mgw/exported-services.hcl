Kind = "exported-services"
Name = "default"

Services = [
  {
    Name      = "static-server"
    Consumers = [
      {
        Peer = "accepting-dc2"
      }
    ]
  }
]
