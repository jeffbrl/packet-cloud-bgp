filter packet_bgp {
  # the IP range(s) to announce via BGP from this machine
  if net = ANYCASTIP/32 then accept;
}

router id PRIVATEIP; # this server's IP address

protocol direct {
  interface "lo"; # restrict network interfaces it works with
}

protocol kernel {
  persist; # don't remove routes on bird shutdown
  scan time 10; # scan kernel routing table every 10 seconds
  import all; # default is import all
  export all; # default is export none
}

protocol device {
  scan time 10; # scan interfaces every 10 seconds
}

protocol bgp {
  export filter packet_bgp;
  local as 65000;
  neighbor NEIGHBOR as 65530;
  password "${MD5}";
}
