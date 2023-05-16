# Setting up Consul server  and client agents on the same machine
While Consul in `dev` mode acts as both a server agent and a client agent, there are scenarios (for example, testing anti-entropy) in which you would like to test the interaction between a client and a server.  


## Prerequisite
You need to create a second loopback address to be able to use the same ports. 
In MacOS: 

```bash 
sudo ifconfig lo0 alias 127.0.0.2 up
```

Then run `run.sh`. To point to the client agent you can use `CONSUL_HTTP_ADDR` variable, For example: 

```bash
CONSUL_HTTP_ADDR="http://127.0.0.2:8500" consul services register <service>.hcl
```