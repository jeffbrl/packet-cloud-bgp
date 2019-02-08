variable "packet_auth_token" {}

variable "packet_project_id" {}

variable "bgp_md5" {
  default = "ExamplePassword1234"
}

# spin up hosts across two different facilities to test load balancing
variable "packet_facility" {
  default = "ewr1"
}

variable "host-count" {
  default = "2"
}
