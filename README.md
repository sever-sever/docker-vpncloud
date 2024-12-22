# docker-vpncloud
Docker vpncloud service

Podman build:
```
sudo podman build --net host --tag vyos-vpncloud:1.0 -f ./Dockerfile
```

# Vyos intergration:
```
mkdir -p /config/containers/vpncloud

vyos@r14# cat /config/containers/vpncloud/config.yaml
---
device:
  type: tun
  name: vpncloud%d
  path: ~
  fix-rp-filter: false
ip: 10.0.0.100
advertise-addresses: []
ifup: ~
ifdown: ~
crypto:
  password: my_password
  private-key: ~
  public-key: ~
  trusted-keys: []
  algorithms: []
listen: "3210"
peers:
  - 203.0.113.1
  - 192.0.2.1
peer-timeout: 300
keepalive: ~
beacon:
  store: ~
  load: ~
  interval: 3600
  password: ~
mode: normal
#mode: hub
switch-timeout: 300
claims: []
auto-claim: true
port-forwarding: true
pid-file: ~
stats-file: ~
statsd:
  server: ~
  prefix: ~
user: ~
group: ~
hook: ~
hooks: {}

```

# VyOS configuration:
```
set container name vpncloud allow-host-networks
set container name vpncloud capability 'net-admin'
set container name vpncloud device tun destination '/dev/net/tun'
set container name vpncloud device tun source '/dev/net/tun'
set container name vpncloud image 'localhost/vyos-vpncloud:1.0'
set container name vpncloud volume config destination '/etc/vpncloud/config.yaml'
set container name vpncloud volume config source '/config/containers/vpncloud/config.yaml'

```
