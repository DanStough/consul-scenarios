# This is needed to bind the gRPC endpoints to the interface instead of 
# just the loopback address
client_addr = "{{ GetPrivateInterfaces | join \"address\" \" \" }} {{ GetAllInterfaces | include \"flags\" \"loopback\" | join \"address\" \" \" }}"

# This is needed to advertise the IP address of the instance in the token
# Right now this is setup for multipass
bind_addr = "{{ GetInterfaceIP \"enp0s1\" }}"

# Peering is off by default
peering {
    enabled = true
}
