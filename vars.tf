variable "packet_auth_token" {}

variable "packet_project_id" {}

variable "bgp_md5" {
  default = "ExamplePassword1234"
}

# spin up hosts across two different facilities to test load balancing
variable "packet_facility1" {
  default = "ewr1"
}

variable "packet_facility2" {
  default = "sjc1"
}
