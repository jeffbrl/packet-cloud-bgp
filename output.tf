output "Server IP @ Facility 1" {
  value = "${packet_device.host-1.access_public_ipv4}"
}

output "Server IP @ Facility 2" {
  value = "${packet_device.host-2.access_public_ipv4}"
}

output "Elastic IP @ Facility 1" {
  value = "${packet_reserved_ip_block.elastic_ip-1.cidr_notation}"
}

output "Elastic IP @ Facility 2" {
  value = "${packet_reserved_ip_block.elastic_ip-2.cidr_notation}"
}


output "Anycast IP" {
  value = "TODO"
}
