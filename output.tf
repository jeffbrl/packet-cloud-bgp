output "Server Public IP" {
  value = "${packet_device.anycast.access_public_ipv4}"
}

output "Anycast IP" {
  value = "${cidrhost(packet_reserved_ip_block.elastic_ip.cidr_notation,0)}"
}


