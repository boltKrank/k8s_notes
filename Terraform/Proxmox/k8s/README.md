# Setting up k8s on Proxmox

Example: (https://github.com/khanh-ph/proxmox-kubernetes) and (https://www.khanhph.com/install-proxmox-kubernetes/)

### Subnets

#### vmbr1

```bash
# /etc/network/interfaces
...
...
# Dedicated internal network for Kubernetes cluster
auto vmbr10
iface vmbr10 inet static
    address  10.20.0.0/24
    bridge-ports none
    bridge-stp off
    bridge-fd 0

    post-up   echo 1 > /proc/sys/net/ipv4/ip_forward
    post-up   iptables -t nat -A POSTROUTING -s '10.20.0.0/24' -o vmbr0 -j MASQUERADE
    post-down iptables -t nat -D POSTROUTING -s '10.20.0.0/24' -o vmbr0 -j MASQUERADE
```


