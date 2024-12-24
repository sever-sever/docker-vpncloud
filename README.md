# docker-vpncloud
Docker/podman vpncloud service with VyOS integration

Podman build:
```
wget https://raw.githubusercontent.com/sever-sever/docker-vpncloud/refs/heads/alpine/Dockerfile
sudo podman build --net host --tag vyos-vpncloud/alpine:2.3.0 -f ./Dockerfile
```

Docker build (if you use docker instead of podman)
```
docker build -t vpncloud/alpine:2.3.0 .
```

# VyOS integration:
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
set container name vpncloud image 'localhost/vyos-vpncloud/alpine:2.3.0'
set container name vpncloud volume config destination '/etc/vpncloud/config.yaml'
set container name vpncloud volume config source '/config/containers/vpncloud/config.yaml'

```

# check
```
vyos@vyos:~$ ip address show dev vpncloud0
12: vpncloud0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1427 qdisc fq_codel state UNKNOWN group default qlen 500
    link/none
    inet 10.0.0.100/24 scope global vpncloud0
       valid_lft forever preferred_lft forever
```

# tap
With device type `tap` we can use Ethernet L2 frames and, for example can use ISIS protocol.
```
# 10.0.0.100 (device type: tap)
set protocols isis interface vpncloud0
set protocols isis lsp-mtu '1410'
set protocols isis net '49.0001.1000.1000.0100.00'
set protocols isis redistribute ipv4 connected level-2

# 10.0.0.10 (device type: tap)
set protocols isis interface vpncloud0
set protocols isis net '49.0001.1000.1000.0010.00'
set protocol isis lsp-mtu 1410

```
