Kind = "exported-services"
Name = "default"

Services = [
  {
    Name      = "static-server"
    Consumers = [
      {
        PeerName = "cluster-02"
      }
    ]
  }
]
