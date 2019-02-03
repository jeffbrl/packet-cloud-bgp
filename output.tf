output "Server IP @ Facility 1" {
  value = "${packet_device.host-1.access_public_ipv4}"
}

/*
output "Server IP @ Facility 2" {
  value = "${packet_device.host-2.access_public_ipv4}"
}

*/

output "Anycast IP" {
  value = "TODO"
}
