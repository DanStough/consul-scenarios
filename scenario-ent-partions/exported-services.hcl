Kind = "exported-services"
Name = "foo"
Partition = "foo"

Services = [
  {
    Name      = "static-server"
    Consumers = [
      {
        Partition = "default"
      }
    ]
  }
]
