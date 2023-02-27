Kind = "http-route"
Name = "route-one"
Rules = [
  {
    Matches = [{
      Path = {
        Match = "exact"
        Value = "/v1"
      }
    }],
    Services = [
      {
        Name = "service-one"
      }
    ]
  },
  {
    Matches = [{
      Path = {
        Match = "exact"
        Value = "/v2"
      }
    }],
    Services = [
      {
        Name = "service-two"
      }
    ]
  },
  {
    Matches = [{
      Path = {
        Match = "exact"
        Value = "/v1"
      },
      Headers = {
        Match = "exact"
        Name  = "x-version"
        Value = "2"
      }
    }],
    Services = [
      {
        Name = "service-two"
      }
    ]
  },
  {
    Matches = [{
      Path = {
        Match = "exact"
        Value = "/v2"
      },
      Headers = {
        Match = "exact"
        Name  = "x-version"
        Value = "1"
      }
    }],
    Services = [
      {
        Name = "service-one"
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