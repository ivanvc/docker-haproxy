# Docker HAProxy

This is a simple docker image, that runs haproxy and forwards some selected ports
(see files/haproxy.cfg.tmpl) to different docker containers using etcd (and
confd).

It will search for directories inside `/services/boxes`. Where the last path name
is the name of the machine, the value should be a JSON with an IP.

For example:

```json
// /services/boxes/foo
{ "IP": "172.14.7.2" }
```

Then it will forward foo.example.com:3000 (assuming a DNS A record) to the foo
container. It should have Docker's network mode to host.

## Running

```
docker build -t ivan/haproxy:latest .
docker run --net=host ivan/haproxy
```

## License

MIT
