Kind = "http-route"
Name = "route-two"
Rules = [
  {
    Services = [
      {
        Name = "service-one"
        Weight = 3
      },
      {
        Name = "service-two"
        Weight = 1
      }
    ]
  }
]
Parents = [{
  Name = "api-gateway"
  SectionName = "listener-one"
},{
  Name = "api-gateway"
  SectionName = "listener-two"
}]