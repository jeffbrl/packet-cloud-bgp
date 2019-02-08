#!/bin/bash

json=$(curl https://metadata.packet.net/metadata)
router=$(echo $json | jq -r ".network.addresses[] | select(.public == false) | .address")
gateway=$(echo $json | jq -r ".network.addresses[] | select(.public == false) | .gateway")

apt-get install -y bird

cat << EOF >> /etc/bird/bird.conf
filter packet_bgp {
    if net = ${floating_ip}/${floating_cidr} then accept;
}
router id $private_ipv4;
protocol direct {
    interface "lo";
}
protocol kernel {
    scan time 10;
    persist;
    import all;
    export all;
}
protocol device {
    scan time 10;
}
protocol bgp {
    export filter packet_bgp;
    local as 65000;
    neighbor $router as 65530;
    password "${bgp_password}";
}
EOF

# append to the interfaces file
cat << EOF >> /etc/network/interfaces

auto lo:0
iface lo:0 inet static
   address ${floating_ip}
   netmask ${floating_netmask}
EOF

sysctl net.ipv4.ip_forward=1
ifup lo:0
service bird restart

