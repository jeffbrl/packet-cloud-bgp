echo 'auto lo:0
  iface lo:0 inet static
  address ${elastic_ip}
  netmask 255.255.255.255' >> /etc/network/interfaces
ifup lo:0
