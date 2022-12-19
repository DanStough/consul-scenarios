Kind = "exported-services"
Name = "default"

Services = [
  {
    Name      = "static-server"
    Consumers = [
      {
        Peer = "cluster-02"
      }
    ]
  }
]
