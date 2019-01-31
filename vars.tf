variable "packet_auth_token" {}

variable "packet_project_id" {}

variable "bgp_md5" {
  default = "passWord123"
}

# spin up hosts across two different facilities to test load balancing
variable "packet_facility1" {
  default = "ewr1"
}

variable "packet_facility2" {
  default = "dfw2"
}
